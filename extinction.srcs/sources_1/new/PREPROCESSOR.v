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
    input   wire              PSPILL_IN   , // in : PSPILL input
    input   wire              EV_MATCH_IN , // in : Event matching
    input   wire    [31:0]    LA_HPC_P    , // in : Connector
    input   wire    [31:0]    LA_HPC_N    , // in : Connector
    input   wire    [31:0]    LA_LPC_P    , // in : Connector
    input   wire    [31:0]    LA_LPC_N    , // in : Connector
    input   wire    [19:0]    HA_HPC_P    , // in : Connector
    input   wire    [19:0]    HA_HPC_N    , // in : Connector
    input   wire     [7:0]    DLYL_PSPILL , // in : Delay for spill singal  
    input   wire     [7:0]    DLYL_MRSYNC , // in : Delay for MR sync       
    input   wire     [7:0]    DLYL_EVMATCH, // in : Delay for Event matching
    input   wire    [15:0]    DLYL_BH     , // in : Delay for Beam hodoscope
    input   wire    [15:0]    DLYL_TC     , // in : Delay for Timing counter
    input   wire     [7:0]    DLYL_MPPC   , // in : Delay for MPPC          
    input   wire     [7:0]    DLYL_OLD_PMT, // in : Delay for PMT           
    input   wire     [7:0]    DLYL_ALLOLD_PMT, // in : Delay for PMT           
    input   wire     [7:0]    DLYL_NEW_PMT, // in : Delay for PMT           
    input   wire    [63:0]    CHMASK0     , // in : mask channel if corresponding bit is high
    input   wire    [15:0]    CHMASK1     , // in : mask for non-main counter channels
    output  wire              PSPILL      , // out: Spill signal (P3)
    output  wire              MR_SYNC     , // out: MR sync
    output  wire    [15:0]    EV_MATCH    , // out: Event-matching signal
    output  wire     [1:0]    BH          , // out: Beam hodoscope
    output  wire     [1:0]    TC          , // out: Timing counter
    output  wire              OLDH_ALL    , // out: Old hodoscope signal (ALL OR)
    output  wire     [7:0]    OLDH        , // out: Old hodoscope signal
    output  wire     [1:0]    NEWH        , // out: Old hodoscope signal
    output  wire    [63:0]    SIGNAL      , // out: New hodoscope signal
    input   wire     [1:0]    SEE_EDGE_TC , // in
    input   wire     [1:0]    SEE_EDGE_BH , // in
    input   wire              SEE_EDGE_OLDHALL
    );
    reg   [1:0]  seeEdgeBH;      /// Reduce the width because it may not have to be a shift register
    reg   [1:0]  seeEdgeTC;      /// Reduce the width because it may not have to be a shift register
    reg          seeEdgeOldhall; /// Reduce the width because it may not have to be a shift register
    always @(posedge SYSCLK) begin
        if(SYSRST) begin
            seeEdgeBH[1:0] <= 2'd0;
            seeEdgeTC[1:0] <= 2'd0;
            seeEdgeOldhall <= 1'd0;
        end else begin 
            seeEdgeBH[1:0] <= SEE_EDGE_BH[1:0];
            seeEdgeTC[1:0] <= SEE_EDGE_TC[1:0];
            seeEdgeOldhall <= SEE_EDGE_OLDHALL;
        end
    end
    
    wire    [19:0]    ha_hpc        ; // for additional information
    wire    [31:0]    la_hpc        ; // for main counters
    wire    [31:0]    la_lpc        ; // for main counters
    wire    [63:0]    signal_fmc    ;
    wire              pspill        ; // P0 for resetting counter from FMC
    wire              ev_match      ; // Event matching signal spill-by-spill
    wire              mr_sync_fmc   ; // MR sync
    wire     [1:0]    bh_fmc        ; // Beam Hodoscope
    wire     [1:0]    tc_fmc        ; // Timing Counter
    wire              oldhd_all_fmc ; // Old hodoscope PMT (All OR)
    wire     [7:0]    oldhd_fmc     ; // Old hodoscope PMT
    wire     [1:0]    newhd_fmc     ; // New hodoscope PMT
    
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
//    assign    {oldh_fmc,ev_match_fmc,mr_sync_fmc,pspill_fmc} = ~CHMASK1 & {ha_hpc[16:10], ha_hpc[7:3], ha_hpc[2:0]};
    assign    ev_match = EV_MATCH_IN;
    assign    pspill   = PSPILL_IN;
    assign    {newhd_fmc, oldhd_fmc, oldhd_all_fmc, tc_fmc, bh_fmc, mr_sync_fmc} 
                  = ~CHMASK1[15:0] & {ha_hpc[17:16], ha_hpc[15:10], ha_hpc[7:6], ha_hpc[5], ha_hpc[4:3], ha_hpc[2:1], ha_hpc[0]};
    

    /// Signal-edge detection
    wire             dly_ev_match ;

    reg    [63:0]    regSIG       ;
    reg   [127:0]    sigEdge      ;

    reg              regSync      ;
    reg     [1:0]    syncEdge     ;

    reg     [1:0]    regBH        ;
    reg     [3:0]    bhEdge       ;

    reg     [1:0]    regTC        ;
    reg     [3:0]    tcEdge       ;

    reg              regOLDHALL   ;
    reg     [1:0]    oldhallEdge  ;

    reg     [7:0]    regOLDH      ; // from old hodoscope and other PMTs
    reg    [15:0]    oldhEdge     ; // detect the edge timing

    reg     [1:0]    regNEWH      ;
    reg     [3:0]    newhEdge     ;

    // loop for the MPPC signals
    generate
    for (i = 0; i < 64; i = i+1) begin: SIG_EDGE
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                sigEdge[2*i+1:2*i] <= 2'd0;
                regSIG[i]          <= 1'd0;
            end else begin
                sigEdge[2*i+1:2*i] <= {sigEdge[2*i],signal_fmc[i]};
                regSIG[i]          <= (sigEdge[2*i+1:2*i]==2'b01);
            end
        end
        shift_ram_hit shift_ram_hit_sig(
            .CLK  (SYSCLK         ), // in : clock
            .A    (DLYL_MPPC[7:0] ), // in : address
            .D    (regSIG[i]      ), // in : signal
            .Q    (SIGNAL[i]      )  // out: signal
        );
    end
    endgenerate

    generate
      shift_ram_hit shift_ram_hit_pspill(
          .CLK  (SYSCLK           ), // in : clock
          .A    (DLYL_PSPILL[7:0] ), // in : address
          .D    (pspill           ), // in : signal
          .Q    (PSPILL           )  // out: signal
      );
    endgenerate
    
    generate
      shift_ram_hit shift_ram_hit_evmatch(
          .CLK  (SYSCLK           ), // in : clock
          .A    (DLYL_EVMATCH[7:0]), // in : address
          .D    (ev_match         ), // in : signal
          .Q    (dly_ev_match     )  // out: signal
      );
    endgenerate

    generate
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                syncEdge[1:0] <= 2'd0;
                regSync       <= 1'd0;
            end else begin
                syncEdge[1:0] <= {syncEdge[0],mr_sync_fmc};
                regSync       <= (syncEdge[1:0]==2'b01);
            end
        end
        shift_ram_hit shift_ram_hit_mrsnyc(
            .CLK  (SYSCLK           ), // in : clock
            .A    (DLYL_MRSYNC[7:0] ), // in : address
            .D    (regSync          ), // in : signal
            .Q    (MR_SYNC          )  // out: signal
        );                         
    endgenerate

    generate
    for (i = 0; i < 2; i = i+1) begin: BH_EDGE
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                bhEdge[2*i+1:2*i] <= 2'd0;
                regBH[i]          <= 1'd0;
            end else begin
                bhEdge[2*i+1:2*i] <= {bhEdge[2*i],bh_fmc[i]};
                regBH[i]          <= (seeEdgeBH[i]==1'b1)? (bhEdge[2*i+1:2*i]==2'b01) : bh_fmc[i];
            end
        end
        shift_ram_hit shift_ram_hit_bh(
            .CLK  (SYSCLK            ), // in : clock
            .A    (DLYL_BH[8*i+7:8*i]), // in : address
            .D    (regBH[i]          ), // in : signal
            .Q    (BH[i]             )  // out: signal
        );
    end
    endgenerate

    generate
    for (i = 0; i < 2; i = i+1) begin: TC_EDGE
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                tcEdge[2*i+1:2*i] <= 2'd0;
                regTC[i]          <= 1'd0;
            end else begin
                tcEdge[2*i+1:2*i] <= {tcEdge[2*i],tc_fmc[i]};
                regTC[i]          <= (seeEdgeTC[i]==1'b1)? (tcEdge[2*i+1:2*i]==2'b01) : tc_fmc[i];
            end
        end
        shift_ram_hit shift_ram_hit_tc(
            .CLK  (SYSCLK            ), // in : clock
            .A    (DLYL_TC[8*i+7:8*i]), // in : address
            .D    (regTC[i]          ), // in : signal
            .Q    (TC[i]             )  // out: signal
        );
    end
    endgenerate

    generate
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                oldhallEdge[1:0] <= 2'd0;
                regOLDHALL       <= 1'd0;
            end else begin
                oldhallEdge[1:0] <= {oldhallEdge[0],oldhd_all_fmc};
                regOLDHALL       <= (seeEdgeOldhall==1'b1)? (oldhallEdge[1:0]==2'b01) : oldhd_all_fmc;
            end
        end
        shift_ram_hit shift_ram_hit_oldhd_all(
            .CLK  (SYSCLK              ), // in : clock
            .A    (DLYL_ALLOLD_PMT[7:0]), // in : address
            .D    (regOLDHALL          ), // in : signal
            .Q    (OLDH_ALL            )  // out: signal
        );
    endgenerate

    // loop for the PMT signals
    generate
    for (i = 0; i < 8; i = i+1) begin: OLDH_EDGE
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                oldhEdge[2*i+1:2*i] <= 2'd0;
                regOLDH[i]          <= 1'd0;
            end else begin
                oldhEdge[2*i+1:2*i] <= {oldhEdge[2*i],oldhd_fmc[i]};
                regOLDH[i]          <= (oldhEdge[2*i+1:2*i]==2'b01);
            end
        end
        shift_ram_hit shift_ram_hit_oldh(
            .CLK  (SYSCLK           ), // in : clock
            .A    (DLYL_OLD_PMT[7:0]), // in : address
            .D    (regOLDH[i]       ), // in : signal
            .Q    (OLDH[i]          )  // out: signal
        );
    end
    endgenerate

    // loop for the PMT signals
    generate
    for (i = 0; i < 2; i = i+1) begin: NEWH_EDGE
        always@ (posedge SYSCLK) begin
            if(SYSRST)begin
                newhEdge[2*i+1:2*i] <= 2'd0;
                regNEWH[i]          <= 1'd0;
            end else begin
                newhEdge[2*i+1:2*i] <= {newhEdge[2*i],newhd_fmc[i]};
                regNEWH[i]          <= (newhEdge[2*i+1:2*i]==2'b01);
            end
        end
        shift_ram_hit shift_ram_hit_newh(
            .CLK  (SYSCLK           ), // in : clock
            .A    (DLYL_NEW_PMT[7:0]), // in : address
            .D    (regNEWH[i]       ), // in : signal
            .Q    (NEWH[i]          )  // out: signal
        );
    end
    endgenerate

    reg           regEmSignal;
    reg   [18:0]  regDecVal;
    reg   [16:0]  regEvMatch;
    always@(posedge SYSCLK) begin
        if(SYSRST | ~PSPILL) begin
            regEmSignal     <= 1'b0;
            regDecVal[18:0] <= 19'd0;
        end else if(MR_SYNC && (regDecVal[1:0]!=2'b11)) begin
            regDecVal[18:0] <= {regEmSignal, regDecVal[18:1]};
            regEmSignal     <= 1'b0;
        end else begin
            regEmSignal <= regEmSignal | dly_ev_match;
        end

        if(SYSRST) begin
            regEvMatch[16:0] <= 17'd0;
        end else if(regDecVal[1:0]==2'b11) begin
            regEvMatch[16:0] <= regDecVal[18:2];
        end
    end

    assign EV_MATCH[15:0] = regEvMatch[15:0];

endmodule
