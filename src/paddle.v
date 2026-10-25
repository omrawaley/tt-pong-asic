module paddle #(
    parameter WIDTH = 1,
    parameter HEIGHT = 1,
    // The paddles cannot move horizontally, so there is no point in storing 
    // the position in a 10-bit variable. Instead, just use a parameter.
    parameter X = 0,
    parameter START_Y = 0,
    parameter SPEED = 1,
    // Needed to determine the boundaries of where the paddle can move.
    parameter VGA_V_RES = 480
)(
    input wire              clk,
    input wire              tick,
    input wire signed [1:0] move_dir,
    output reg        [9:0] y
);

    always @(posedge clk) begin
        if (tick) begin
            if (move_dir > 0 && y > 0) begin
                y <= y - SPEED;
            end else if (move_dir < 0 && y + HEIGHT < VGA_V_RES) begin
                y <= y + SPEED;
            end
        end
    end

    initial begin
        y = START_Y;
    end

endmodule
