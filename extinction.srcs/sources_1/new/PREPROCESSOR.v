`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2021 06:48:13 PM
// Design Name: 
// Module Name: PREPROCESSOR
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PREPROCESSOR(
    input   wire              SYSCLK      , // in : System clock
    input   wire              SYSRST      , // in : System reset
    input   wire    [31:0]    LA_HPC_P    , // in : Connector
    input   wire    [31:0]    LA_HPC_N    , // in : Connector
    input   wire    [31:0]    LA_LPC_P    , // in : Connector
    input   wire    [31:0]    LA_LPC_N    , // in : Connector
    input   wire    [19:0]    HA_HPC_P    , // in : Connector
    input   wire    [19:0]    HA_HPC_N    , // in : Connector
    input   wire     [7:0]    DLY_PSPILL  , // in : Delay for spill singal  
    input   wire     [7:0]    DLY_MRSYNC  , // in : Delay for MR sync       
    input   wire     [7:0]    DLY_EVMATCH , // in : Delay for Event matching
    input   wire     [7:0]    DLY_MPPC    , // in : Delay for MPPC          
    input   wire    [95:0]    DLY_PMT     , // in : Delay for PMT           
    input   wire    [63:0]    CHMASK0     , // in : mask channel if corresponding bit is high
    input   wire    [14:0]    CHMASK1     , // in : mask for non-main counter channels
    output  wire              PSPILL      , // out: Spill signal (P3)
    output  wire              MR_SYNC     , // out: MR sync
    output  wire              EV_MATCH    , // out: Event-matching signal
    output  wire    [63:0]    SIGNAL      , // out: New hodoscope signal
    output  wire    [11:0]    OLDH          // out: Old hodoscope signal

    );
    
    wire    [19:0]    ha_hpc        ; // for additional information
    wire    [31:0]    la_hpc        ; // for main counters
    wire    [31:0]    la_lpc        ; // for main counters
    wire    [63:0]    signal_fmc    ;
    wire              pspill_fmc    ; // P0 for resetting counter from FMC
    wire              mr_sync_fmc   ; // MR sync
    wire              ev_match_fmc  ; // Event matching signal spill-by-spill
    wire    [11:0]    oldh_fmc      ; // PMT and old hodoscope
    
    /// Differential to signle
    genvar i;
    generate
    for (i = 0; i < 32; i = i+1) begin: LVDS_BUF_LA
        IBUFDS #(.IOSTANDARD("LVDS_25"),.DIFF_TERM("TRUE"))
            LVDS_BUF0(.O(la_hpc[i]),.I(LA_HPC_P[i]),.IB(LA_HPC_N[i]));
        IBUFDS #(.IOSTANDARD("LVDS_25"),.DIFF_TERM("TRUE"))
            LVDS_BUF1(.O(la_lpc[i]),.I(LA_LPC_P[i]),.IB(LA_LPC_N[i]));
    end
    endgenerate
    generate
    for (i = 0; i < 20; i = i+1) begin: LVDS_BUF_HA
        IBUFDS #(.IOSTANDARD("LVDS_25"),.DIFF_TERM("TRUE"))
            LVDS_BUF2(.O(ha_hpc[i]),.I(HA_HPC_P[i]),.IB(HA_HPC_N[i]));
    end
    endgenerate

    /// mask signals by using the register
    assign    signal_fmc = ~CHMASK0 & {la_hpc,la_lpc};
//    assign    {oldh_fmc,ev_match,mr_sync_fmc,pspill_fmc} = (GPIO_SWITCH[3:1]==3'b111)?
//                     {13'd0,SW_DEBUG[1:0]} : ~CHMASK1 & {ha_hpc[16:10], ha_hpc[7:3], ha_hpc[2:0]};
    assign    {oldh_fmc,ev_match_fmc,mr_sync_fmc,pspill_fmc} = ~CHMASK1 & {ha_hpc[16:10], ha_hpc[7:3], ha_hpc[2:0]};
    

    /// Signal-edge detection
    reg    [63:0]    regSIG       ;
    reg   [127:0]    sigEdge      ;

    reg    [11:0]    regOLDH      ; // from old hodoscope and other PMTs
    reg    [23:0]    oldhEdge     ; // detect the edge timing

    reg     [1:0]    syncEdge     ;
    reg              regSync      ;

    generate
      shift_ram_hit shift_ram_hit_pspill(
          .CLK  (SYSCLK          ), // in : clock
          .A    (DLY_PSPILL[7:0] ), // in : address
          .D    (pspill_fmc      ), // in : signal
          .Q    (PSPILL          )  // out: signal
      );
    endgenerate
    generate
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                regSync       <= 1'd0;
                syncEdge[1:0] <= 2'd0;
            end else begin
                syncEdge[1:0] <= {syncEdge[0],mr_sync_fmc};
                regSync       <= (syncEdge[1:0]==2'b01);
            end
        end
        shift_ram_hit shift_ram_hit_mrsnyc(
            .CLK  (SYSCLK          ), // in : clock
            .A    (DLY_MRSYNC[7:0] ), // in : address
            .D    (regSync         ), // in : signal
            .Q    (MR_SYNC         )  // out: signal
        );
    endgenerate
    generate
      shift_ram_hit shift_ram_hit_evmatch(
          .CLK  (SYSCLK          ), // in : clock
          .A    (DLY_EVMATCH[7:0]), // in : address
          .D    (ev_match_fmc    ), // in : signal
          .Q    (EV_MATCH        )  // out: signal
      );
    endgenerate
    // loop for the MPPC signals
    generate
    for (i = 0; i < 64; i = i+1) begin: SIG_EDGE
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                regSIG[i]          <= 1'd0;
                sigEdge[2*i+1:2*i] <= 2'd0;
            end else begin
                sigEdge[2*i+1:2*i] <= {sigEdge[2*i],signal_fmc[i]};
                regSIG[i]          <= (sigEdge[2*i+1:2*i]==2'b01);
            end
        end
        shift_ram_hit shift_ram_hit_sig(
            .CLK  (SYSCLK       ), // in : clock
            .A    (DLY_MPPC[7:0]), // in : address
            .D    (regSIG[i]    ), // in : signal
            .Q    (SIGNAL[i]    )  // out: signal
        );
    end
    endgenerate
    // loop for the PMT signals
    generate
    for (i = 0; i < 12; i = i+1) begin: OLDH_EDGE
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                regOLDH[i]          <= 1'd0;
                oldhEdge[2*i+1:2*i] <= 2'd0;
            end else begin
                oldhEdge[2*i+1:2*i] <= {oldhEdge[2*i],oldh_fmc[i]};
                regOLDH[i]          <= (oldhEdge[2*i+1:2*i]==2'b01);
            end
        end
        shift_ram_hit shift_ram_hit_oldh(
            .CLK  (SYSCLK             ), // in : clock
            .A    (DLY_PMT[8*i+7:8*i] ), // in : address
            .D    (regOLDH[i]         ), // in : signal
            .Q    (OLDH[i]            )  // out: signal
        );
    end
    endgenerate

endmodule
