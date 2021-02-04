// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Thu Feb  4 14:31:33 2021
// Host        : localhost.localdomain running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/nakazawa/8-gev/kc705/firmware/extinction.srcs/sources_1/ip/shift_ram_hit/shift_ram_hit_stub.v
// Design      : shift_ram_hit
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_shift_ram_v12_0_14,Vivado 2020.1" *)
module shift_ram_hit(A, D, CLK, Q)
/* synthesis syn_black_box black_box_pad_pin="A[7:0],D[0:0],CLK,Q[0:0]" */;
  input [7:0]A;
  input [0:0]D;
  input CLK;
  output [0:0]Q;
endmodule
