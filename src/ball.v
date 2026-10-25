module ball #(
    parameter SIZE = 1,
    parameter START_X = 0,
    parameter START_Y = 0,
    parameter SPEED = 1,
    // Needed to determine the boundaries of where the ball can move.
    parameter VGA_H_RES = 640,
    parameter VGA_V_RES = 480
    // parameter PLAYER_X = 0,
    // parameter AI_X = 0
)(
    input wire clk,
    input wire tick,
    output reg [9:0] x,
    output reg [9:0] y
);

    reg move_right;
    reg move_down;

    always @(posedge clk) begin
        if (tick) begin
            if (move_right) begin
                if (x + SIZE < VGA_H_RES) begin
                    x = x + SPEED;
                end
            end else begin
                if (x > 0) begin
                    x = x - SPEED;
                end
            end

            if (move_down) begin
                if (y + SIZE < VGA_V_RES) begin
                    y = y + SPEED;
                end
            end else begin
                if (y > 0) begin
                    y = y - SPEED;
                end
            end

            if (y == 0) begin
                move_down = 1;
            end else if (y + SIZE == VGA_H_RES) begin
                move_down = 0;
            end
        end
    end

    initial begin
        x = START_X;
        y = START_Y;

        move_right = 1;
        move_down = 1;
    end

endmodule
