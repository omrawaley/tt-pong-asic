/*
 * Copyright (c) 2026 Om Rawaley
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_omrawaley_pong (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire [1:0] r;
  wire [1:0] g;
  wire [1:0] b;

  wire hsync;
  wire vsync;
  wire [9:0] h_count;
  wire [9:0] v_count;
  wire video_en;

  vga_controller vga_cont(
    .clk(clk),
    .rst_n(rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .h_count(h_count),
    .v_count(v_count),
    .video_en(video_en),
  );

  // Quick color test (temporary)
  assign r = video_en ? 2'b11 : 2'b00;
  assign g = video_en ? 2'b00 : 2'b00;
  assign b = video_en ? 2'b01 : 2'b00;

  // Tiny VGA PMOD: https://github.com/mole99/tiny-vga
  assign uo_out = {r[1], g[1], b[1], vsync, r[0], g[0], b[0], hsync};

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
