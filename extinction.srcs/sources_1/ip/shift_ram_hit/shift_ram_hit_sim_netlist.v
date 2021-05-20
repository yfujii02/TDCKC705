// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
<<<<<<< HEAD
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Thu Feb  4 14:31:33 2021
// Host        : localhost.localdomain running 64-bit unknown
// Command     : write_verilog -force -mode funcsim
//               /home/nakazawa/8-gev/kc705/firmware/extinction.srcs/sources_1/ip/shift_ram_hit/shift_ram_hit_sim_netlist.v
=======
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Thu Jan 28 15:31:32 2021
// Host        : dyna-comet running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/comet/Desktop/COTTRI_PROJECT/Firmware/Extinction2/TDCKC705/extinction.srcs/sources_1/ip/shift_ram_hit/shift_ram_hit_sim_netlist.v
>>>>>>> 82d30bcdddea1ab3a785b38cc9ca2d00db4d7f72
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
<<<<<<< HEAD
kI8Fg9DREPNr1hJI6nJOOC0wEJmFriIjSLAgIjimiI525wmN0W25XU0MODrryeKpqFPrkJ3ufWBf
/Dzzlnp3p5UYkP5xK+7i2rDNQheAm/ht6rNUVI+jc81jt4V9RleR/oXqTfJ2595mJbgrvpusDgOf
y5CRnh6XLEuW7QfCDAaKYXQG05JtrOv+G7fApXf62BXrAvzXOzi10ApOTHy8g8aYF/NdN2+B1pR+
HgY8kal/HZfAhPIs0ie005LsHqnfQFLUHPLp9c3M4XqO3HHsWn+ZE4EVXjc4e0p88QyJNjmVXviX
9b30ukeRdnzODFiHrrvb6AwqfYfSFgfc7Y9hew==
=======
NCSSEoZb2Kvvr4x8F8ts+hvVg88TDrQjLsMD4S1OCnt9ny7C6NpcBrmG+mU4+90BALflCFM3A3cR
dKRjRpWPYhbkxM5hvo+txwskqBdPGM5S1sLQ8SKAY6NKsow+FXfuEBDuKDVw1iS8qtOv3Ipgc94k
l2FA+9ZywnP8Qpy1+s5v0eUI0mC3B0JRj4IxPA3LvHIvsrXeEFF4wqXUa7Y5PsqcotYbMNzmz85N
zcPXfqqlP3kol4WtFBCKKgS0NRQl0wNx3ae8IOcA/qTVTn6eedCDa8MvFJ+3wxehgpIX4IHqFobe
32X8j/+eorWYe8+9AQZ8nTkVzIQFrB1I67FODw==
>>>>>>> 82d30bcdddea1ab3a785b38cc9ca2d00db4d7f72

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
<<<<<<< HEAD
DvE4jrqlALKC/Ug0W2lT5TL3D0OStRWVWKhfGfA8FT5tm4ZrS1cQZnQCvrj4PvlnlOTSgRk7jeyI
Kc73COG4Syz+wv+y8+ROcJ+7fCJJQxusEwuAhGJPaLyuMkpF8zwehoQVLmgyydkMXBBCDcTdX0wB
SYu8mSsfZR0YBuW7MF2F2nt/Nf6dQgjtuvDHerKQKYscT7e6FnhGNcFULLhGpttfaOQ4q5gYLjGH
Krr9n+bgnur9qE0zyXNJwlQgt2M/+cAJptl1KTk/t9uNGlDd0s7tuGPC21dPmY7+T327EKeUhl+b
e1OxWoZGz5V+TFoma+5FkMxvIv40vTwu3jjauQ==
=======
sgc0B2hy/Th+h3QiK6QW09wtN/NpWU81ow2KOEzCz0E4LsP5ov7Qof5y53OwZr7iYHpHKafwgvYb
cX5hQcyDz2tWmBxRBAxXkWcxMGCbStsngcDO8uW6PwftwOW5dp6L4d0lnNqBucrQD1ceJMCv2lxH
bvtakmI0JRj38G2AHY7JOqZQkVZFD7bkMOPfYKgaGpHNCNeuwQbVds2+T/o0SUu1gXfuiExsujcT
2zITbmhNLdOM+IJJpWVa6ZOsw5+DnB04cp56rvEy1DUAbqA5WHs4IaMl3wA95ygI9YC1JG4eW182
UXqTr4jH3Gxo1RXncqCjczNyVdkruK3VTUDGEQ==
>>>>>>> 82d30bcdddea1ab3a785b38cc9ca2d00db4d7f72

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 14672)
`pragma protect data_block
<<<<<<< HEAD
QpaCUcDExkc/VT339KMF3Z1GuK3JCWkj/PV1RYghIfj1Z/ubnwqUz+AdnPSTkNyh5L0Lp6GhSLsp
9n5Bqg5RgqHfiK64WF1ulultNgxc94oQjQB1f/abhxe1yx3E0PutuauekKQW2PQES6ritG6Dlial
Cs8uBhFnWHKthnEGNpEVE9mpe+Cn2AkIorKd3QZayW5kTNgts/Bn/k9rfpX5Yr5EDgxJEvPMeV37
qordZnUWeSNi3t1ouGj0CNHVrkXR0vj76RuUTAe6SOafTtN+w3x4jOL3jnR62o8QTwVlG3vfARw1
JY2tdlOJ14sIxL8NnbQvgV4PK71d2JC7bAf2NLxmdtHG8HZoOWfIkT1Kp3cJs0Rj2j3tVraLlT8A
bvCa/tK53+WlKjDSeHMdhbWYVxPWDwsVA7hVj+o4WwcxP1tYgH0uSGNQV3xkDaboHpf+1VPyZixn
weRAU/dJlPuOw70dBnRjfedvx75HfbFVYUGefPV8427UCn3iaoGK1SNVlksOY0g69F4PTvnexseS
z/zkUYMLWz7nZkKMFZLaU7hRte6CCaUKcsvHUsdG7ofLgJjA57TSVLRIdf1W0sa74L5LDCpd5DoV
fxRt1B5Rjjf1tyJqr1nWrvsD9oKsd5AKkPdjA96mkNw56K5oRN09MWUd8lWFkc8MCW488gjwajHR
GOZYT0lAerQDQoC6OxWvxJj1p2tncdexyz+Fqmx+vVZDT++gX3yWb0Jivc8jpltvlPgKfKGOaPLZ
4q37bs7/8O+z4NGhyYEIaBiZq6sVt1LjiRpHrWX2wyLk55feXdc42ufdg1jjdgkdMFs4s3MXTWr6
63nzfAKo7oQbGRbMy4wF9n2DlWCLMzxPpnDaIRyT7y1SC+frhqh8ZM1myZYY5rtZUg/A09SaRMkq
z9kCRxwgsEuzrAjMYmu1IdhRQNCbi91gpQBPRXjYyVubmfbTN73qqC3ca2sQfq8Eel6Wf1GRqDwv
lkOvpKsd+G5uuCy+Xj4GVsPXzoG8N9rZOzWZeyn+fm1xf+5vW2fMmbIgOSTeUejzYCuG53THD8xC
sNynn/QKQKlakuO9ToRfvEm6eweR0cciJXrd63tfyprPm4aCevPmdh42mmfxy9GyN76dpy7k9gq4
MMHXUDZXpPlM7qDVZRlw99E4j0FTEDMtFThf1fIIajG4gtqIwqrUf51hjmLlg4YkmD8GOxiDaK0n
uDaWi5rceapXrip6GF4P2Teni5+ykf6SxaL/pP3m+eiDTfhaj5JK8CoanPrJVjgCGUtvyVLOW9q0
EMoXPpxKIrun3aPwHDRje0pinGxQ1ALeedus2O8FsGxb2JJ5AGAAPBmOht3JfkU3Kz3a5bfSYw6B
O5EWgqyMBsDVn/j6TARkGR6/HRuzgNhN0C89ogaIA4N0zl8Pu+UzcOPAzWNnp5fk5M4cpcjtgdOx
uVANvEz46I6E15bUopqXkCVu3FDAG67AGqH0jpVng1kpfvgpq86AATlgUbD11d9mPUIQJonx2nJs
256WK6JMquWHCBmpxrYDZVV6WxbDr/Cz/gDocluWSpDkwDv/k8YEvaPF2WselASfC13FpHnh6T1D
oJkAm9hjzXegSsmiBCdsfhiANPbTfJCaJOPwY7ulRRWwsGSUMMj0T8HlCykZifF7IN6d4imBQLya
SN1FpYXRx7CSBcM+HHVpErBFBV4CRgHeVv1ueo5q9gZYL4Ou8INOqFclPTRxr8iQYZYuokKgiGa8
stZQkHW9J6WBYFNIsuY0ebvGDbJg9PcC0IyMsOB/RYHVz9hfXzfV20dMq1f9XelwE3JgRrNu5OOh
Of6GoP35gpzFr/icJvvqS+7dLzGiVp1J7PL7KLqiAiOrlkflBFalQPe3fv7gLx7ChF5CUn4FGac5
GPZYnZCIAX1XziWsd+Ty7vfo7QbDGZ3G8EMochaZBLIhASnz7VUzsMWf9gCz0OxexDZbhJLY3si0
FF1MQ/6SWZicgIANNWdnAI/84E7YR9L6Hp7YcRxuKWzl54N0CLT0ntvF+R3Vtpb894uGasPrJhBW
nAVLBsXnTjdq7lI1Mu9D4jWCz9MFD55BfW1gUYC+MQz9R9H4WXGd8EY5pkQUP5hQbn1O6rzz/tRi
h+ciamXvN7FP0lf11IPRId9JV/ZE6ETWEGc6KLodGWEyFcOoEKCZsvKnFshbkBO7vI3hjZfOqlyJ
Gml52ctZAQGwwFdsGADbSvz+9vkEjppXUyAeSCChA5gu1OGpr45qA1KCtzOU+QLKLGcxi8Q6S0/s
6IFAGnlpKRUnU35kPaniLDIGeAhF5OZrHxhQAVuSbQcAmbVteYOJ4biwXha3ZxS1S7Z2eorSGBlr
ezGq5dCyrX6OzHr1K6x0xhpu902/oIIMZhTmsKaQQzKJTCnS63VIysHwpOBL6zxnHVhMhd/AiwNG
UhBjn8oRmV9M7TpM92f3R4Z9RzH1fLKg5WeQvfiPeuwnYs3y0E+XQw8tlzov9CPEHQj0yRY620pz
gd3WYPPpK+aeRCJXjIymi07hgxMiSephM7pelC6O+h5dH/x/m4BxmEBs4HRo2B0GR2ALVGXwSPzy
UwJe6zVBVhaknZrLR3USNR4d9G+x0xL7pKfeR3JzLDejDDQ+G2Om/baegy386NOpI9KkOGM6OrVP
392lIaozp1uf0cLUuA6XXSh4dIaRtzn1cUfRK4anTKsUCPNbd2/0rgwjhOpIULWa5n/KZz8K0eoo
jnJ0tAQ+sUTd0tWfHVaVFv2aln5XkiCLHof/J2tFHfM6Qf1H1p3A/u7grZ7cIremi4pp91ruhXnw
1Vvdmrwm/lFjHK8wsMMS5TodzP4/6Ae0ZIj1knSCk5IiI1Eq6qc2RrhX9A+nwFzNahQ/4SghZaHq
Q95ekboRCREsjJPiJIFkYwI3YGGijNTBQ5Y0isPZTfCVmKgRtH40uxrxO/OFeMBRSv0k4kG4j8N6
9//bNpfDo4eqDqwMW5SGhD68JnkCU69uW0thYdpmHaXsWysL34FNq45vR+0nUsUKJayk/fOsxyP4
0lHRPRqxeWTqM66/Ffs940ZpX9Sg8bHiyaqz1LpcSA7WSvQnEUCuN14nHNfQTWght9lz7On+pX6M
BWqef9icT20VMCexiTTvAF/bLGEFZoVjtu5QBqPiB2R7rAe9QipjLByj5giCcAY+VWwM8fuz78ro
epZs2XHDmoyYE8H+doTXIazGMpIJTYYiZBeIm0KaN7PJSx9qWMNKWv3wHlMySGklzaQQbzYPR2ps
kpe7CLfukkPmD/tniFVs057sP7YKMjHNztmqtQ+oAnWdEvZ0aPBXjGl3Lg0/uDLOS4+ow8wXJ1Dz
OgCKU63nuc1apwJc4L4Cg/uMGQVjvVT8Br9W0E5Aa//z2SjxBCOo055MwX/XggcduvPoqbeHDtte
bPnIEimTkfzIE1doqoxkpe0dBOBtldhiPO4DiSfKPMpjeXTYVWTl9UPbNKHeXSdzLJ7q3zqZlVn8
uH6AUbu69Ghf6YNCddhoY3IZEm7s/Bc1VCT1WemiwgnYdmdwovZhXLgbXA3gSInRFe+Uy286L6bY
D3+O267li36jmUWMvZyibWo1buVFjxK1BVApSj33hBX2iNUQFjTRT0CBUcaVLotI5BoId50eeP4h
wEFGt9nuAgKKQq0ha/7K1y6FICpz6sQiF4JDhDtzX2Qs6FOeGZfP41pQ6kIGHhLxuPOSCWlOLmII
Kr7If9UIjHgg3FoXbz4h+h9/zIlKR2Ic2xAPPVxfWTOlTz32c6xeTQWO6AcRUV4+PY/wesY8ugos
GRbGkVy3Tm+pf6z3galrMz8lB2GUxrS+FBMzM9LAMKoewbNCYGOy6UvcQeFsagwFG092SVjt3PDl
zWHmx1dR8/6Dv+DyYszvN2oCIUomB92ha1/tmVfwUh1+dSmh0Gixbw6wRgDepOscB00PibT/GMCu
DKHHxwlsF18pH2+WCCLcofpqG5Gaiea9HLhjklnmZ4rwZ86CzIvPj7cDQgRHzTi0YJ+aN7BSNjBs
IR2kQcu5YTz7MmoRk741NSBgQ7RCVMaH8O6vIRzeCQ6mpV2XxoCp3jzyoI0RKBv53QPvn1K+eZMk
UPV859VbH/sfxgc6vys0lhOhkhSC4TFtXVX5FksgJctP5ZPIwmNCBp1/DQmg4irXEtPpdOakK3Vn
U18Im0nsQ+g6xuXZPyoexI3mGnQICIjdvg2KyKdFvoye0NCmsjsilz889gSRVFlGZ6x8b3NXOfqu
g2mlkKm4ipQcRPEabnUbp9jsJCysYfhs+RfhGuqTG21NhY+X0ABAEoZAmhgFIhIAFSuV4MJ3mqpP
/LS1EWNa6TGUNh5PvNjQOSvOmi7/+sebDTOaTLc4Ndne6BOH/DAHVSlsfZNDWfycput+iNWJDmVw
DqxNUF7LfaIz+bTfD1HzHfoTXZ3qWUbKVwHPZRWSUxPSKsZlirBgXG1KExLTyrploGlv4BbDHLjH
y+Si/KX6U5Su/rDC5O6Z9XE6Ej1PUOuSNXnNkuQlrw+6Pljal8PMwWuofq3tE4/oe0WsaxbknwMe
b/aC57xTYlcN3kcCdjJdDtUKC/S9444VmHKF31Gpv7BUCt02blF4Crk6ZjfiMmmrhp2nJwLsI+1Z
Bt9vpgNkH8eWORF4ukyjaK2GrVM4vX86qFfFJqSYKb+imTWKbXpgg5ZfNUKi/pRMgUHX2mbzHRjb
1D3gE6QeRgdrKtRXuXGLT8wYCjLbH7FWVHl8pYA9edWR6/rjWapBpfo7lo5R63We9R1KHA7vGbkC
rwOCmd3NQ18dD8nlAnse6aKLV8CiBs3GkLKDoyflMddRvOrnUxuSsBke605mGLHy4ktjbOxHmDxJ
P8kiUtFBh2VIVVsjsypIMZLaWADKohRl3TySKE7HaoLBVQhsBhKSDMXsl21FFjbXlnbzZ+CtpuqY
7Tv6zaWkroz+a5jeGmTG2L/LzcjCawBszvRjVb0ADIEqfm+BPPsF/LczKrf+AfsJOAsf65q3KYpq
ifPQ5832FO7n2v3QdS4oT6eLfE4703HzTrj5px/9j2EqsWFOBORENYbPx6JJU2IuYZOHEk9cqPFg
r1nsLd0bp72E+hm7IY7Z3ad3/GlFZZoS37wycQx91odB6rWONQKhFZMUb03sQKEjEp5JXio9uuKZ
JC5qjEbAMredmTTBVUE/zIuRhGtN1g+djqv0J66ccVn93DSafS9sESRO/fmEhhDEUbl3I7Yx8eMU
5D4UHLS7YWKRyjSEK/ESbG6dpZ1VayYjXEIQ81nFeQpxXZkeG0nBp68muVPeMs4aLFgCOHXpdLPL
S4O4vrKbSXIbmpimMZTyJN7c7Oeh/TTP3hyJ8F7LjzR/S30TEwwwZkWFSbueT9cINsOlOD0ywhnE
tv7TgW+rIUnJdTnFpjslxTYAI73OEOGXAgu2WisxDC7BXk3tyQB5lmxQKl5mEiNk72Wjar88/21k
WaQtdWIxYMdkxxMpp5EpHwwEq9S/NZa0jHJf5ecD+BSB42niUZLchIjtpEy1DnybCyGAGB1zAgR/
EywK3jFsakAkr5ASmy0gYovlEYt4DuqoDAyybF6LxGJ40leyDuBja5WY4Nb0b7c0vhJ+0TkGxa5C
1fY8bOqw9B8q3GnR5sifK3DfS5c5ATK8AzNSwIMiJ0rcs9umrdz6e4nf0ywwWrkGlXfGGajVqrHB
Vyuj76zVypt84MU0R0CdlMU6uKIff+HTKTPsZR3osICs8b9PnikSBFwszzezrzuppTbYS/A0USYH
cdOJVtqAam9rlyiJC1+LDA85sWZUhJti9z1ZMfW5CGdb/XnJDir25nudwuF4qC/6KIPJh49Bvfr5
Cquyqs761ppGTlU6WTkYtpedBSLA87HHxfsKVa7Mu0OeU2A2xBDtlLJ1f6l1+N+giJWU7eNHIAYw
iu1rvDqnuIhxjKDdKkrtBvvM7qpWWlEVo3S/sOGZvJm/8CWCKVfmODe1WJvpu+f4JDu/4LXZeMCg
BODoYj24vk8qMNuOwHoYwS8MxkkmI7Dq0DojZ6xumTtvkw1h3dMEox9qo2iHTfgc42QFnoWZN4Jf
k9p71wOUHMnqa9MRn74ZKYMXoTsa0gyUEgt+eDn4beJ+eJWsTL7WPyS+nbGxK71otD+dY68OpSsY
IiXdmCj1sjP1LNPUceta3pY3BjuHcq5rPjXJr9/n0ONTLXAEDIuk2+0qDuXXCK7LKRNMMzo2KUiD
jx/9i9We78GXm1QMOye4LqDwL1c4EKfRKa/NXsRpjWUGxYlPrW5QXDaGGGU2+Bcx8RrCXd9va4gu
uc++8wEYMQEuxoXH5w5o3p5lfZr7XUOm7mzIRl0RWoqCvWxbVcR+IODu33BoiPmYmvdhSl+3QvWY
sXNQmzWlgrySxluvhIM6pauIuwJn9PKBP6VhONKX83Wh0twGEDkSRrnEfzIXkswFj7K7b4JyZkId
XTIK35OjpASOUCPwx6ex194FQ9ScFqaTeB0GWUmPWvulgqzvTtcS67JCTYAMNrcMw2m4aEjc0+tV
5s5H+fJAvtqG7C4DumfKXsVWZQNrfXjAKlrTPy9ZXHUX5f1B53E9NILKyzeW7yFaFUJfSzDHaC37
LQYMow53e6bCqM3UdTtd0bwaaZJrF5gEGgjAyNGcaO8rJdoexzURtCuxYwjJn6ZkYYd5dhs4Gs/Q
Ixtjpzoi14Cuki4GX0I+xvcAq83RVYfbWizhOSHHv1EWBsLnCSh0mzfHTFQjaKaS0NIzdAcGGhgt
kQEIiXA+gINw0fXHlFIuzWDzReyxYxU/i9+ksouf3nw1hZhpe6TpOXzPi+Dptk3dOWeJjcnexMWq
NiNRaS9tPcfzMNFHb2kYSWpZ7PRoj9TkYzeBeYUnpRENQuqDSDb4QQflFbZ7J2s8PVt7r2Nofe9A
pK2GNaU4WWv5nnPHpq5Xw3hD7lMflX0f7UR4MBqwCfx1jNkIFwwOgJ+E2ri5BqPOc5bm2dOKrNar
x53Tq8ax7Tu4CodOTE82DGjpajDK92SI/PH6UCK3VTmWhoSXy10cFze3jiM6Pr9IdGHMA3sL44qW
Xsmw+3oBRW0Oy96Dwr05fay55Xe5QfFyUvMWtdZedbvT3SyQ6bkg3wvHvqkXuXkiKTZ7F0umd/+b
cmzhUiDj6TYK5rBHQNUmoxWE0A07dpiIFOItmqBxJFCICynFfOBJXPlZHKW7zft9RJ6+P5PkAEew
TRz/njnAcczlC9gvthyg0rtJQfX1/yUTLy+SkW5a08mDdQMztQvUz52zeFhhN+XTAEhXQrKjig1l
y9DEwYhpRZbyoRMu4Bhr7arC1cCidEz0a/cfNOA1mJtLOAeXL0+StNdAq78ypxgExn4m0YbzOuue
XURiTWeqOnX5BQg1cEfNj1P/CSGKgEf5JmtnnWHqSyDG+g+1yj3tDZ4ZkVkgfYglje7YGLxYCxd6
COWU5nCpu1pgkwRIKkLTbBrAqzXyWy51Zjbz77mptG+dE7JoHshGihOZQifSB5gGlHyDm8NGRDJt
Dp96XrSh5x+k6k4ciQJ0LV/Z2bFFZRfgW7Gc5lZoH7w0i9RftRZvUJJNJkRKBUY81c8u8t0S/vTg
0zoazTrfN1IF43TuWPpQYwKPKM+/1oxZka0phOJIooOvV/hd0eHkVk6FuAUaMnHNFfv0Bc3Fb9rv
EWvsdAtjexfJpz/nSV5fVWZNoCvJEiv3P4gLq9C3sy20L5IVFRB+6oCoXeHNMIMf89HRy603v//g
VAlR4vhBGRrMMZVDwzalVaUJe3MubYI8UxK9C9SN1R9J3ceqzMVnXV4dqEfk86oqRflsP9aAU/H9
Gm2Ej73OxGqPpLWxDIdKZ7pXO8JTduvwTcvDPsA/hwDSxHbekFC/dHcKWjmr0xZWChWIrIVKQIyT
1YZOa1dObPJAR+T+T3RWN4FgblAnEiTAeRigJqJilx94eI9paMO3mF36SAdeah0JfckdeUMmV0Yc
Hr0ylYW6awbfviR2g3+xLLnVwA6dzEXpxOl/XaVN/T/THsQVbQi7XIbVTG+VPpPrxgx6NDgZkDeS
50bxMG+YdEpgvKWBX0SbPGmNLXG79tYwXghvp5za1SSJ4XgQt9INAzJyMqtXumqRibglrwGXHUB8
U9yu+foR5niB1M4L4mZyNFkFpew+Dd+Bpx7MQykn5vQO8GkkuP9mX0KM2a4k8CApfCcJV5Buo7fz
xypRjb7iTLdBK4a5YstIFkDqYBTsnb9TSewEBiEKzfWMqD7ryk9QKi5fzGaHsnOkuoq5UDQgwJZn
K+LYtd/rj3bAGGzDPzX0URTDFUi5n3tBtuuvB9YIdEHKLvQGyQyPmp0zR49XMzSRTKtzlF+QuC1W
USQey1US7Xr2DPH0DN+gHFFCLhqCQEvm2bK25tv/ZdgdLCmQuwNub27t1oO9WdLyXdmHF3Y4k3wx
mE6TB6Fc4pLt9K0EtBa7Tvod87q8QRSwudzCkqWHChoHYLq0tssBtZ3JryTnUJsfU8JQk3MOH4j+
ig1uaCo2ll4BkbHjRJLJnGSG+5a5rGPewV5I2iMdj4qyWf6gSaRQIeghqTinsBE+vpcAW6w4FDbk
cJPm8mW/PiIKnG4iwI6k9/k49lSdUrm659KYza7J6jhEMCYTAXHBlujUtGYSkOnQ9TBfcKVRJmIr
AdmYWLNLJ7PjkE4Zz1ROP3KU7uPxrJUNyull9Y1U61m91lW0t6iedG/Gghd6lzvtADLFTGmq/S/O
9bfPtmTXKz8vhzpd0JwqH4zBDPkbtu+xKAUEManUFOecWPyR8dX/vyVc8dNoq+vm25oL81bAVc8K
bnZSMw/Fov1szQjDWl7ipXCr9y1rS6CMDdxyf8iZRrUvKDBAr1Pd0cC5KS8/UqqBYKLQ7wfSb2Nj
iR17zYoIoeLBwyJASEsSoKh1eV85s86kj44eJswn2hVpPspltsOTc2KRpPnDJnLjfyEeapU8ExN1
T0j5m6AlOI5JpKuofUsjgsIWQwdsldTsE4Wv1FH1zIoHr4Asws50tjwanES38Y/dR2Mg1SmVX0ve
tJLT/ohekE6JYX1jF3fwkN+S+OPGIbnZ8aFa4Gp3kmD8EpAXwiCvSqhJzHDeKxjvjWriileks9uf
XY5yQhFdLYupXQKZW9zA15H5sOJ2Iidxw0QleT1G+3W6F0nIZJsLcciQY0w33xlgcOWkR/wmx64N
7/iYh5LcHKtcBBZhdBvrg/jxP/faYF/9Xg/xI1A6y4El7EPkg+E3kI2uMiFBDYHN6lvtvgQKIDG0
6swh6hDPY1D83aOwKVw6Jb/YCD6s3h6/GRsYD/ZzpCRPcnR7brGfnIETkyEFiJgDiYbrToSFeZAc
Zz1WHGptuTXkfCd7e172tCyMcfWEv0Ysb3uPa4yofYLOnSGYPajJ9qR1W0c2dbtVyB4eaMOElqam
w4ZVpQc9/TLj66Xw/URCY2ecVxMxxRgl5Z+29BS2ZWdyXkY3DiUL4+SL8SdW4ExG62Wh872/yB1w
kKjAeQIGUrxsVvT/+kc3yGoNkC2GEzOZKGb8rZ4q2hlFzmWRWJel887QzYgqi5rlYBzeWtZ0uOTN
wn8BOpu7pqiAIFrtcMqz0f9rkDg7rKZAATcgeA29xmXQzl0M7u7b1oeJIla/s14sXvRhnx+DXOdv
8BrVDgs2JMjYrZ400UdizghQHJBhi2/6+oB0ylfmOBcWGr/xB2f/UuGELAayFO2tBWddg7lT7BUd
weMVti6wuORWncHW0Spd/o+jjYFRA6fWis7mtb6x/IPS855UnapYp8P1gShqJdyMylM9wR5WT/MT
2BZpE5WvecJXvntj0nMEN+ZvI/Rmw9AFZF0cv8LZkrckPnVhU0xRn5GSGvNhaS1NrrzPZkuHTdZl
UEJ1jy9ORF6VThnIkFp0zWBK11sEWe9Cg9JOvpXWcEvWcghdgbjlukOds6MKRcjnX+nIHzQhm0Hp
ca3IpJfstibgMYwsDbgdK7WWvn+BFF2qaINeE9GDDsO3RGlTCa1t3SDBl4uI7LjTc4KA6/tFEWW4
AWftxJ25LjkZKDtqjj3n2FOq3XmmQNh6zorJBpv4S+zYPLdFpqPSk8olUKf8Pe48xRX1SvDjmLYH
VC0xH6JrXFkx3y3FKpFNvhrgjhjUxxtU8btns9nHeQY/bVW7sClnGBRhJkkGX0JUfgTGRdCp5F17
IJNz2yRU2LhWF4aAfKif4ldjlGi/SSS24AwpkR/y1Og61xjVpiQ/y9U+DKYxLb/u4RRcW9rUqk0s
g7c7Bt3NNy1DKcpqEtkiwOrcZ/Z3aZfXLPB00d3Hat/nbQI76F8q5zMouF/uUljfoWN+Jw2PVcEw
H8SqunMRys2/UScU5qkPGibUc4mJjqJ7Meoo0XuRdRy+ml8N2wBCE1xjIBOLD2A5ScoDQ6yQCYEu
Myjb/p51kq5yCY1dFUx8sbM6Raw+D1zjt5ZFFv+2Cm6V9yRzdo4i8aDohpZltv6UXHyu/02pCvFc
Qv9mOMPYrpCvkFXvc9526lmE6fzVn9j4LxbaV+ZJQ7DjcJdbNRkJ9/kMKmnW97TvzDemFmJzBiOo
zQqnEevjQoconRd/CuSjypSmMm2YwnUBFFLpdYPSZYt9bliKb5cnAfRPvJ8cPyb6MHzeloL+HAyb
APgKPW0gJ4fJAFBjCojvSN1huF6zqcZ8hDlfQY3W7W5nlNwFhip49XyIjYbJqPfIcLJeZQc0XGwC
H8glhD4wp/KBFQ5Z1SzXhsNf9TidsUSJXb0SW3pYwIozfxZZt8uWzWJPGQ9eCuXsWT4iIgufNivj
/JQR4+imsSHZhpQQ1IzwTwZon3kryXUCIG9KUFqWXKO2FNWbtgymgrtO5W3VfXAaDpo3h+cKnoZO
CEBJUCx1PmuKZlAV0P09uGCrn/snJSrfK4RNI5hkv0JCbQ4hI16F086Vqj+RbQljkYPvVP/ttZZy
d7MfoCY0J5ui2Z73DswHw805ULoORloMFOeGOtuWR5OhoM24vacgZnkCFhylF+BGJjYILAzPZ7Hi
m9cwZLRdUhNpJWCDOu6pbjijPpPqj2Vn905Lvf6ptKy0JousWPiPVuwrmOp3r4Oz463/sT6ibB3a
8Wpoql/6gf59WRJ77pi8aDCSa0v8DO+iSLO04Nni4JeJs4yeUnjEi9vsISPdc/L8tgVP/ok3Qf7+
SK8BprVU+F/BwGfhbATu+CLUKwlMqSLaEfdHWR5qY1XYPY2kwGsDnZUlgDy1K9Jkn5Nnz7fQh2WY
w1ZTEiTLTgh6Ib3aJjfQQGrl7m1z7T6sdCIxZ3zP5At9qqSgupFoh8ZXIFzYOMz/mysrsf1ne2V8
7daC+sDp+bS0+CSMAks8tTwoOV3bNvlIb+0oC+8kJMAZ5H4s6Bdq4sdEtHzVBleuzVmiFzf1Q1j6
epOMATFUg0/mqB790mxq/+zUivBb6a/+anT/4ZFUWRhZZxrdAPpm8ny5EFE1nqiCIbxPLMEh1UY3
PA4eROkEpIv4dVNolhFthLqk+gv1XFhZUK+t9d1zd5/1WUvw6mhKDgUULQL+v39wSDFbQ01qHRfp
RJGDtAeGPKOzynLh1U+2COGZGVqELOTJ4XfGSv49tjGNxCPcpO7ILF5+V6E+A8hsl2Ca3aVlXSzn
4lZlKP7f4j4v4xlBR7S8tX8PsYwejKnq2Fmz0MdpgOPcucR025nakdmX9V9aDyh4eN8gDbM6NBox
B1TKH7Hv/kChth3asJ/hyW6xU+yneeWCjhHF4FKSHz/QnEUurIvhYp75nQA1rMOQZvjqujboc0xP
D9OsQQuwwl2LSHZi6G6g6M1IJSSepydNbq0RTv3E/y8/R2Q44Ug8NGZ1qnZMONQmswxQ2RAoHoHn
z0HvXUHirLY4fYC8a+CRCrIpc+0girXx5J1uKzoaxHC0RWTesDOkfUjaAdqi5EuRh4X8v+Tt53gt
0QjfwMrRkjFxYrhONEUo3KGUpG4sK874r8tOtJCY8lbLze3zQxY3gSkqSnFClC5AJzHVyV4XPsLM
GrYbNj7PxY+96+Bot+SAAQvG+Rx4HWqXqQ9p2H6cfXtggKryjspAY9p9b4E/s1ieiPq9NmLxM/oL
C/uWq/HV5ENe3UDJvs8AOIvNqTTLtsZbGaWDMEEs40l5TjObxZSv8OKSSJP956a36C060+AP6GFM
LJpBUHXGq4EQ+Ys9IYvziF4pTSHNE8CtWFbsdtItCM3GObkmEBqRsxgz3OigT9n67gprTDlp521x
fp1rsEiacsZtuqFUC59j/Hmo5i7N2dZIXoEg8XCjLQwdeI1c95PbSpD+AtJ84hM7eUynChC8sYHk
N22bUhZ1sKjgXEO8KM8rP826IfOSfAhLeOhZr8IN+cQ0gIP+KcOS5PSI188SNlmLA73BR47HFYDq
8/XEta4Z8csEjdcy46/B6q5F+GU5Wc43Pccv+xmCaKtIYldk/Z3u5Vc2yh916W70ymRwZho+eRjg
v4WigiEOQ9lJGxUPdRfJGPjisNJgEFxg5YQHCHz61MBC0d9EQ7jjYzXGr9XpL9j1O6xjPqnagDNY
uQtsSgll84xbLYdwSzTUGcJcS4J6+6OeM/MsdVMrMhnvl+jc57GaXmJevBoBj9fxl7+N3v7M+cSb
+HWBzKzJ/5xqe32CBOKV0cyPWdkDQ/7gU1uKiGWZshzi0SqaUGbcvBkBaoNCM9tqQF46L0MjoqY/
YY5ijnY9kEaXZvA1KHijPsy7Q0PcSfKe2NA3jqmj2Dbu8S5i/vk29BgWZEH8FPa8Xl3ahrotRNvC
i/szIAK/uguBBAN9V+gbFkREThLTaIJeLq5lW9mz6ILxwTsipZQzdwiFb5spwka3X7GB4iUiMjRq
a1zZtP/Z/4IP0yg9mOr7C3GpZ+UUG8Uc7B+t6MKk8u+mqRr0nFPFoFL+Heh5xdWM+FP6B6AxWCu5
6UTNV2m6VFah8OC4kf+3TBrYfjDPWr9uZURtBCkPwaOPuz+s01VdGQvYQIViz8JbY1hgw29opIxo
nGGb2ioNXeI+XyrSnuF86oWiBbxLra3sv3bQSDCHIOejhouMkDzVVLsBW/G31i2oGu8jaObApqhV
3Q1S2fsjfj7fBSztz9o7h5se1ShQeoRpENQmbPCmY6BPEH3a4PutqW2wBxXXrvLGhC0YRScytWuD
3/psY5hFPc6DarDSmFXH1+3d+Z+zaV5SwGoe/Y47DawjwqOD1m0N0+c0aMAS05sDz1z80c2xsOQu
fAkSD+iZ/eI6GwzlLX8wojdwaTBRWo+S6RiBOed25eK0hMfSR7oIp8JpbaLHAL0nMmxIzcmRUDTN
WlvzH4kRPtCcZzfJ4TUiJeW1iU9/gwYXxSP9e/+c8hl4ccPWlbm04HbgLBrC+Dsd22VezmQtHLQB
F48V3QUjam1HD+nUsYrqoPgUR7Tb5LIYiF1goG6zEuHibKcOGiOCHxWUFMVa6HswkRzBSSJUq4xT
PcRu/ojSf+lL7R7Nb2d/8Wu+anTIqpcbzsfTjh2gdOkQsEq0M4QX9ZBqMwQHGyrAsLY/2gO9pwEB
9W1WFK2ooNUc5gP92htoxxfgOYOVmiGqYQZE+lU2ykxdziog6lBYd3ggc78DYpi6NECFblX9sabl
WC0pOZQM8XXT6NX1YQIaYIpOMYhaqH5vCZPCCNQ9n6QmDagKMe1I/xUXCYO5/+XMzT9EZwOQ31G9
BHB0PHxbxercNhosKuGWMM6i4iuKPgLOy5toj6zm8L8EF2ApF6K+6V3MLSF+PEotmuIXqZak0dsm
DaSuKaF8rE4XIkL1R9qgynQe/pyY9GlFfj792QSwd7VKWKz/NQz+VsWqSuTRi9kXWr0lUD1A8NoX
SNX/Wd1j6Zv4gt9I9RiL57kURtPamEHdTXCsxBePKU/Gqhub14o+0+/UEvWYiMAJWtvlueQ/kMIJ
s2dDOs0XsL5ekIoPaR3KsfpVlhCiOgzgk7HDa96Y4h+vUNL7MUvUYAQdHL7RSKsrt0EE+TmkcRV9
TTg3iMEav2u/8wsdlRTFcSOADZsfNiGPQNcb7IjPihavbR6/EujKfQvjEEDyhNqcUwglYClqnUmY
l/tTRFQsgKEBGcZE9Zl0x7+iTnWFj6ensZxsZ3K3TRvotJoj7wDYxnJMAjbFVj+Ki4+gXAgUYqsf
bzQ2bSexN9mBKps1b1rDuAA89QOWWGf1KhBJHHtPaVWLms8VmcyaHqnryzZFkSBSBwtj745dAk2G
7/IkNXL/8IvFzZR/tVGXXGcm0Yj9moNIkjB6Wpu/ksHczy/W4rbn5qP7lLUk5aizVPde1c2To6Kw
HCp4RFIBcEFGB6eU4xtG/kOWoQQpa6s/8a0JCU3hzSHs2CNNIqk1mSkadJkSrEt36FM+Cx+gd9f0
jTETrze017dU46gVCSur0s9gwv2eGmmqHdssFBNyBDyiH5e3+RGlT73xsfACua0LdX8Vj9vxFxjB
dA4ICNKiKEypRNaKISoUebisFaq4nmZI/U6ajB4v6kUdtYfKHP0fzLa8P0v9SA1ieEq3u9JL62Ta
1xdc5CgSdGRAXJgwDsBjUuvzSk/lIfCxSpNjpdLjM0S856BI2zjVE6ZP4icPPy3B5CjN3+IaYlEw
O+TEpc2rHW7SyiY8l49gSBpRPSaDtj1y+yzrpR4z9m1zQZDjQOi7pkPvOkqFe3to93RvWZNx0wNv
0jN+KkkjZuqJSDr7kKEVFoAawrB+JR28mr4L/6wL0KWt1B+zfLhVAWqZ880y0s9NJNjEiz+xP3m7
b7sK+wGYQPdpfIu+6tDbP9YWc60vDndUKeBestfgZ+F3wvWhCwpwh5TpqJU+OL/zo5MS8TAZXpKr
yVGfzEeKNXIJOldxZx72U8wXa923JK/LGT8eIeZYJ5kRA+4bWfQRaVvoJS5LlIrglLqpzMYLBlds
0yzl44HHgrFt6MrnJ0/XnxIA7FP52O4gWqaBSYQWQ9kLxUZKA6Y3/rAMLa8KZF71OyBQnJGPxck/
be5oC+tODtPSo5hsxwZjt1fyn3CSFVHC6iU840O+q7KH/9P7G9TXXHDUabAXC2YVHsgsvNB3DAFx
uk82lQ6HortvU+BHPOFle+oXZ9ui129NXQCBntf/902U5/euFOMhU4kuhxx5SjngNJh5WgrCq9IQ
IjN04dh+UlmI9kkmzwjWMmWeLU2ns/f5vJymoLeAWs0acZMu+bn29sRZlCZ/6k+yKF/z61nnHGIC
rQYsnNhzpkNtmwZSCE6b7tX9EGk1uZ/+MNJ79UG4qvXRx+VWCY0yHK+kyN27YbAcB7pfuSULLFjk
ffUn+suOfyBOJoAM7+6BxuygMkj83wFHrAsv9yrsyVo8ay0O9Tte/A+eUtY+NZUonGpyuVU/phsP
6cY9DoY7wUItMT2wSkLWfPKa+VnvWLmK83GpnY0rhFKJkGlPV0XnQChvb+Tprz7DdOBdotn0YIG1
yupbv7ZAr/m0CYZ6OtC5l0d7L0L0kyohjDCuYc46j3NkmF8iTXgx2CrZM0x+plhtWe10+6fZXUY4
cDnMVZGAq6m58D1+iC+FdsZ2v5Jvp1AEQ1eX3O6BW9KDJPXI72a+JJbZEbEjIcX0Kc5PBgMgKGHP
bpfeRZ+lvtATikp6jF6CsZobVvGNKoPCRwsLTcLZPg6XruHPWqKD6aHqHCY2sR5Z3TIY8GYSAR1A
pbIssGSOT+S7YmLRz5a9PJ9PDXDLbIk9NJdM0wyzqYyK7sOnHy5EYDgNyABMobF+HDj6XDbO66we
2RkM5Wg/0vAr5jJFbBvALWydYLEuaT89hb6ZjAn+sUj19VRFQdFg1qD68KsWRkBwRNZLZoVzdhpX
zEwvl92tIh7jY1G+lxcPyi81Db8v9wBCyTBTSri8WYj1aV5WrJNY2mHG02yNIFDDJooElbDcOon1
mwqXfdtNqKCsCuGc8AINUECQWAnPhO9va5N/Rnb2sWk/efVGlo5GTkaXcC3alnt/VDBc3rM0wFwf
WcXrwxxzMeRepgcen2zKAtXhbjjQGOIKhrwcbv9O22G7VnjIWVU/5T6x+qlUfGgb3tsbk5HM5JT7
4vf8Bc4+tk8AvUAoAJnY88MQzbzZl1Zrt4dzU4mHqGrZb+AFz1TlNhdiR7nT/Mim8rHeYajMZb4A
TJccvEOsSsnXf2r89iZzsNu/VGcdw/28rjAE2r2QIt9uHHhLzrhglvRiJvLACVa/2bFMzLfyxZEX
Wjaed7j9vshTE7yt2G5F5b/MoOKCSNPb9zgip9BXYJOQXs6GCE9zOohi4J/vRADmcJHBckA7sTNA
YnZTOYJAzCwH/ATqin6ztMDRK7Q8c0+pzaxiq4219d9jOATRFZyj68nfEqF2kqFDWuVlbAEDmLLG
OZ228HxbpiTlvnQQOar6F4Hc15MHEAElS9+zcMk3p5Lyh++KEy2AIFSQTAq0zMT7hDy7I8Q4T9uN
iArPltH6gZGgtqoEaufErqbeWlQuKq3ltxJyw0L+fSal+3CV5RPQ4t36lwFeYv+qdQtoQl1FaPxk
lIoh0cqHTqY46b9Qvpip/eUwcZidbiVvx+RnYq2FCFaQoubDMZqN8hV6op8AwVxNuHIRAN2c+jSS
idVuh5w370pzA9BFaZQYS8gaoRYoB1GpOjwxKdlCvVtURxTaPyL+ED3cVs2HqJ8Py7LmoVZb3Qnx
Oy2oxFtThn/ubYa2es6Lo0WHR71X0yl+jmcRVVZ8v0EUu+1hpiujF/CB/PXyM+UezrWKsCNOV3wf
9+6azY2VeE2b1GgtwK1UKQ6OpBohdyEz7t6/himGJzAtjd1byI1JqqULELQE4Jj8EYzqv7Bjf08c
Cim9K/jCyxKH4RDR5/qrXKDBSCyK1yIpUpoR/Y+TxednRZzRALwxbm7SPcyf+1o02wNo8Jl+vPuI
zoiBiREkDs/kld5keKUhqqNYVzp8YggaqPhCG+BI7ItWr0T8Goz0T9OxEGcEd9eKho/EzwwHRlnu
8tJoMQ+FHOJ5fs087yxSACyaJfnnbpDFYWC8tzvFUiygU53aQvQdtT2R0bxuZFDciXsGtRARlwFC
87CjfNftimGtr7Cb965iQUBlbJR+8ScCQs4CYNXKni5F8LQx/iYb9+hr23VzYP1QoHhOvv2wRkq3
yO++mVFahpSqZT335KLaAMQaCZlCfhgiYyNjwT1lYWss4i1QeJ/bPNBs+k36stR1Xh7u/yULNTvV
ZV+Mf/H8d+f3VQGjRoHgc4zVY5j8EazBta2zCE8mjH/zrgTk/1pCxgZzdsooVg614+hLVEQw/a/q
IvozLyfbAr0AhYzEAmIYkKhUrOuzi/2DLzccnjOBruKkuw2wDJvNeO5VN63+6DKzwf5+aar9z6QM
11GQ0YM/JPiwsdNLthVuvj0oqIVWuzbU86sQjxXk9LL7kMuiz7KwBmzaWUvA6Aw40KdAXpWsfwH1
xR9tF808cZcVFrIjskkRiG19UF5xuhjM0wyTXTsCMLC+Csu9HdE5/vzbQTxuTpWK7zBBfg20b6OQ
/ewVu4NEQ93BlT5HtPrlzAu0CEZqr4mKcsZVNkP8UKXGRP1EKJpAR6MlYnSR3HlAHnSCyD+DU6Zt
1K3L6nnMP0Lx3C9cCIMM9z7JZfEiTqgS+1JQIMPnzGuNsfPyjoFd2Pm/suSKm5aSKR26JHRqMHPo
ct7sXqzWSIdkcR2nmapzUobQadLQQGGSJLI0tX5Pg9+m+yx6tpZx9Vq9HdKZ7bir/SSACx4WpvBR
Qyhx+aUuScbN3z4MeVEaw4yI1QdmVybfceRzzZqy5AN1VjBIil2fqaQ7xuB3qWgFLypzG9IdOvKW
ut7zXW76a4ivGAl+riuZCEnOKRiQXSdfPXVW3+dVp6aEK7j246/YudKFVFvHlVc3ga9RckZTM/Ah
Gz5zYttXwO/Mzjt3zoIfCsqlW3N/HWouv06d9U20am3AK3XI2RrQqivUAVWrt1ud5a08GevtX2Mi
XSKrxAgZP2Y+rgofWsrygg6XgOPEOGHAUKdF9iaRTNhvs+LHyesGsihzqKrYL5MFgknL9j2i/2M+
70R37Zo6vOxOMNEAynnmeVlWo6ndcn71jPNYXrQMqPGhidCDyNNAoqlPANa0yNxsdooNF81txlnj
fFw58HGefliyX76ojBCSp8dNoNDWKxP6qJEnELSOcqdGHGtg4UJn0gBMLlb4bqmn/WiDPzYQPunz
pVU5kP4qqLSQt8fBVP6wXUW8ybQrtnZ68bVCEvfwMRSYUELdVCY07yMpjoWZFJQXqALy+LI+vulZ
KCW6uIOKoSVzuRG5P4Cr7cVkEjYrbD1ckCRZdlV7N8xDaxkhS+c6G+VocwgBbMpJIZB0Ojo0dTX+
gVY+ru3qdjHK0xgl/0PR668jicB4Kjkg1l3ZDD32ccBWrK9Wn1A/kLCB5Yv8AXhJ/1SJ/HzebZka
X8Pg9d9lFKZolrRl3U5C0cS1XHE9gczir+li3gKJKFaZMD5JTttLDErGUdJtwtU+l69ZFI21e5Zd
tFY1ZvJWuOL7hqvPoCr4NZ5RRUahvxeA4D7lDoWEp6UiLaIpRK3t6wNB+m4mkAFn1EZbH2Zn0SZh
HeW42UKnUadsb7ywtSKKXGy5yUyHfqd0GbGKKAewHxnaBYj5j4xI4jmXhs7BSB9rL2z7L7PkaNGN
atNFzWf1gHj4B1I/uRqysLsJIq+q3+tzO8lwlKMgU5Dc6t3lhF3eLbuAz7jtdQdSjjtlyM2GlgLd
09BEZcIvs5dDaODyI2ItgtkifPa7oTkYJkqPBk45JNAvlRHImsPfG5kkui2z13wJG5pAgS1o8xrd
XaJkmmter5S7ttC3gMuWCi1dWahC4PTk3IkoN7151+qlPrq98xzCMnzBWI/QqMGHPXneYN7l3TBZ
h7Pb5BtY2/qDPZ/7M5Qpa+C3Nr4JCDACAhU8ZYAUQKXRKboBSdDSfpq/LzZ2LSngiexigA3Wtc+x
6SH1bErPXk9FEb2FFGFbxY5ZAhNsz68U7Go7lvjeIQakU+GENS0yH9gLzsBxP6xN3N1hEeUCV6Cr
uXdGI6CVegb1qGVYXp3xe9KiPF0ekBz4p5Xw2TUswI+i5HG+gMfGCRD/XkWPi7yWCrDwhDRiietN
tvqwrTQCMThVd0KN8rK/U8FoeK+a5Qdjf26lkR99OF93b3WvtWFOJQxYKjRF9CCCvFjql3g3sACP
XG0WRAsbOxl8x3vVIcpAsSD1V8wF2FzgtdXGIjD/Yf3mylFP52HZtodz8Y6G1sg2GpFwYFnBERZx
oFAvzPGSqxvpgzEbt9AVKcdXsnQYMqgXfrKLotCB+xRkSB3eZCP5+Fnyqt646Hfreter1u5o3AcM
ehqOr9gvvrcA7pKFOJq9Xs8cEYQDeDr+t99GyNE1QSCJE/jic9gzxRyR28SG7JJYXdT8tKnOfzvZ
Z4j3AUiSww9lCXzF8z279NX6pDjww4FG8V38r9XUs9Pbts+oGQ/xre6a7ujc39DOvQkcOzVF7Bu2
sfCtWEL5/nk2Ek74wHmyIgXBVPIJwKNoXom3ROduyZTEdp7fooXml5rN5Jn3B648vwhTpqlNyCyz
aZGZayZYj5PKmBU78UsQEq/paJS73WU=
=======
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
IcugLeTb9RC9FxNGyuycca53aVofUu0=
>>>>>>> 82d30bcdddea1ab3a785b38cc9ca2d00db4d7f72
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
