`timescale 1ns / 1ps

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

