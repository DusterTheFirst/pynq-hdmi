`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2023 10:15:35 AM
// Design Name: 
// Module Name: hdmi
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


module hdmi(
input [3:0] btn,
    input [1:0] sw,
    
//    output [3:0] led,
//    output led4_b, led4_g, led4_r, led5_b, led5_g, led5_r,
    
    input hdmi_pixel_clock,
    input hdmi_tdms_clock,
    
    // CEC
    output hdmi_tx_cec,
    // Clock lines
    output hdmi_tx_clk_n, hdmi_tx_clk_p,
    // Data lines
    output [2:0] hdmi_tx_d_n, [2:0] hdmi_tx_d_p,
    // Hot plug detect
    input hdmi_tx_hpdn
);

OBUFDS hdmi_tx_clk_buf(
    .O  (hdmi_tx_clk_p),
    .OB (hdmi_tx_clk_n),
    .I  (hdmi_tdms_clock)
);

wire [2:0] hdmi_tx_d;

OBUFDS hdmi_tx_d_buf[2:0] (
    .O  (hdmi_tx_d_p),
    .OB (hdmi_tx_d_n),
    .I  (hdmi_tx_d)
);

hdmi_tmds hdmi_tmds(    
    .btn(btn),
    .sw(sw),
    
    .hdmi_tdms_clock(hdmi_tdms_clock),
    .hdmi_pixel_clock(hdmi_pixel_clock),

    .hdmi_tx_cec(hdmi_tx_cec),
    .hdmi_tx_d(hdmi_tx_d),
    .hdmi_tx_hpdn(hdmi_tx_hpdn)
);

endmodule
