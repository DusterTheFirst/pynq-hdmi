`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2023 12:24:02 PM
// Design Name: 
// Module Name: byte_to_tmds
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module byte_to_tmds(
    input pixel_clock,
    input [7:0] input_byte,
    input video_data_enable, c0, c1,
    output reg [9:0] output_tmds
);
    function [3:0] count_ones(input [7:0] word);
        integer i;
        begin
            count_ones = 0;
            for (i = 0; i < 8; i = i + 1) begin
                count_ones = count_ones + word[i];
            end
        end
    endfunction

    reg [3:0] stage1_byte_ones = 4'b0000;
    reg [7:0] stage1_byte = 8'b00000000;
    reg stage1_video_data_enable = 1'b0, stage1_c0 = 1'b0, stage1_c1 = 1'b0;

    // Pipeline stage 1: minimize transitions
    always @(posedge pixel_clock) begin
        stage1_video_data_enable <= video_data_enable;
        stage1_c0 <= c0;
        stage1_c1 <= c1;

        stage1_byte <= input_byte;
        stage1_byte_ones <= count_ones(input_byte);
    end

    // XOR and XNOR encoding
    reg [8:0] stage1_encoded_xor = 9'b000000000, stage1_encoded_xnor = 9'b000000000;

    reg stage1_choose_xnor = 1'b0;
    reg [8:0] stage1_encoded = 9'b000000000;
    reg [3:0] stage1_encoded_ones = 4'b0000;

    integer i;

    always @(*) begin
        stage1_encoded_xor[0] = stage1_byte[0];
        for (i = 1; i < 8; i = i + 1) begin
            stage1_encoded_xor[i] = stage1_encoded_xor[i - 1] ^ stage1_byte[i];
        end
        stage1_encoded_xor[8] = 1;

        stage1_encoded_xnor[0] = stage1_byte[0];
        for (i = 1; i < 8; i = i + 1) begin
            stage1_encoded_xnor[i] = stage1_encoded_xnor[i - 1] ~^ stage1_byte[i];
        end
        stage1_encoded_xnor[8] = 0;

        // Select one of the two encoding options based on the input bit count
        // "Borrowed" from https://github.com/Digilent/vivado-library/blob/3819e788427d0f70f8d7948c38bcd97b26925157/ip/rgb2dvi/src/TMDS_Encoder.vhd#L134
        stage1_choose_xnor = stage1_byte_ones > 4 || (stage1_byte_ones == 4 && stage1_byte[0] == 0);
        stage1_encoded = stage1_choose_xnor ? stage1_encoded_xnor : stage1_encoded_xor;
        stage1_encoded_ones = count_ones(stage1_encoded[7:0]); // Only the data bits
    end


    reg [3:0] stage2_encoded_ones = 4'b0000, stage2_encoded_zeros = 4'b0000;
    reg [8:0] stage2_encoded = 9'b000000000;
    reg stage2_video_data_enable = 1'b0, stage2_c0 = 1'b0, stage2_c1 = 1'b0;

    // Pipeline stage 2: balance DC
    always @(posedge pixel_clock) begin
        stage2_encoded_ones <= stage1_encoded_ones;
        stage2_encoded_zeros <= 8 - stage1_encoded_ones;

        stage2_encoded <= stage1_encoded;

        stage2_video_data_enable <= stage1_video_data_enable;
        stage2_c0 <= stage1_c0;
        stage2_c1 <= stage1_c1;
    end

    reg stage2_currently_balanced = 1'b0, stage2_output_needs_inversion = 1'b0;
    reg [9:0] stage2_tdms = 10'b0000000000;
    reg signed [4:0] stage2_dc_bias = 5'b00000, stage2_running_dc_bias = 5'b00000;

    reg signed [4:0] stage3_running_dc_bias = 5'b00000; // Used in stage 2 to read the previous bias

    always @(*) begin
        stage2_currently_balanced = stage3_running_dc_bias == 0 || stage2_encoded_ones == 4;
        stage2_output_needs_inversion = (stage3_running_dc_bias > 0 && stage2_encoded_ones > 4) // too many 1's
        || (stage3_running_dc_bias < 0 && stage2_encoded_ones < 4); // too many 0's;

        // difference in encoded ones and encoded zeros
        stage2_dc_bias = $signed({1'b0, stage2_encoded_zeros}) - $signed({1'b0, stage2_encoded_ones});

        if (!stage2_video_data_enable) begin
            // Control period
            case ({stage2_c0, stage2_c1})
                2'b00: stage2_tdms = 10'b0010101011;
                2'b01: stage2_tdms = 10'b0010101010;
                2'b10: stage2_tdms = 10'b1101010100;
                2'b11: stage2_tdms = 10'b1101010101;
            endcase

            stage2_running_dc_bias = 5'b00000;
        end else if (stage2_currently_balanced) begin
            // XOR or XNOR
            if (stage2_encoded[8]) begin
                stage2_tdms = {1'b0, 1'b1, stage2_encoded[7:0]};
                stage2_running_dc_bias = stage3_running_dc_bias - stage2_dc_bias;
            end else begin
                stage2_tdms = {1'b1, 1'b0, ~stage2_encoded[7:0]};
                stage2_running_dc_bias = stage3_running_dc_bias + stage2_dc_bias;
            end
        end else if (stage2_output_needs_inversion) begin
            stage2_tdms = {1'b1, stage2_encoded[8], ~stage2_encoded[7:0]};
            stage2_running_dc_bias = stage3_running_dc_bias + $signed({1'b0, stage2_encoded[8], 1'b0}) + stage2_dc_bias;
        end else begin
            stage2_tdms = {1'b0, stage2_encoded[8], stage2_encoded[7:0]}; // DC balanced
            stage2_running_dc_bias = stage3_running_dc_bias - $signed({1'b0, ~stage2_encoded[8], 1'b0}) - stage2_dc_bias;
        end
    end


    // Pipeline stage 3: output
    always @(posedge pixel_clock) begin
        stage3_running_dc_bias <= stage2_running_dc_bias;
        output_tmds <= stage2_tdms;
    end

endmodule
