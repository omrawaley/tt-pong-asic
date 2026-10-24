module ticker#(
    parameter COUNT_MAX = 2000000
) (
    input wire  clk,
    input wire  rst_n,
    output wire tick
);

    reg [31:0] count;

    assign tick = (count >= COUNT_MAX) ? 1 : 0;

    always @(posedge clk) begin
        if (~rst_n) begin
            count <= 0;
        end else if (count >= COUNT_MAX) begin
            count <= 0;
        end else begin
            count <= count + 1;
        end
    end

endmodule
