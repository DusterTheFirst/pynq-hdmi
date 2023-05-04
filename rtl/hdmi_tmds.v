`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2023 08:11:12 AM
// Design Name: 
// Module Name: hdmi_tmds
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


module hdmi_tmds(    
    input [3:0] btn,
    input [1:0] sw,
    
    // Clock lines
    input hdmi_tdms_clock,
    input hdmi_pixel_clock,
    
    // CEC
    output hdmi_tx_cec,
    // Data lines
    output reg [2:0] hdmi_tx_d,
    // Hot plug detect
    input hdmi_tx_hpdn
);

reg [9:0] word_r, word_g, word_b;
reg [9:0] word_r_next, word_g_next, word_b_next;
reg [3:0] shifts;

always @(posedge hdmi_tdms_clock) begin
    hdmi_tx_d[0] <= word_r[0];
    hdmi_tx_d[1] <= word_g[0];
    hdmi_tx_d[2] <= word_b[0];
    
    if (shifts <= 1) begin
        word_r <= word_r_next;
        word_g <= word_g_next;
        word_b <= word_b_next;
        
        shifts <= 8;
    end else begin
        word_r <= word_r << 1;
        word_g <= word_g << 1;
        word_b <= word_b << 1;
    
        shifts <= shifts - 1;
    end
end

always @(posedge hdmi_pixel_clock) begin
    word_r_next <= {btn, btn, sw};
    word_g_next <= {btn, btn, sw};
    word_b_next <= {btn, btn, sw};
end
    
endmodule