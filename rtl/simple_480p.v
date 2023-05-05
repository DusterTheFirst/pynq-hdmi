`timescale 1ns / 1ps

module simple_480p (
    input  wire clk_pix,        // pixel clock
    input  wire rst_pix,        // reset in pixel clock domain
    output reg  [9:0] screen_x, // horizontal screen position
    output reg  [9:0] screen_y, // vertical screen position
    output reg  hsync,          // horizontal sync
    output reg  vsync,          // vertical sync
    output reg  data_enable     // data enable (low in blanking interval)
);

    // horizontal timings
    localparam HA_END = 639;           // end of active pixels
    localparam HS_STA = HA_END + 16;   // sync starts after front porch
    localparam HS_END = HS_STA + 96;   // sync ends
    localparam LINE   = 799;           // last pixel on line (after back porch)

    // vertical timings
    localparam VA_END = 479;           // end of active pixels
    localparam VS_STA = VA_END + 10;   // sync starts after front porch
    localparam VS_END = VS_STA + 2;    // sync ends
    localparam SCREEN = 524;           // last line on screen (after back porch)

    always @(*) begin
        hsync = ~(screen_x >= HS_STA && screen_x < HS_END);  // invert: negative polarity
        vsync = ~(screen_y >= VS_STA && screen_y < VS_END);  // invert: negative polarity
        data_enable = (screen_x <= HA_END && screen_y <= VA_END);
    end

    // calculate horizontal and vertical screen position
    always @(posedge clk_pix) begin
        if (rst_pix) begin
            screen_x <= 0;
            screen_y <= 0;
        end else if (screen_x == LINE) begin  // last pixel on line?
            screen_x <= 0;
            
            if (screen_y == SCREEN) begin
                screen_y <= 0;
            end else begin
                screen_y <= screen_y + 1;  // last line on screen?
            end
        end else begin
            screen_x <= screen_x + 1;
        end
    end
endmodule
