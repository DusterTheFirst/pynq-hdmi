`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2023 05:37:40 PM
// Design Name: 
// Module Name: diff_buf
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


module diff_buf#(
    WIDTH=3
)(
    input[WIDTH - 1:0] I,
    output [WIDTH - 1:0] O, [WIDTH - 1:0] OB
);

OBUFDS inst [WIDTH -1:0] (
    .O  (O),
    .OB (OB),
    .I  (I)
);

endmodule

