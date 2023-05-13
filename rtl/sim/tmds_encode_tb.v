`timescale 1ns / 1ps

module tmds_encode_tb();
    wire [9:0] output_tmds, output_tmds_reference;
    reg pixel_clock, video_data_enable, c0, c1;
    reg [7:0] input_byte;
    
    reg implementations_agree;

    byte_to_tmds tmds_instance(
        .output_tmds(output_tmds),

        .pixel_clock(pixel_clock),
        .video_data_enable(video_data_enable),
        .c0(c0),
        .c1(c1),
        .input_byte(input_byte)
    );

    TMDS_Encoder tmds_reference_instance(
        .pDataOutRaw(output_tmds_reference),

        .PixelClk(pixel_clock),
        .pVde(video_data_enable),
        .pC0(c0),
        .pC1(c1),
        .pDataOut(input_byte)
    );

    always begin
        pixel_clock = 0; #10;
        implementations_agree = output_tmds == output_tmds_reference;

        pixel_clock = 1; #10;
        implementations_agree = output_tmds == output_tmds_reference;
    end

    initial begin
        video_data_enable = 1;
        c0 = 0;
        c1 = 0;
        
        input_byte = 8'd0;
        #20;#20;#20;#20;
        #20;#20;#20;#20;
        
        input_byte = 0;
        while (input_byte < 8'b11111111) begin
            input_byte = input_byte + 1;
            #20;
        end
        #20;

        input_byte = 8'd0;
        #20;#20;#20;#20;
        #20;#20;#20;#20;

        video_data_enable = 0;
        c0 = 0;
        c1 = 0;
        #20;
        
        c0 = 1;
        c1 = 0;
        #20;
        
        c0 = 0;
        c1 = 1;
        #20;
        
        c0 = 1;
        c1 = 1;
        #20;
        
        video_data_enable = 1;
        c0 = 0;
        c1 = 0;
        input_byte = 8'd0;
        #20;#20;#20;#20;
        #20;#20;#20;#20;
        
        input_byte = 8'b10000000;
        while (input_byte > 8'b00000000) begin
            input_byte = input_byte >> 1;
            #20;
        end
        #20;

        input_byte = 8'd0;
        #20;#20;#20;#20;
        #20;#20;#20;#20;

        $finish;

    end

endmodule
