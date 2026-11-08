module renderer #(
    parameter VGA_H_RES = 640,
    parameter VGA_V_RES = 480,
    parameter PADDLE_WIDTH = 0,
    parameter PADDLE_HEIGHT = 0,
    parameter BALL_SIZE = 0,
    parameter LINE_WIDTH = 4,
    parameter PLAYER_X = 0,
    parameter AI_X = 0
)(
    input wire        clk,
    input wire        video_en,
    input wire  [9:0] h_count,
    input wire  [9:0] v_count,
    input wire  [9:0] player_y,
    input wire  [9:0] ai_y,
    input wire  [9:0] ball_x,
    input wire  [9:0] ball_y,
    input wire  [2:0] player_score,
    input wire  [2:0] ai_score,
    output reg  [1:0] r,
    output reg  [1:0] g,
    output reg  [1:0] b
);

    wire is_player = ((h_count >= PLAYER_X && h_count < PLAYER_X + PADDLE_WIDTH) && (v_count >= player_y && v_count < player_y + PADDLE_HEIGHT));
    wire is_ai = ((h_count >= AI_X && h_count < AI_X + PADDLE_WIDTH) && (v_count >= ai_y && v_count < ai_y + PADDLE_HEIGHT));
    wire is_ball = ((h_count >= ball_x && h_count < ball_x + BALL_SIZE) && (v_count >= ball_y && v_count < ball_y + BALL_SIZE));
    wire is_line = (h_count >= ((VGA_H_RES >> 1) - (LINE_WIDTH / 2))) && (h_count < ((VGA_H_RES >> 1) + (LINE_WIDTH - (LINE_WIDTH / 2)))) && v_count[4];
    wire is_player_score = (v_count >= 24 && v_count < 40) && (
        (player_score > 0 && h_count >= 280 && h_count < 292) ||
        (player_score > 1 && h_count >= 256 && h_count < 268) ||
        (player_score > 2 && h_count >= 232 && h_count < 244)
    );
    wire is_ai_score = (v_count >= 24 && v_count < 40) && (
        (ai_score > 0 && h_count >= 348 && h_count < 360) ||
        (ai_score > 1 && h_count >= 372 && h_count < 384) ||
        (ai_score > 2 && h_count >= 396 && h_count < 408)
    );

    always @(posedge clk) begin
        if (!video_en) begin
            // Blanking period
            r <= 2'b00;
            g <= 2'b00;
            b <= 2'b00;
        end else begin
            if (is_ball) begin
                r <= 2'b11; g <= 2'b11; b <= 2'b00; // Ball
            end else if (is_player) begin
                r <= 2'b00; g <= 2'b11; b <= 2'b00; // Player
            end else if (is_ai) begin
                r <= 2'b00; g <= 2'b11; b <= 2'b00; // AI
            end else if (is_player_score || is_ai_score) begin
                if ((player_score >= 3) || (ai_score >= 3)) begin // Scores (dots)
                    r <= 2'b11; g <= 2'b00; b <= 2'b00;
                end else begin
                    r <= 2'b11; g <= 2'b11; b <= 2'b11;
                end
            end else if (is_line) begin
                r <= 2'b10; g <= 2'b10; b <= 2'b10; // Dotted line
            end else begin
                r <= 2'b00; g <= 2'b00; b <= 2'b00; // Background
            end
        end
    end

    initial begin
        r = 2'b00;
        g = 2'b00;
        b = 2'b00;

        // should_draw = 0;
    end

endmodule
