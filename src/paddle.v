module paddle #(
    parameter WIDTH = 16,
    parameter HEIGHT = 80,
    // The paddles cannot move horizontally, so there is no point in storing 
    // the position in a 10-bit variable. Instead, just use a parameter.
    parameter X,
    parameter START_Y,
    parameter SPEED = 2
)(
    input wire              clk,
    input wire signed [1:0] move_dir.
    output reg        [9:0] y,
)

    always @(posedge clk) begin
        if (move_dir > 0) begin
            y <= y - SPEED;
        end else if (move_dir < 0) begin
            y < = y + SPEED;
        end
    end

    initial begin
        y = START_Y;
    end

endmodule
