module vga_controller(
    input wire clk,
    input reg [1:0] r,
    input reg [1:0] g,
    input reg [1:0] b,
    input wire hsync,
    input wire vsync,
    input reg [9:0] h_count,
    input reg [9:0] v_count,
    input wire [7:0] uo_out,
);

    localparam H_RES = 640;
    localparam V_RES = 480;

    localparam H_FRONT_PORCH = 16;
    localparam H_BACK_PORCH = 48;
    localparam V_FRONT_PORCH = 10;
    localparam V_BACK_PORCH = 33;

    localparam H_SYNC_PULSE_WIDTH = 96;
    localparam V_SYNC_PULSE_WIDTH = 2;

endmodule
