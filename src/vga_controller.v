module vga_controller(
    input wire clk,
    output reg hsync,
    output reg vsync,
    output reg [9:0] h_count,
    output reg [9:0] v_count,
    output video_en,
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

    reg h_reached_end = (hsync == H_SYNC_END) ? 1 : 0;
    reg v_reached_end = (vsync == v_SYNC_END) ? 1 : 0;

    always @(posedge clk) begin
        // Update horizontal beam position.
        if (h_reached_end) begin
            h_count <= 0;
        end else begin
            h_count <= h_count + 1;
        end

        // Update vertical beam position.
        if (v_reached_end) begin
            v_count <= 0;
        end else begin
            v_count <= v_count + 1;
        end

        // Update HSYNC and VSYNC signals based on the current beam position.
        // These signals are active-low which is why they are inverted.
        hsync <= ~(h_count >= H_SYNC_START && h_count <= H_SYNC_END);
        vsync <= ~(v_count >= V_SYNC_START && v_count <= V_SYNC_END);
    end

    // Enable the video only if the current frame should be visible.
    assign video_end = (h_count < H_RES) && (v_count < V_RES);

endmodule
