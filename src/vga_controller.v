module vga_controller(
    input wire clk,
    output reg hsync,
    output reg vsync,
    output reg [9:0] h_count,
    output reg [9:0] v_count,
);

    // See https://www.dmi.unict.it/santoro/teaching/sdl/slides/VGA_timing.pdf
    // for a VGA timing diagram.
    //
    // This controller uses the 640x480 @ 60 Hz configuration.

    localparam H_RES = 640;
    localparam V_RES = 480;

    localparam H_FRONT_PORCH = 16;
    localparam H_BACK_PORCH = 48;
    localparam V_FRONT_PORCH = 10;
    localparam V_BACK_PORCH = 33;

    localparam H_SYNC_PULSE_WIDTH = 96;
    localparam V_SYNC_PULSE_WIDTH = 2;

    localparam H_SYNC_START = H_FRONT_PORCH + H_RES;
    localparam H_SYNC_END = H_SYNC_START + H_SYNC_PULSE_WIDTH - 1;
    localparam H_MAX = H_FRONT_PORCH + H_RES + H_BACK_PORCH + H_SYNC_PULSE_WIDTH - 1;
    localparam V_SYNC_START = V_FRONT_PORCH + V_RES;
    localparam V_SYNC_END = V_SYNC_START + V_SYNC_PULSE_WIDTH - 1;
    localparam V_MAX = V_FRONT_PORCH + V_RES + V_BACK_PORCH + V_SYNC_PULSE_WIDTH - 1;

endmodule
