// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Thu May 20 23:28:08 2021
// Host        : localhost.localdomain running 64-bit unknown
// Command     : write_verilog -force -mode funcsim
//               /home/nakazawa/8-gev/kc705/firmware/extinction.srcs/sources_1/ip/shift_ram_hit/shift_ram_hit_sim_netlist.v
// Design      : shift_ram_hit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "shift_ram_hit,c_shift_ram_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_shift_ram_v12_0_14,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module shift_ram_hit
   (A,
    D,
    CLK,
    Q);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [7:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 d_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME d_intf, LAYERED_METADATA undef" *) input [0:0]D;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF q_intf:sinit_intf:sset_intf:d_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 q_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME q_intf, LAYERED_METADATA undef" *) output [0:0]Q;

  wire [7:0]A;
  wire CLK;
  wire [0:0]D;
  wire [0:0]Q;

  (* C_AINIT_VAL = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_SYNC_ENABLE = "0" *) 
  (* C_SYNC_PRIORITY = "1" *) 
  (* C_WIDTH = "1" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* c_addr_width = "8" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "256" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_a = "1" *) 
  (* c_mem_init_file = "no_coe_file_loaded" *) 
  (* c_opt_goal = "0" *) 
  (* c_parser_type = "0" *) 
  (* c_read_mif = "0" *) 
  (* c_reg_last_bit = "1" *) 
  (* c_shift_type = "1" *) 
  (* c_verbosity = "0" *) 
  (* c_xdevicefamily = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  shift_ram_hit_c_shift_ram_v12_0_14 U0
       (.A(A),
        .CE(1'b1),
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADDR_WIDTH = "8" *) (* C_AINIT_VAL = "0" *) (* C_DEFAULT_DATA = "0" *) 
(* C_DEPTH = "256" *) (* C_ELABORATION_DIR = "./" *) (* C_HAS_A = "1" *) 
(* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_MEM_INIT_FILE = "no_coe_file_loaded" *) (* C_OPT_GOAL = "0" *) 
(* C_PARSER_TYPE = "0" *) (* C_READ_MIF = "0" *) (* C_REG_LAST_BIT = "1" *) 
(* C_SHIFT_TYPE = "1" *) (* C_SINIT_VAL = "0" *) (* C_SYNC_ENABLE = "0" *) 
(* C_SYNC_PRIORITY = "1" *) (* C_VERBOSITY = "0" *) (* C_WIDTH = "1" *) 
(* C_XDEVICEFAMILY = "kintex7" *) (* ORIG_REF_NAME = "c_shift_ram_v12_0_14" *) (* downgradeipidentifiedwarnings = "yes" *) 
module shift_ram_hit_c_shift_ram_v12_0_14
   (A,
    D,
    CLK,
    CE,
    SCLR,
    SSET,
    SINIT,
    Q);
  input [7:0]A;
  input [0:0]D;
  input CLK;
  input CE;
  input SCLR;
  input SSET;
  input SINIT;
  output [0:0]Q;

  wire [7:0]A;
  wire CLK;
  wire [0:0]D;
  wire [0:0]Q;

  (* C_AINIT_VAL = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_SYNC_ENABLE = "0" *) 
  (* C_SYNC_PRIORITY = "1" *) 
  (* C_WIDTH = "1" *) 
  (* KEEP_HIERARCHY = "soft" *) 
  (* c_addr_width = "8" *) 
  (* c_default_data = "0" *) 
  (* c_depth = "256" *) 
  (* c_elaboration_dir = "./" *) 
  (* c_has_a = "1" *) 
  (* c_mem_init_file = "no_coe_file_loaded" *) 
  (* c_opt_goal = "0" *) 
  (* c_parser_type = "0" *) 
  (* c_read_mif = "0" *) 
  (* c_reg_last_bit = "1" *) 
  (* c_shift_type = "1" *) 
  (* c_verbosity = "0" *) 
  (* c_xdevicefamily = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  shift_ram_hit_c_shift_ram_v12_0_14_viv i_synth
       (.A(A),
        .CE(1'b0),
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .SCLR(1'b0),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
EbXZS4y9cLjOTv9aN2dDC1sJBVVR3T6cbmKAVT9lmEHVIdHGCTfu8iy7QkwIs1KmhdwMqwdjQdXK
KX59vPzAEw==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
svosYlCBRVGey6v4WrNTTJ/a5E95XJFz56V4Zc0YljtTgqhYJjaDcp0yGul9TGC5O3yPB4RfWGyi
btg6o3Dcl+FOWudpxsWABJlvSnbhUeNY+1OKCV5sW4s8s0XiKCJje0Ckn8Rp6OvgxUpP6PcdRMvZ
/iOZAbfkFtowP72szm0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bkZxbcKN0VCVZ8Sn45uafqVYQYk99p4mTYGqhmN6rGL2wN71zIp7oyvjrZ5+IkYIHjaRPVw6MFHU
01i0/bnlUJiW8yu2wC0IWq+Qr+7tToxb6o9RWnXK0n99HX1QMXGzkrlEpdmtBZrVGvgv4FixWWZQ
dodQluVohp21teUBqa8WcGsxqwaf1e28uNmi0DepWjqMe9id/BduXSphJGM1DlXD21S42kAcvg1F
rd0pAgZ6lhG9/NzFbvb2jrcNLh6ifBCr2yjVd33eQU68fnkIGCXAggzWpyR3yOvnmG/zCHLWi4gb
PMOlEmzrjfeM8zl2NP1wqpFDnlaPnYEIcaR53A==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
uYdetOP0NrAC/6FuAtYFxT5Pr7xP1xI60RhX9Ysmg000CklbBe3op1FJo9+N93iKzuAQn8/dUzat
ZR36c3yAxvWyYey+XkDfh+7aMlphnj5vggVXK9DqeVsHakNPxVCao7RCkkSR5x9XCYQXJlARvh9C
RhB/l2sQN5DF9bDt9yCKJlWeBEbbcjDJ34WronEFGxp/E9TbIEVWGB4V7jnlgc0oxMMYU40V0d4i
oAADER64AUPfYZ+0e97lsHeETWrkCE5+mE0OLxvjypqZXIFAINmnYsr5zMzToF2CiK/NT3DIL+hM
q6OlPRN1R85uBOCDP7qHtxj+CdoOVPKhdBfsMg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
mo9oRLIx4kH0M86v4sywZvgPz5p30+mzb2H1aU6fkraIKHMy5ue8V7ysmq55k9NVOSXTmYoCdFml
rPPuT8ktqPXADjRPNUmPsenolR9+96Fta26fIQSUqMHuwI/y88nM10meyCjIBjD3+oIqsgrFqbaG
saQSaPJ/MMnei2igUfM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
MqMRozeQ+7B22v/pgqDAubmlkM+wpqpbsz6L+ntdBscEB6ki7vLly/oGOJTK4ju8/qS8LlggHRaO
xtd0voFIGd0icRz64Q8EBqol0lxXJPuQx4zOa4ucCqaUViJ8DL8xQgErcDHpb1p8W6mgaMCbp1Kn
SuN+ZfS1rS2R+r3eI2jOHh5EF/8a+cFR0oqrSsWzggfrGMzKWWsSLwd0s7UMDTtruNQTcAzYvm5V
RP9lHvvN8So5DeLrtLSl96n6SsbeObAAXX1i6fiyPV/C4IkPyx5F/L/IwAENNAvrINtYTWp3zjEx
G/xKzVTUEKeNs9XMESxa+4oJjG8+036ic0vnUw==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
IMm39dcG+n5fcIDQcybfOguCUX3GDSDHnE0ukUt3z0GfgxGXQ4udN7KfIK0bhw+jASYUkEQOG82Z
jWNGyelrCJ7tpuvsm9YaIUYr2IJ2QT1Ynkbvb89to7fC2N8oJIj+CoBTtLC86KT5zZElgE6hbiEz
7BmQos82ixAQStfvYXzLNA28OuJ6lb2E0qmPHv4aIX8Fpurga4e+hsxFRIU3Z4ic/LvKJqpD4ezA
/K83dWOlScX9ZuWTi4mAGoqA+zlbNbFwBU8V+8K3oDzdsqo44Z/2l9hMNYUPYCk1/tnKaQd15Ehg
LrY/vRDu7I8Vy15n/vvtYw8+JsW+ZTjk06pwIA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_11", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
SsO3/u3pdnkO+dB+OKyx1QDt1mi6uw+plCPLC3gD5vGcT/Rw1DFHrlAIQTmqwHN5GzbPEGkjYmZY
9kwB9EjM2gIdSIdoYRB1RyY5bhp3JCgYfTzMPK5LNFIi+g7M+TtGYVMGT8Di35eaWdm5aaUgxJyR
rB3b4SCUL81yP7DQyIwpQFQa4PC7Xf7b/l1KQrz+rVnuLA25Y6pCjkhIHqPImKXB1AIZfdbma0kD
own9h+IJWBIJ2BjOJkXUROMuM/7PUU6G0C+o/q/qITJAS9HIja+EqxZMlLGXOml4m0pXrwayXWl6
J//yfLFAhoQveWL1I3f0/XvBrtcSUqNyZJThzQ==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
rGUo/JqxXHI4LiroeJP/5v98epEBpyTzmJ7YInVFh76jqPQYqQwo7AVwoh9TgiUlhpU9Wb+qQU19
+qvTF/Gqn30nqqrVU/oVBHdlWt4Qs7hNLYOLL2vX0gnNrqLUKTwnZ21AvRsqNAIDdd1qtREs1EeS
42HSzbuUYLsGYNqM8uyFwr0jelHBt5LHDWvXN1qjep+TpbkIqq07XOteo6VssQFqpoz/YTd2B2WE
0lBQSolvgVtGwYzyvQpu1ZzLlU+b0f4KM2H2Ya3wcFnTGTJr+/5jFzS67ngtvo4QtGMsCXIVZ4g3
ExCDIk47At+SmE7ocd0zDTf64FowzSAMc5LF9w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
gzkNc3FhDOsPuCvxavXecD9Y1qZoROP5ZKJwkJ0otCZWkNtORqcUiv/KY2N/IBtJJsgNg8tGy8q+
X+F6HL5oCuVsx6M9+GAH3MdQjNZi6HopkOD10KdXF/bRbU1d5fgZXrB+rHBh3N2y95GK7fAn6U2R
L2HdurRbka/QkSihi3WNVqrhC6BinPTGZC5jsalz1tWRc7mTRjD2FN73aPrTb4u7R+/v94AXOXj/
8ECV4VIWjIaz9fPNLgsSiVsB2bCD5pspi+ZwJHaJYuajDdeJ6bue8Q5tyCV4vJ2/y1sIJCZaRH46
9WSDqhPzMZNw4qi10mhxrmWCYkraYkuPOKyBmw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
g5ajcJP/zpJ2IHKvf+fErmk5PrTKgPkRA9yWuD2r7lqJicaI/TvTbjN6qX5wPb4swIHkbyz3X9IA
g+T9cLPKq8oXefqrOCsKB4ONe80hNDWG3PHO3HIEF0jC/SVs+yMO+UXytB7G4MVn+HFBbMvpm7OK
kpiF5ZBsWlkhRAGz2svysl4sJWu9oVQzDfpasMj9Z8otAvJEisAfpDPifnigW4vMjNY7+As7Z8k8
6AWTG/b2AImE2e9wxWlPhkAsa6NerZx/XoP818EeDAeGhjdFZGNnMakfWtkUwh5P6/5+JhX4yGmJ
56RO+BKUeJSwPsAD+Y1H/dSVL4FuX4/xHbbaAQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 14672)
`pragma protect data_block
aji1yHKpkpP5tLFdRAgP+7yWiDWZ/I8BEvPgxKMSzNZ4IuNXmyzQ4A+5kkphN0nlsZvlwpm2daON
BNGpCa95OAgQXNwQwpOa/zKcTx7fmN2IBT9oLLTeh42LO+qc+0xl4NpNPVIZWNdh+P/1qaS0KxnL
F6kB/1T9ESqkGwj2pENFuLGLxZB9eL6IXHO0j4VmGhLWyi11nfjTEOZS9WtXbzgq8Aa+CWFNlJ4b
pnIwT03bTnfUj/r++fONROyU8wmCk9x+a87vBMd4B8fb4EfvPQCJsk3Vnd2CdKJwqypxuoTxjxrG
b/PkcWZE7Rwbb0pz17skr/dNDGKie3ezIF9OHr3O5cb++CAyeRAFA+JrFCJ/89qc/3wB78+E3T+K
AFjDo1usOTzxFdJBHpD3ahWizfbyxBA4pxEFP6npZJ7SKLoQ514A7LS5JvyJi+mObCXEQdxpvhAP
v80lfcaxaNszN5053Oef1L9uBLKHZgwKC7iWHZl7Z2wrCR2squOPk/DKNB43LQ+7Xiykf5+P0CQ4
zojJzD252YhfV6IVRPr4uZc2BDAgVvef1rTFV4OQuYO6Yxgw9Pyq0JJewQ7qnc17P/djfsdZCyFQ
JRFKkzntc3n7g1tn2nLM5bhXzlBmsaT3WSMJEJB0QPT3+gVbSKaSJfW/GW8gCrpdfszdv7NdArrB
kUJX/v3syNoNx0VctgJAJmyt44lUjQACoWTUnCKORTc1eo+0GGRkYjYCTldvu87cZN4kW0gClqtD
4IPXIh3zOq88jSei540XxXCxt+ozu2pSBCrlCb5OxqvcMtbkqRJlZ84hBqXkMb+OIdVU/6odSMsr
1uanRfwR5j1rk0VnvNPGScbx2E9IZEoNm7X++2ZWIhUD0EieZnlTofoOFbXFRgQpoDvFRL6jlIri
mXncdYdgouXYsJDcY4jKjDrwIps6zL07KTOYxHAoJBeC/p/QNl+HuMLVgQpK8hL0U7PYnLTGah4B
hQmUkwbuqEPYuQrP6JOhBn9ZirSRsUM9O2nS5vP718pJIsheaPvA/CNx9PH/2qlB83WkZfu6XtIs
a78qQE7Vm5n+XiwFxpdSt4GtoCYo2X7tU9e7fuVfEXY6p/cRSkxS2R2hIjQXUUcBXZxh2gfzclGK
WjieCwRV1AJoF1LqdwEyCmOvmCj7MUijbiAkwIaAbLs4OGowAfuyoiqTb9AVsShwO1jUBYcTacil
/FJd3MKmpf5O4Y2iPYeWFEMvY1kkhq4jrKleCg952jtVFWJwg9Nxyvhg3bYV5p6BrVg2HN6GwE9c
bH/WFm4Nbg3KLji5bFnApKmEwxd2Lt6hOaZaXihReFxANgqHiFfUaP84A/cVWzCDifbhzNF06l6b
qC5x5yjaa8x70AeAygyciJ8NSLsQKNAa5+Ky/sV6n3m/+MLY3myctQHAjrM3aCweKHdgi0onEiiQ
T2A85Nzx+yiTqwUdEMBeWtnt5vRTT06QucF/9IJ9DQvJJE59TooBmD97TV78O4P225mwn71dXdTF
nTnJA0cFNElYEBKYA0WlT22XLPdAnYvEdGfuywqKEo614CqkznmIjv4u0BV0azZSLgfQGiAXOVWw
Kk43vJEIBsvS6jjrEY+0qcMTbw/3vGgpy370gAL9m8Q6oRR1B70Xf6UlzQ/r83zoiLmwZ2/qcsSl
XpGtmFZenNgs4mnuRnwVaNAEikvEVrnNrO+2PdUFHWfc/maymlOPXaCRZ3eGPR+1uDUwbdQ3Vfim
1tw/a1J9A3GFlTldMyEfiNZ4Hho8iSQU4lX6qFxLKhjjNzQrOXq/02G+1zBwJABc5rnBvCrnnywy
uTTleiJsvCIjcTqKgLNZjkVW+YTj5lvcAeI2xj1vC0XjUxvSKz9rD91lB7E6eUc6M78RsFLxLVZy
+D+1mQq+pm2GHxsn8/SHUk9vpeIyDabu/kD+18xtH8nk9MPLtfiIwNSGg5E/+glADgFW3v6IOlc6
grAXWQkVhCtvFaHFpIOpSlwOqQUd769/F0UpDI92XInrtqcmgjCqV4weL7beL1AZk3sP4F8IeLGf
nsmSEoL3iheKmpkNq/DYqfDOVIdXffGCeyL9qnftZSEcJU1sNprebjiTPo9H2ScAlguFehQwvzR0
19AwfRer3xa0n8XRI71Rag1yPUqzyCok9QArJ57d+5btWRCktMwJ933O+NJzcHFbsE5cUe6E2rqb
WXrqpInZjmt0fnAt5ijw1LASYlN1y8enM3LeJ1xjgRffMWpPU8LuvPq2kdJDZSS0D7f52h7HlO1O
QkXZeEPPe/uxbN9MaJprm+OUNLlakaYsRs4MT3Z8EkjKguFvtdmTt35x7/ymYIM8LbT2FJr0QQR4
8f1Z0h0djq8XRrzun/R/IOopFnfYiyMOcWUkkPx5f+UsrhzrVQ2D1q/3CeUo5TB8mIWReq/rst8Y
KbCenTnSxvDPYJgbgzjBRy6vPkCkvBFT4bHlJTDzZSUFu+9lCcMuIBiOnqu7Yelbq2nB9rLNpzgY
R+ZO6/L+PV5QrDlsR4Xs87m8X71aDGU+euzICXAgbD/+LDH+BAujVFRdQylOPf5GMqKVRjO4plKu
7gq2C57HM6QNe9iQD/FVMiV7ih25iGxmSP/rhdV+UNoDOmoh8FHC6HPOrgx52AYWuKjAjKdH079E
EOe0NrWYvFY5AF2Ma30xsC2wDVZftPI+mpPjMrzlkZW0S3eCUSRbvkuhQ7A87fmOjrKJwzjUGbY3
YI9N4jpqavOkPsQFz54v9aCShrbFW5+RVqS+540qqQAUiJSv6HCVxbMghGZpJh14CJHpdpx3/kAf
IFho/61ND6QPM/winvvZJBo2kpEHP4zODVUMMph1nQxJXWGyZLCx6i2/taC+DefMnKwwFSgFnYhU
xlz1Zic40snkhrd789EVYrXprcdUf1zx2eTRfmTqciJeewkagfiHh2PHWAzAF52WDOY9IvBcurLN
CUb6f9qCYn6WN2uOVkYoJgFLOqCUk7Nd75b5oVXe45/79nVZ/NqZTOSg+HdV8sX953CKF5q2eagR
JVcS0tc3QcW9TH94ggvy6SY26IlWi7sJFDX4bSRRCjYztLKsD6cGhZYYqjgcy2dNWV+zdzscdgnW
SbhJcIs/NmKgccINTLrF2QnXVFOwQ2OD41OpDOH+Jry6K3g0Llcz3ZJ6cjqKiU/0evXxP50z0DgQ
W+ie67MFsPgnVmdD4I+rmQWj8H8trEjLmwN0hr6C0iORJ/1tcZYrTs9TcsuSiJhWsgZlTaQWydAE
6s/l/Tk0D1cOohE91mIFS33A/g89FneufLRWJXnEKvpj/Dv1hwPm63RY74U6t8BZIzKbPkZ6faIL
ROiiNK99yXsyHSJ0UxgJU9dt/DIR4MwRQ0AcnEQZfQmzv3PX/xwxoiJ2woVPj5V6VGRDbFLQvdz/
0sxxMN9nbrs8o3849yP11r0Q21fEjSZYrczyOldaq43tyHIumw4q5F3QuHMAlcbY5bylF7pqR7qx
JCOYCwaoLmJBt5kovwIbbi39B3CnCiwIqx7AzlKv8tZxnlgqeJHfCRiFkWznvIO22MiGHcfRMZxl
Pf4LZ+Bc2l5tQCNVFJ6KKFzbLrCQQp/+h1dXZL2p6pENAal8G/gpsNZvajP/VU9LOW0lvycW1zND
QdadXRorO0hg4AXaSckx2BsKEY+THWldH3uTtK9z1ZqyGaPIdcnbqD677Wv79KEpEpVvTzRKTru9
s0SywO4z0SVxroDEP47/DLIhIh5hICLPmnGuR0THYbY37UHYIz91BOPq9lQ/GI4+Y9pI10LHo4OZ
11YnGZhsR7uJTAsxSQ42xD6TPP+dMkTtWH2TrD00vqmzAgI3Z5XckWMghmAQ72teWmekYe5IJvRi
3g4GK1DKgXoIoEiocBSksfHrZNFI+phjlq+TIT2bS5RP09LjS+mt7JRZiZDH+9WYLZ8wJYj8XFux
MGkAzd8IVdT0md04olajgh0p4fXSf4rGMUSk4ckdsk9+qUTqJwbqPNitsRdggUsay7uQ9QFnycCI
Wdvrh1u0sMGPW/ABSKPXKDx2TRYV/XgP2OY0CvkFKk8XwqCJpboJvRAyYNTitWWyXT7xeJZv+VKh
eZlJ/235ergjde/6Hj4YBQ9pPhtxRyztZW+lhQPCHPERGtWS7aHWPEjoYJnirnViXaXni38Iu9Th
b7xz46btXAsWIq6/r7X1G4YsHACeZhyuwcCEXLaiRGv6LDkYiazsI5Fbb6BuiqNpLouS+oI6Xhs9
s8i+5mURATqqnv5qJu+TQ3l/2IJ8au/61UymJ4XaGZY41EyreUuRdTx7TL3bN9SluUYWFTOSNnxN
4bAUAeNqZQ+OMWuQu9WZbzba43wKUB0P89DDGTmHTXxuYQ3NequQP/QeWzzDZnMKm5xE7TEyahYV
yMLTEUqlIuExeOwXpE7jUHPPfFtFDwoiDeey8rcYHpis8CnPtxb7ItV8PcYqIPraXNdfPkjRHxGe
lW0QXbEgVZyyFqYU1LXg1R+1UBvlDfCfAr+oFk4MLNLSSgfDaQcClLN37MQ6Nv9zVoSqn97m327Q
VoxYkBFpm6xsi0Rx+lV49421am1L63FhZEkslmijvjCX3ccUHfmtYV5IjeiC4xSzBknohGk7t4YX
VgfwG4pR0/XoP1UbzPOsRmwtvL3kc9jEMeJUSYk1p6+YibP5qr4w5d11XmmWZXXVFUcvxXUXEaDF
R/itkrvmMbtZvmQfRdE7udLLBq4jSScACDPlbwtfHNZbHRk0vKK0hhFRqQAt0pLLlThyA51TWAXm
0/0Yqz0ktC9DTB7geQQ12B/T9sRGldgpGuN4+0CAwfwobNbME7XOR6ZUpuQ8Zx1ylYpo5ywNKPvo
eyPuP2dzVjbc6FS9XUcPeIT6/pdO0aDUAWDwFVah50p5dbXOA3sc1urTsQ+hu6peRM5igxdgAxXQ
N5/JYIjlFMk+YyE69+Qf59oAR+Q09+16CxvwzgHT0CH+5171nZ7543h0de1p0EGL0qEVQ2o9m+Ex
MKwmrOVfh4k62MCywqags5SpNkhrOiTIBcQc9c4uK4H9gsvGzO2h8RMTsaLWtCuk2ZpfFP4+K5wG
pCvIdTz0XersGnltc9r5KWl13cG97Ijr4lHG1BpGb27GhDptRIMaR9nFLQrNPsI3G8p/3TvLdUtx
xbVR5GvfDJS7yp29ZzUNApLDcBdRVLP5ntCSLeGC7ulMVSvQ79mliKZubZ+cTqw1njzCtdOLp0XO
NMrMk6Ypafiukp6vgcatrVmFnWT78gUyeZsCNmaWHpQjmtu0S8ynqTXiFx0Bxz7JHiTzMCx838N9
r0kMclURxy/RWohhJctlrBL4y2s34JdHpZib8eJ4qU3/Q9mkscIRP4l9YeHYbKUZlHcxctfxWyt0
gxBYBCHTPAxaKztqgX0rDUbs/o4yquAYAx94JEVILlOtDXtB6NGGJSBU5JH3n6dKhS2NJXAoxkAf
lTUmM/4UrJQ80ZG2iSYaDINSP7x8TTyNYEr0/YOusfwNfYeN5mbpXdFmGm1+DJtHdLMN647f0fWX
dyRsJtHV9SdneFOn+m5So/dH6IczUy/YN4N+tCl81yF+e8RJGzMHdVtOGlccv02m2VuvZ/50hf/0
9gevqJqwaogq+sXigtzSjriS0PrvoJzXdmDwMlWaY/+V8+62uQ/9R9qPUApT5uYAfamO6wvPoKHp
hGZHvngx+vF0f39Sd3WNiMfBOgbnha7GkUv8uSyVvPar/b5Qcq7/RCZoxvttG82aoUFzRe5aCTsU
XJEDDxVC1gdg4jSFm1orx50ObwfgWVjKf8QyeY7KIu/SdaarENcaqKoxZoUeQh3cac1kLKY8II7F
QNWeJOJl59miNIQggvPkSdqYFunvxOhJjRQD+Y00ePlWrJIYC4efOcpJvN/b+R5GyQM2qoU1yjob
GWwBTqtbAMkaQ2Dut9cUWRfnGb3Azo9B1qDQiORzD4r8+zxSaCAtPaydtx/3EnuhFdcX3CBNgBOH
tWMvIYbLDBzbDHcdoX64Kwz8c+Dv4yECEQBlRWediQR2bHnMOu5/OF7LbG6rTV6oIXEsSq5gv2TT
MuVs9RLBdatlrfYqm87cHJwZr3xBT3tAEEh0idaE+OY+KDPcRZOpXKYPXfPJxSJI3mf7UMxkqcrQ
TkDfguB1FEXjOoentK5anMqF2R0/zq+Zya/jLrZMx45Cwm7ysoXwqq0VPmYWJ8l3lckb0JbQp/M/
LCaZBdrVEREcr1y0584rZou8AJLOQnYe7fCc8VxcMohue1nlKlKb3/EXar8PdZ/vLMBnXwnZ0O3b
H21Vabw8v+II5+zUJSOuDwqNF4HzhL9clV19L2OaGLISXl4FM/JjU9BAYgObUtlWE5IfULs/Jv5B
6MyGelXqqE1epKUle5nTbbga71ZitbX1PjycAzhi1Pin4lg/KcZrAcr7yPUq9wcTUxM0MaiXI42R
jB3Edekrzd95QhDHs0O+Bk6KQc+g+2Tvc3XJ1e3FT+T6M0fTcOLl4/J5o+1PDN+jxiJG1QYHqnHw
kq7hF19pK/wMpVPxFhIDXb/rMcSOeXI2jRRm08NjFdSogcqD7TA3XD15bNW5ur6TrvPDxttDUxHi
fFG+nMRB4XmHK0DHQ5tw8G8swlzteHv+S+UHMzfG027gUaSmkJ8t1+/1Q+JAGnR7zwS9th9xrc6J
J74GJYhiquIi2lKm12yfVxhnc/9ubxH9pcbCRh16MDqXdf5FSIeQ++sPtzA+VskIwirt3r7S5ajo
IxkkQL26twvIll3Hj+nK0amxAbaQ+hhOUTHf7LFzLOA8AsLitYmp2vWpZw3Hz8E/Hb2VUnebXc2m
gsRAHOc9XgrylNnnyiuYp/CagunUiXa3Ng2ZCO1Yr/4CBHLSizbIJ3CzcQ4c59fRbA6+j3PZgRhF
OWf8tEmmIKk1AYOCSF5cMxIlp0AauWy8qQhWL2BP79HzUOtI5eaWT3n4fA/7qxSWVirXmDPy3xVt
r1nmetIw9u/LpoiBrdO4xhyiFozLBSNH1sJQ4NS0p6PfmKdZ9LFMWKLiLPvz63YEI+lvfOSPWnob
zP89ihNtST3X8mdtoiNNS3REYQSc7jiO6T+WHmXnYQlseWSL6laee5tGScnLYasorw7il7xTiAC8
4v3ENWD3r01+OTlkR9+nqv51epYuQ1AhC/nBJ0cKK88Tm6qJm5PEfvd7t/jsz9lGs0p6zd3LVHnE
GFBlQBTNVjDeh3H39ieSTwx5D4anQ1UREzOtQtJXrQJj86gq+Dg8duEdEj82q/P2yWCmy8Lo4FZZ
y/mvBLhBVEhvMJcEsT4FX0kZp55diCP1tYRD3l4eE4L4Vh8pGi39UWVtm0PeXvEZRBTVWEAJTPDV
qhHDb3Sf5lBoWnyF5ufF1rBlXgx/gqzhXVXvW6yiKsqSFyawd4AJDD2NaYHeUcrldAKRopUPHnSs
7RbBGtRCXCG2PlEURR+jJspeS71+1/08luREXy3bA4VlLZzPmzh3H4nnbhcv+NhZvk1EGdLVK17R
KiKW/fyCazJWdoLVrCc3yLwzgaVza4XTZL9SHfaLvOmpHv2tINRMbgN5CzVoxjRftXopbGqTB5Ey
BfESto7cVA6a2j3HCyyRwP66OLdt59OkFVRNmXA9EWiaTWCP2GgnG5hqGD4DOHKeZDodUHdwtFFt
dylft/lW1tInjpCiOCnP0uqY+MPi8UfRyI0f5YpGl20Avwzbc/X8FyUpPinoM6vEHCZxBrynJuna
3EzPM4e7jOI1w8zlHCeWC4lnrk1nnwsiuRDMtOYD6vEOss+azTPgsvr5GmM1RT02wwL4DGcqdtuw
jMhyOMKHPKWBaDOy3H0lSI38OFzXu5i9PHOwUHptfz1onXr+3AZYvK2W6xwAM+E6nlifkX2Dy8b5
X/yY+vnNrLkRYBzz5WFFHOr5zI5SjtJFS5MtlmixMkS9h/tNqUFF5XGPrsHmxXbdkafN6E2qvuiO
LLcmh2hyzgvq8ixWmf6JFcMjzN/JQPVGy+XyG/2D5qgoqi6LzsJ1yCc60zqEk+JOuaI2yjCKfVaC
Tt8X4F+lAP5rZ1Gu+hafoRtS3fg5wUOYjdjzc0fO0R4DFqxfJTOnNDVb8pDjMsbJEiRfWAJJ79aL
/Z79m6549L22Xc7jVD+pcBhD604S3i9w3CkQ1i11MsVV4bc74FTsAm5AN8THQ5UDUB2kJeME+xXG
9xtO8/t0xuVRxWx8ft135viQEgVtpQFVaIfUDAHuhalB8qzCCQqk2mMAHhxVswhEEAP1pNHCHXIf
uiHEhcjrYloxckuoTOlS44redcv9/WTFAmi1Hy31qdocv/IUnlL+Xo9YIO/61abn8377J15YDzDb
I3ROOpWYXMaXEXkdBqdlc8Mb14Zz8iQqBaCFWwm13oOytCI/RrO4Lq8G7RR8gIo97/lyelIFbnCp
/KN/ySVGqtvBQTdkIUybNfUmWpWyCOXcGvz9FEoDeWAD44v1Y2Ua8DXtrpN0J9XbjWTqpbUwN2GZ
cGj2Zgzp4fKD2zzT19j5Xgf98TcJwZRVpCsH41War3yJghfTfbDudr75s6cICbGGjtMqKeZZs+oK
kr0tGskN+NdhDsoHpv7hriWJ3muFN3XZLcsk/c33UPo/zZIMnG5PWttubs/Cw92k1aubk5bhgFl6
mCkCTwikgdVTDclC6pGDSV51pume1qD6LDska2Ti0qQ3k92V8jolDHtTE5V2FVdWXEa58N1fXLSO
/zJJYlVFYL6MtxksDhuSzqaDpsnK0da3wNofuO8Hl8aV6QTZL9kXms/1K4vJK5y/dvkZQ1wy3gQd
6drwTqOLcs+BclkxLo2CMRsp0ZQiaGG+XHPocxKoCMUXoJAZge/gt2fLtWaOPgaOFlOge7t4IOWZ
z9nvHZVwj/Xr4anQVH0eDE3+Vo5585gh3TicFmDYgq/noyWuIU3QrjS3zVcZ6V50hFfVclH+lu78
TOb/Vp0FVyxOa/KvX54R7gVVIHdBbtlE4IFsTEU1j1wNKJYPX6yo6HjPNu/sLneBZxjKmihPCu0q
34kKtn1efpmxHa5oHdiU2v+QhFmxCTLUfXROYEaGpwLEU746QAb4xtMx9CNLuMZXgYevMlFbiw0Y
2SKxOUCtx5qsKDXOVrdbHhPAKrg0Mm+UU5b5aSMF93CMK36UJXkRsD7SmeW2rQ6ypban8hKnY7kW
0iocjNessejY9EjfTQY2wOS64DSA66QekNezch3F+G3o8JnTwgS/KHRUtvQnwE/SmKC5MAUwRVLr
IMjuxOl5wesHX04fbbaTN/fTj86oYKxk7ZxPlz8Q2vbklEXIzK70jmZnI8HFl9j+xV87HbPCsnOT
EpM9mQjUnEah+1jNVd1zAYpQ50HCUkFser1xoktMcWDYtEEf5QurfqIYKvKM/nVbuG5gu79xUa7R
V5eT7UmXiBPVxy3U4Z1KrxtmYBCjphROYdsTYAPkjP5cKutCmF+3aam/bJOnti2larC0sjEj3Vxp
t9F54LokFpe/aCBm6OOiOyF5gmVOWTrZ6VNcvAXUJRMjUIdMpLsqX5QLSDdTphzqnUXHl7DmmdL5
uwbbvrHLP6CZ1Risvu2lTmpLp48piQzQR8r7BVgju1x+oNzXy4ZBaA4QdsciQiFhj2zBJQEXUcz2
BAYrv+HYPSXaiyIH3ZyNkQWwc1HL1YXWkGi0il4ZJuwrE9e93z0HB3DCGzPCEBDY+zhjoHE0B3ER
JeunigKUfsfIa15i/vZQDyPhk/OgZ7RXXb+vuedCvKaX23lf/yEXTXD1PcDjitQ0k4Ct9vz6CjMh
/a6O7HT66BHxQwks1RScQyI0dKgJcDEKNHu3zbSwl8cc2xiNUEOTnGmb4mUd4ZYxlLu3GmMCz+Av
JYwdS0GAnvXxfbOldiHd5wqWTkZcQmmcHiKjIXOz2eeAULVC4Z7amxf/0b09o2BDMpBkqaKczEeP
inH1BPKexT0rYkUikFq6LOKwIZUZh5iiHKhPlV8nXGhFbrI6f3pv8bnVCnk2+3vQxHG1ttmPfzhe
EtTcvTXQmvHguOSwgV9naOw+fmyJ5RNpk2seODZmXPu02Nm2tJduxlJUtxw8TvWtJTlQ+xKTuBB+
F45t8rEyonOUr/BZxEm/DDlieYDFjMsAAl0Mpaw686dggA0ZnV67+vOuxa26MY1vrGb585ullHr2
NdOQaJj0fjceBsV6El8uLpC+nYLz7wFpG184oV71C65ZzO3/lO6KJzi0IJNDD7npievbN+PIEWod
AyGglPrGvFMrfmC+zw1PemUeOlyL0T49ymfdrDcaaunoNlwxusgjOpkN7+2BOT/dYY1GJdqlg7wL
M46Vh1NqAOcmWUgmfGJcOEbICMFJ+x09ixBTc7+w7bO/nOHj1K50nk/E7OyUXhm9YCoupdbIu6tj
pH2drjoHXx3+GkwnyeOUQRE4zrmex1/xixaaN3UklLs8wVGQ0PXKGn5FdCNsVOAwfq1xwKrvqEIS
YbPqSTubVkluQwBvtOwCzoyKyD7b0j3tIB+M8kgDAVmXCMGc054Q5YEbgxRIFPjPe9XHN1shWIl5
WQnY+9/edda1coqgvZ83y1SCGErsxvw9VXjjwyAEFFiYjohQ/NBAyhp60MaiKUMhkx3A+0lx9c8i
vnIZI4X3DhFjkv9VAGs+4oPVIlUtJjAqN0Bhl3Qk9NG386wpSeD7j+m9vl781un2IG39lcXT/aoD
PL5dDEeEBUL0TW5lY/I5wh12kkcxsNYsVV1qWiwg1ARtuP36H3X/wGedMh7kINi/YvgcYSDdhwsl
7fN8q9HToVwO+J1WFhkoMOXPE5wD1gPsc7+b4ZzQdxL5zJV9ajLwHr3tQ1bXw0VUZtyr9lrICgb9
Cgt6lSql88ofpOoSEkUIzZsfdq0cHe23z0Cz1hGkLX6sTwa9EJ3s5jwW83Xs0hn9Cu4T0tFbYprx
a82RsZZfT289bckEgxwpQzKeVdB6bDFuFTeVGfJ4oNz3yBvEEq2FcaCZyhCc2iNFOIxhAIMgZqtH
FbW/CArpramFGdipiCAIXPy0dIdnDBAD/na5YvU4nKjbz3alnTbA9P9BxO3TsBiEJj6BoDGm+dqS
qVwq8T72aGdKuNemGXcHJk4nJCQmCtI3S+K4A1wDbRgaWR4TltD641yPpx9vnVF5rNDoHM0qlEow
9pfoRjCcPNePmuHpfFCqlfjvAWRQOh+OQBg6iUlfx/IWSTXutpr9CNxBNcHv0rv2GRoT6pVmT93e
+aGxJgHSVecx23gHgLGaWkki32Jp5gdImTJBkOXuaNEODxO8wC//neBZXA0c71KHHCijIQESY8kw
zzgGFCpqWcnfKNHZvge/i+SIMY8S0OmDcPObu2ni9rkWEeEewj/kaK0Lydivn0V6FN/4pYzJBUKa
AQhVMskg9RlZ8MZU1pECVZVrmXI1yN7E0AesRdd5Cp1EAnCDTKPfLk4gSG4pDp8nTwoxKQ1FqZgs
X4vDYnVGkoneiURDEu0bHMTmmze3oaiaQ9quLtsBYe6PM+erBIFZBPukEc+eTO+DaBItSqIix7Wo
FQERQYhvWKKyKaRAA0Yp+jByPfnhiJF1IvIaquk0kWaGZjHGBL74mc+GDn7VMu/YL2YFcnp3wPaL
cPwrHpRliJp5ooNLXQf1lEbKQjaZogi2IozLbKp3WpJLfK9Yaq4tcr4nV2lAtPYUd0fM+8cigtmx
vii46Go6y4TK3XhOmnwIUQf9Ea9q920StVsGQSAM1ZHZMuGp05R/lBq//6htwUJuc/2KHf8XbYAd
PYF/bCbM7YNYbEY+Jmw6tOm0CCejo0dP2tjUpqaAg8kdwPSetEtqxRzWOByiBgcGET38hXq+NPse
y9VHTdUTZMmNrqDo2zoLFiFWiMHwN3qN4JFCv+A+SfYKYEW1gLnAcAfxczRHmn52SrS25SKM8Ndl
7GDDnqG4ThaDNU5u6Ptj/Tc3DrUkFkKDoL1etAfZY/O1U2ufS2hiRfm98AKnarrwpB/ifU+wVrOR
XZgI43kDbLUWer6t7iEDb9+Z1C3wYoWQEXi93F6utYKDazS/j3URo4YM8mybxmVUNSZP3EeHbCBr
P9WTaKWJMMiFq+xQQ/icC6dSxa/f4afPj/8CoxiaVnBYT8r2fLJJH3HLwHBDu7tnY89Nfgj1vt2r
w3N5lRrmCOsCa3hdyz0ADB8O0kh9K9Muj6t0O4kbIU6dqcTvGB3HLcLv7H626BDkG3QiE+V7cm+S
SEM0Vm9J76KNh8QQ9jzx4nHR59DxmYiYRCnCVHFTn1zMuYOAu5f6NIX4mF1Zif5xQbNjtEiw7Vp2
Z9ai2zpw5IDH/6ad/tT+6gloml33vNRxG2mlGxxzIhX9OY62IOzsjKVitGxpsq9YOPWDtzB7dJFP
YJwF0Pzg97AeY6L8Z+4i0qYBnSsUfeWgUJKyxoLOX4bjMo3r8zB581DVYa44VYdrFNJ+GSubsq2T
nZFtFNQiwZ6CQx3qigTMyBOAODrEWH/CrINa3HAcc/dBC3GCHmItfLyzgfUw7bUtXE6Rg9MA5bew
X0V5WRbW4ctHHjoOvr5mC37ayw3nyFwZF4LzxyiFMuyiNYZZEGCh4eIFkhSKBjUkgl7SptJ6yC/I
l9GtdPU7H7Q5in7cYccOVCKGXEvUaDPw5kMYFhErT2/o3RoXtfaOMa62wplioM31Du9hct7ilNH3
yj+lXuhZWRihR3BEccL9/Y0v8Ch0nr+GPf6yYsX/N7nkloH3FTpiLpBi6sH9+D1KCK01eYwywkSX
sK4H7I3TV0b4fxLJ1cIwlNTNIXFYBeC5TAFLc9lCS95M7G6jqFGMTjsJMWOYixV05KnrzjJNGHLN
3N5L1Kfk/todBYjx5Zw5Zot7tm2KsSMjqZxA9u+MJ2SbONHnMEPKU4Xi+gI55TnpSQVXrsvKI2/O
bjYbGkzPxtBJxQzJNg8LB4XV9NF/iqv3Y/6RkFm0Fl1k/UZ6rYtGp9+K6ZphcmqwMCRm3IjH1xpZ
4V1OrmrZlPDAWo/YWyUamoJDNYRDPgkJuzqTfFKc3aMj+4TSoslEmonacU8wE6eHs7kE0byxoP+c
gER+saTVt54P78wSnkQcGuypw/r3IAQn7l5jw+lkJgtu+FjPjjd8fTIwi4mpY3XjA/vyov9cx+ID
aZkV2wFiNoavyA2uQNI5RFTA2I8TMyfpfCQSmHtg6xQhdCP6kLTtxwKg4zZ3jOY5CZwY3M/cd1qo
nJJGrGCn/sgyPSulGMMdUqgF1Ubr+kSwQYwVwSv+pomDUWiNQzya5lNRAWrBipSLj0w04/FQXGsR
FZZliqXqi0r2YHXa3+Fj+mazfO4YPkSSgVPOgnsO62C5OxaoDaGGXhBXpiSHwtJfqO16/M1QmwML
o5FIf3+GzYBBY5Y6Eghbv+NVKF1SmeIaQFJ1nE1yNsWvqN0vG3beOW+uEvSRuzyjL0bpynxGPK6J
+0ADLfx/Y6hBgZyZl7dF0zdSc28s8+Bz3y/+QCVzEnD/JJcEe5ZwcZYxRSRbdTcYeIJyDpgIJ8pX
7roCzczyLcTkwXTSx3Z0hxl5LrVLsrym6K1iXDvc+h/KzZGKzErbc1FcAY6I/qzzUPIvvvWCYHWD
cml5JH67B4Kjs3yWMYHn2VndLmm0YkzXj57NnKsRBqh/ulGF2xoZhiN55wjFTeawfnUXJhuJR0ee
wK35oHb2pF4aYTBak79MUk8tCidDxmaz3JL1gm9c3k+fMgX+ij1EXCFVdoS72FZ0sL2qGnqfNCKs
nJmgFmWWCWj50yZh0ep3CnUB+jgF7/9ptv4T3AnBf1nMkjdsxAQqdbUBPdfN6zgdGDg0DVh2zpkx
PBx9czLmqZDqKXHaAINGRL64iuIDN8QgiBF0pqp50yRqLH8yo4VjPH0Z2O/IfQOGgfBNes4SrWFz
mT+XGE8Yt+G2j3ZMoEi+Ui+Q016ipzHo0h7GceemGPB7lnX2M+dB2ZMBiHpFxzgxBP+JWf2v5L3L
EfygUBxi6jVMVdEUy0zCgTmpA7uIdostuJDK557XASgJ0//J0j9RQ/npHAab0E41xDV9H2o3c1YM
s1fARwqMTMzyGqlaKwud/slfSbi3RuaZ6NScA6/8bKQMCTcpJW1/XfnsOWC1O6gzbiZb58WRAAPL
YWELOzbMf/Y7jazYMCfz6w1jt+Og5hzgLdIR0e+MInPjoPQyqezMftjKIcSkf9MjkUkbYOL+Gj6h
HxExKlxXLrwQL2PkoS60G18E3+2p/RnahQNWViIMh6TMKsTztWI8R8WBVRIJRB9x5+s9aD3POsHI
qLX7n8SadfwC29pBb1z747KvhL0ug0WNqPWWUcc0tduvEABsvDLL7qI4IEWpboRpBZKaOsEZ+NkS
uODBXnSk/fofwCyRQ7cV8xIkq7aGuPd9rvJE46TTl01D2f/c3DNHM95p0wWwpcZV3THfFlsIQfWU
G45xXJDNo0B9Sy515ihn/aCe5sbJ7kHpxtI/HJxWQ2X1N6NzQF1kPqT9dH5SQBkw8jtTJXIl580b
dwni6dVk8QhoAbTrXLy8dFPQ3yRviwd/BGVIxsQAeNV7XVnE5wJAlXCpdSfVbiD5Lh7+T0i+qdGX
1UKVY9A44aJ1CR8pQktbBh2VHn8p4jeYBFROCaV3G++6ihPnOezBjVf2KXdSm95R1Qv4R79cLVs1
PjNNkktmYbEqo/0SUWQiiY+abuMKHXZ3Jc7TAUCJ8VXPtoiOaljsYplIqG4cQfHQ8RyDKcGbOAYz
UMwS1l+xD+AWw5ZBFSDzCPbbx5cbe6/Sdppgzc03kc6dMe0Of0mQXrGK0yW4CDH6XyACn3vGLuIx
z5TzRDBXt7qXyGQ/1BYgQ76hyEDlVPcEDqzU7m7jacDUef0wTtMcLdsWgTtpQYTxJb8lWB81iUYB
3JJJyZYDTypLbUdZgGWb7bhJ83A3ycR3uUBHX6IKTPrXDGFhUECzK5jNvnjE9Zwk1cArBL7r+a2k
FD9r60Q2o3kkLFYd343349TPiY+zJcHD2CswpybNbsbd+1agAUgz+PDMMDJ5xQJfhHkSbzya8qz+
q7gREYPrlLV1JxDCYdQJxjEbnYp/SJe5m+Kpzte511GOU/jk5Zubn4gzEEDnrWBO92va4DpEYXbS
zpZKUyeLyl2veAFTbDweDVzkse22wo+9puoaqBmGyiRsHBvxJmLtOaOuDriu7FXJQF9vnjv3YCVt
fGqXxLNdK0zMktC5p9RVOKUljor/KVZ1qJSE8i5AQndPBMqmZ+4HFyR83kf2Vc2LtZILRU5j9nhD
XbenHuBDA5Lt5nrNGRXvbuchyMrIR6deZKHbIARFh1oGtR2xP0j7mEGVD4mmLMppnvM1j5z9piDU
GVMsulHmYkmgWnlkfdoCYqEsxacMw4QXo9W2GE0iR1+Q5wFWLcF1rW+TIdRUqUAU/mZiexwFegaf
//SRV1w5tJKvCE0WnqKA0zvwntPhlmbocbCW5kcEnzraYclrVEJJylvLuQVrYSyksE90QYjOvLqM
fHCp2mzb0Qvj5Vv4Q0rilzY0VsL3L8WWYTd7W0qFffGH+DvbipuXvBezZrccDcLCZ16EJxQcPYsq
8Nkji2N+dZ8m+bxICAUY+EdoOJhPk3TgjKRQ2RH93FTVdElKoCFNWyL00fC7mvOHbtEtmed+nQp5
MA7iSOS7EybcbWqi91HPrZW4tCVYq7+IdmfgBLaghpapkfybXVFtC+PkbBCjSXE/+A2hXXBB0tIY
nEZU/gzKe4lmD0J3DAfpSXNRdyPNblooJXuoIr4mngSFK3B39Vi7XkgUBW7U08RLld86aFt4nAPa
qintAPWP8Av+NpbkJ8ynTtaqnrmwNOpJy8zAxa/MaRziPfjECK5ZtjmGdMlGs2wcKcqGllAW/qDk
0Wvk0ywM7eYYpsqcUPlf/KxzFth/uyaQjwKNMR9bwfLLDxWUAvaIJRFtBq32eKcioMsD3qA5JQoc
H+tIO4SKEHT0uxWRoNdz7AhW1D+0uk3fSH6rSbYhuycWfdjk8ujyjDFOOvb6ru8LCIKhheh8j9GK
8ojIEGOn/8BRgypTTnxJolbZbg8m8+1F1gmSTgyePnAMooCbiNfZD1vKsgC2qBS4R1j4p8iuGmU6
R5UFTXcRiosXQcIAYun7TufiRAieG2sPorKktOOW/kFuUpy//l9G93ok/OpKTrqMUvUlzkvNKvpV
pG6gtfsEepr3R9HwxXTYH0X/JmiZIT7Kt7fMffEYHv/R9N9McAUOlk9aGKjmlj3mSy+q47jk8V1O
sHKi0DK+704W/AZ1DHqu8MjvucU1PY4t1DWdb0561VJPcuS4JaD3/tuiq/eZCorXffnyTvEvnYqN
yU7xql/2H5qD9KXQHjgVK8yza20zq9Ee84MjBwfe73ryMB4F8UctB16NNuSshUqWn2tprL8pHhkv
Mr4HBrP8sKnde/ALrFo/x+/4lkIqA74jx6jBwDIb+/dn0dxm9IkT9ZH8Wd91mrBqNMGM6KwyhOWA
GT2V89DmzxGGKHlOPWQLmWM3mPo4b1xWNKKLE85Y6/3TP/LVTbYa8qUtY4oFmzSz4yX7ENgqz3OS
HbLkHFfdSwjQQABRAxkaQbgWgaUBLHb9OA69DCEW2tqe5C0p7/K0bLsFt8gbI5tnY7DV2WtBFkrW
vbPHCqalOSzKZ043ayLSP1r+nYH/ul7reDEBCdWYcDYSBzXKp9KgGnyISita8W17mF39V+NhyiSF
2ApSN5HDjgEScoPlgjafTfdCoZ/VpGBURqR4IfulJZ+LB1VPnvvvEvSTJ2QcK5bFg76VtFsl0w+c
pgMFV/O9xO+N0NvgH6WBNlikUMhuq9wDqq6MnMp2ut8+r0QiX7FNeMQhKNVSxfXP+S/MQYqvWYi8
hvVsp4P84p5k/cWMR3yR/uadQ+/6Q/vJAoApVJPDSQMLcrVBSLvhZVcxhysc/xATIjPVlTdUVRUx
kiVf+iIjk8NnkLWslqhxgnGBgEC+boDTXxTKJDx6PDpyKIn7rjn7jqDLcKRLa0CmBHMODHrG8czj
H4I+KwHfoBvmT0V3ca9vVbPTTvOPEioqEDwJpxpPNrFktR6bYOUVGtOcLyZn3dfznII3SxuNz/js
fAd4FVnHOhFozMGc4rTQsicsZjt0QlrFLG6d+4oJEMZa1V9yW1GWKMTjgkcamCax2IIfWUjtcKHp
Pv+Hxjc8XKCNL3GsBmJvEeSXM9s4TiaU5M1O+08eQj9qabquQZUaK7lpLNfVyziZuybSpvfraUZy
EmW5N/VcV2hVG6lmh5EQYyL3Pa+W9QZyUhcA2uuNrYoWtzxBwCEfNHS9JMkGcwhi2rBbb/lOxN9D
SVaAw7tUuU0SPxVkW+F4NkYfxCENDWDN1mb25PuSGXtLonSoHhTYAxQCY+YWJuq+M0U8G+x7BaWN
t4WvCcx11nlDKAQPXlHKbKL9U26ht9GuFse8kdD1Rmm16O3EmWfKwPmXZ2g2b+wv9VKAXWm2N/JT
9mXW8wFpFIdJiv+foZI7r2bjiFjxZ9sv2ZU+LE7CvI0pbY/PNyp6XC9/yzy8nu6N2HjTzlJGfreQ
mm9NUsz2RPhQ/TYhluopmo9AmSso0BL8WDkpZ5ZHfL1zM1qGgve8ljx0z5k8q58KwRyp6FiQjeP/
kaEP/Phx6MpnDOq8sw1u6pZKHcIQ4WKxCiSWz651sGAcc2xyGyQikjyGpTgh/31eZpcfoobfFBR1
Mq2A/lCTLR1b4hYX6pOSGWTnwKW3UEKsWQxCNYlXY6O9X8GK9kS83LaxvETpEVYH1MiKaV4le+zw
mV4DpZXTrEWRecIx/FKDSFJioargnZNyyi5innxBUFdfRZpGUfM4SgzngO7N14OyNTgdDyYFxjgR
tI9ti5qD0b/odSMCT2mzvwXIdkjuITlhqby8cKCrX+uuQfk0B6Xr2ZyKZCWTkjMYzFCXc94KtfuH
U2vt6CoSbiT7Pj4eUZAafoKYGC1HzrSz2LAm/o8qm1Ocy6J27LoBA5ew6jGMkgme/N1/Xq7j4bQb
v03Qvkm7jSRm8WkhH1v0M96yQPpBJQHQ8Q9HogUD8ajOClkOZgaEJF6YL4HrADgJqP/O/3JQniUR
O5YGPFJ7JaaJrfakEVPJx/VepAT7yNxnrvVifJ9Gwuvu2aJPMY1W82oO2hVBJokefFKbWTb87cLR
rFXgiB5gH83UcEEMOVNjuZGB1Brypv1nc9YZ2Lgp8AQ/pNtJOkVMCP4OvXxdQCKHfb4NCpGe8jY0
FVrYea1e96HzI7oqDSPdcy0W96zRFvk8WSNMCijSYTYgkK0iHu4EdwjGRlGyHdq9GB+hw4BTj2Bq
f3CSXd6vAO4yIj4EFnp9C6jlctmxEYJOSYziixBE8REYlOiVHo99QHuWZiuVQGbq9pmddNbRQZW+
HRvdGGfXg62ZjWe9eADEA7VxIsHLVIvO6b+4FoW4GlDori0gEtKeNqn8Nlwwe8swSFxl9OPFBC9f
AzjgKDdUxf9F2JY/ZkDYKxTsbYew66BH7mK1SoXkTaE+jN3iVqGFbSYNGV8KYmdUHQJ9h0jHjlpq
DnDullBSaUaF8MlNetrh/TWEzbxsaMPM6tnwLM/uXmhIS+MAW+6+2pMHqJIWuGk67SyYoMjr9/7x
1Nghjk/I8DmtUFwalCHEwP2fKVRdqaQCfBcK02L8zAK8Nw3CC8JKsqRyTY+MzbiI68sDHGAbDlsb
nobE1lzRwZroMJyEcBm29bGtrlXI3/bubHtQrfMwWVh3e/eSlE8j1fmMooCDRnZ1iugBMKo+6fom
R1IMw62Cn8rzklHUuul9e94veyD7KUoIK7eLSPEU9t98oi3IySqnDrxfl+rDbbgntVMJeiQRZ4ry
DW/Keb99oqjt8bRuTcDWzb8VFXKSbvyZj9qshyDRqZM4C1BdWLY3Ga9GR7Ulx/XjNpMmUncIxBoK
Y5NIIfwNfY9CmQV9T+j5hkckph6NvwPhoP5QEf1eoRKlaRfGwkIDojk4mrHZc/Usrs6XH/wZPThj
hRDHkynM171P8eYKRKJ0dg/FqJE5DjT8LqHt2vxP+A66KIprDXZ6BNKRHLddniDqkgshfUFFEHJh
GZZ0WoytzjAXvyTqQSiGdQlz9AFShYYXYb39ZwcBSYF1SRehqUNuAHM+WhuQyO3FeoRkW7acRUaq
Cr1LBSNwrGUw1XmE00FLJbEvT+R9o/kVfopCC8hEocHbvCTPDLReExMY6FeucfagbljoJP/std1P
ew8pSFUfWFb07kL8uE3HotUDvJpsFwu1gbq2IUeAgTdYlAf9T2a9lzUqusMrDfY8QFay6QC2U0qC
47Hy4e4x2wrkgQlwlW+G7YoVjwY3EM25bunYJEiffN6nUTN7EYpLBSfT/NULgK43te3g+m6+mGh3
82Zqdxo6xKVULi13E6Arcf1dp6TpOt8ENI/MqLikkeKPW4+rLI12JayJo/5NPYzvZQRgfjX2daEY
PoAjMPsuwb+c4tOtGaTvHQADLnqIai3aRaOAqK4qnGwUhmM3tZDDvWIWg0PHhQJBMLoqD/rVQjGw
fM7pYYUpCtOeDaVSnAx/BRZdixSQGlI=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
