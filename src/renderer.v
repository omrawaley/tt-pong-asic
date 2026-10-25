module renderer #(
    parameter VGA_H_RES = 640,
    parameter VGA_V_RES = 480,
    parameter PADDLE_WIDTH = 0,
    parameter PADDLE_HEIGHT = 0,
    parameter BALL_SIZE = 0,
    parameter PLAYER_X = 0,
    parameter AI_X = 0
)(
    input wire        clk,
    input wire        video_en,
    input wire  [9:0] h_count,
    input wire  [9:0] v_count,
    input wire  [9:0] player_y,
    input wire  [9:0] ai_y
    input wire  [9:0] ball_x,
    input wire  [9:0] ball_y,
    output reg  [1:0] r,
    output reg  [1:0] g,
    output reg  [1:0] b,
);

    reg should_draw;

    always @(posedge clk) begin
        if (video_en) begin
            if (((h_count >= PLAYER_X && h_count < PLAYER_X + PADDLE_WIDTH) && (v_count >= player_y && v_count < player_y + PADDLE_HEIGHT)) || ((h_count >= AI_X && h_count < AI_X + PADDLE_WIDTH) && (v_count >= ai_y && v_count < ai_y + PADDLE_HEIGHT)) || ((h_count >= ball_x && h_count < ball_x + BALL_SIZE) && (v_count >= ball_y && v_count < ball_y + BALL_SIZE))) begin
                should_draw <= 1;
            end else begin
                should_draw <= 0; // Negative space
            end
        end else begin
            should_draw <= 0; // Blanking period
        end

        if (should_draw) begin
            r <= 2'b11;
            g <= 2'b11;
            b <= 2'b11;
        end else begin
            r <= 2'b00;
            g <= 2'b00;
            b <= 2'b00;
        end
    end

    initial begin
        r = 2'b00;
        g = 2'b00;
        b = 2'b00;

        should_draw = 0;
    end

endmodule
