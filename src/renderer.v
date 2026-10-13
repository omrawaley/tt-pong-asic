module renderer #(
    parameter VGA_H_RES = 640,
    parameter VGA_V_RES = 480,
    parameter PADDLE_WIDTH = 0,
    parameter PADDLE_HEIGHT = 0
)(
    input wire        clk,
    input wire        video_en,
    input wire  [9:0] h_count,
    output wire [9:0] v_count,
    output reg  [1:0] r,
    output reg  [1:0] g,
    output reg  [1:0] b,
    input reg   [9:0] player_y,
    input reg   [9:0] ai_y
);

    initial begin
        r = 2'b00;
        g = 2'b00;
        b = 2'b00;
    end

endmodule
