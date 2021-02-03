// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Tue Feb  2 11:08:02 2021
// Host        : cometdaq03 running 64-bit Scientific Linux release 6.10 (Carbon)
// Command     : write_verilog -force -mode synth_stub
//               /home/comet-daq/8GeV/kc705/firmware/extinction.srcs/sources_1/ip/fifo_generator_0/fifo_generator_0_stub.v
// Design      : fifo_generator_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module fifo_generator_0(clk, srst, din, wr_en, rd_en, dout, full, almost_full, 
  empty, data_count, prog_full)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[103:0],wr_en,rd_en,dout[103:0],full,almost_full,empty,data_count[14:0],prog_full" */;
  input clk;
  input srst;
  input [103:0]din;
  input wr_en;
  input rd_en;
  output [103:0]dout;
  output full;
  output almost_full;
  output empty;
  output [14:0]data_count;
  output prog_full;
endmodule
