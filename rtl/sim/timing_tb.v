`timescale 1ns / 1ps

module timing_tb();

    reg reset, clk;
    wire [9:0] screen_x, screen_y;
    wire hsync, vsync, data_enable;

    simple_480p timer(
        .rst_pix(reset),
        .clk_pix(clk),

        .screen_x(screen_x),
        .screen_y(screen_y),
        .hsync(hsync),
        .vsync(vsync),
        .data_enable(data_enable)
    );

    always begin
        clk = 1; #5;
        clk = 0; #5;
    end

    initial begin
        reset = 1; #10;
        reset = 0; #(10 * 1000000)

        $finish;

    end

endmodule
