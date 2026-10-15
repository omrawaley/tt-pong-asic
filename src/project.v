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

  localparam VGA_H_RES = 640;
  localparam VGA_V_RES = 480;

  localparam PADDLE_WIDTH = 16;
  localparam PADDLE_HEIGHT = 48;

  localparam PLAYER_START_X = 0;
  localparam AI_START_X = VGA_H_RES - PADDLE_WIDTH;

  reg [1:0] r;
  reg [1:0] g;
  reg [1:0] b;

  wire hsync;
  wire vsync;
  wire [9:0] h_count;
  wire [9:0] v_count;
  wire video_en;

  vga_controller #(
    .H_RES(VGA_H_RES),
    .V_RES(VGA_V_RES)
  ) vga_controller_signal (
    .clk(clk),
    .rst_n(rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .h_count(h_count),
    .v_count(v_count),
    .video_en(video_en)
  );

  wire [9:0] player_y;
  wire [9:0] ai_y;

  paddle #(
    .WIDTH(PADDLE_WIDTH),
    .HEIGHT(PADDLE_HEIGHT),
    .X(PLAYER_START_X),
    .START_Y(0),
    .VGA_V_RES(VGA_V_RES)
  ) player (
    .clk(clk),
    .move_dir(ui_in[0] ? 1 : -1),
    .y(player_y)
  )
  ;
  paddle #(
    .WIDTH(PADDLE_WIDTH),
    .HEIGHT(PADDLE_HEIGHT),
    .X(AI_START_X),
    .START_Y(0),
    .VGA_V_RES(VGA_V_RES)
  ) ai (
    .clk(clk),
    .move_dir(ui_in[1] ? 1 : -1),
    .y(ai_y)
  );

  renderer #(
    .PADDLE_WIDTH(PADDLE_WIDTH),
    .PADDLE_HEIGHT(PADDLE_HEIGHT),
    .PLAYER_X(PLAYER_START_X),
    .AI_X(AI_START_X)
  ) renderer_rgb (
    .clk(clk),
    .video_en(video_en),
    .h_count(h_count),
    .v_count(v_count),
    .r(r),
    .g(g),
    .b(b),
    .player_y(player_y),
    .ai_y(ai_y)
  );

  // Procedural drawing test (temporary)
  // always @(posedge clk) begin
  //   if (video_en) begin
  //     if (h_count <= 100) begin
  //       r <= 2'b11;
  //       g <= 2'b00;
  //       b <= 2'b01;
  //     end else begin
  //       r <= 2'b00;
  //       g <= 2'b00;
  //       b <= 2'b01;
  //     end
  //   end else begin
  //     r <= 2'b00;
  //     g <= 2'b00;
  //     b <= 2'b00;
  //   end
  // end

  // Tiny VGA PMOD: https://github.com/mole99/tiny-vga
  assign uo_out = {hsync, b[0], g[0], r[0], vsync, b[1], g[1], r[1]};

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, ui_in, uio_in};

endmodule
