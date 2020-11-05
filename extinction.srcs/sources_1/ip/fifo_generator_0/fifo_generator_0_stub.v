// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Tue Oct 20 13:34:07 2020
// Host        : moncomet01 running 64-bit unknown
// Command     : write_verilog -force -mode synth_stub
//               /home/comet/FPGA/extinction/extinction.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_stub.v
// Design      : fifo_generator_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2020.1" *)
module fifo_generator_0(clk, srst, din, wr_en, rd_en, dout, full, almost_full, 
  empty, data_count, sbiterr, dbiterr)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[103:0],wr_en,rd_en,dout[103:0],full,almost_full,empty,data_count[15:0],sbiterr,dbiterr" */;
  input clk;
  input srst;
  input [103:0]din;
  input wr_en;
  input rd_en;
  output [103:0]dout;
  output full;
  output almost_full;
  output empty;
  output [15:0]data_count;
  output sbiterr;
  output dbiterr;
endmodule
