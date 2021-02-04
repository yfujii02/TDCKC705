// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Thu Feb  4 14:31:33 2021
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
kI8Fg9DREPNr1hJI6nJOOC0wEJmFriIjSLAgIjimiI525wmN0W25XU0MODrryeKpqFPrkJ3ufWBf
/Dzzlnp3p5UYkP5xK+7i2rDNQheAm/ht6rNUVI+jc81jt4V9RleR/oXqTfJ2595mJbgrvpusDgOf
y5CRnh6XLEuW7QfCDAaKYXQG05JtrOv+G7fApXf62BXrAvzXOzi10ApOTHy8g8aYF/NdN2+B1pR+
HgY8kal/HZfAhPIs0ie005LsHqnfQFLUHPLp9c3M4XqO3HHsWn+ZE4EVXjc4e0p88QyJNjmVXviX
9b30ukeRdnzODFiHrrvb6AwqfYfSFgfc7Y9hew==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DvE4jrqlALKC/Ug0W2lT5TL3D0OStRWVWKhfGfA8FT5tm4ZrS1cQZnQCvrj4PvlnlOTSgRk7jeyI
Kc73COG4Syz+wv+y8+ROcJ+7fCJJQxusEwuAhGJPaLyuMkpF8zwehoQVLmgyydkMXBBCDcTdX0wB
SYu8mSsfZR0YBuW7MF2F2nt/Nf6dQgjtuvDHerKQKYscT7e6FnhGNcFULLhGpttfaOQ4q5gYLjGH
Krr9n+bgnur9qE0zyXNJwlQgt2M/+cAJptl1KTk/t9uNGlDd0s7tuGPC21dPmY7+T327EKeUhl+b
e1OxWoZGz5V+TFoma+5FkMxvIv40vTwu3jjauQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 14672)
`pragma protect data_block
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
