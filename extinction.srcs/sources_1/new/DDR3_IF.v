`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2021 12:01:19 PM
// Design Name: 
// Module Name: DDR3_IF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: ref. https://github.com/thiemchu/dram-arty-a7
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DDR3_IF #(
   //***************************************************************************
   // Traffic Gen related parameters
   //***************************************************************************
   parameter PORT_MODE             = "BI_MODE",
   parameter DATA_MODE             = 4'b0010,
   parameter TST_MEM_INSTR_MODE    = "R_W_INSTR_MODE",
   parameter EYE_TEST              = "FALSE",     // set EYE_TEST = "TRUE" to probe memory
                                                  // signals. Traffic Generator will only
                                                  // write to one single location and no
                                                  // read transactions will be generated.
   parameter DATA_PATTERN          = "DGEN_ALL",  // For small devices, choose one only.
                                                  // For large device, choose "DGEN_ALL"
                                                  // "DGEN_HAMMER", "DGEN_WALKING1",
                                                  // "DGEN_WALKING0","DGEN_ADDR","
                                                  // "DGEN_NEIGHBOR","DGEN_PRBS","DGEN_ALL"
   parameter CMD_PATTERN           = "CGEN_ALL",  // "CGEN_PRBS","CGEN_FIXED","CGEN_BRAM",
                                                  // "CGEN_SEQUENTIAL", "CGEN_ALL"
   parameter CMD_WDT               = 'h3FF,
   parameter WR_WDT                = 'h1FFF,
   parameter RD_WDT                = 'h3FF,
   parameter SEL_VICTIM_LINE       = 0,
   parameter BEGIN_ADDRESS         = 32'h00000000,
   parameter END_ADDRESS           = 32'h00ffffff,
   parameter PRBS_EADDR_MASK_POS   = 32'hff000000,

   //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter CK_WIDTH              = 1,     // # of CK/CK# outputs to memory.
   parameter nCS_PER_RANK          = 1,     // # of unique CS outputs per rank for phy
   parameter CKE_WIDTH             = 1,     // # of CKE outputs to memory.
   parameter DM_WIDTH              = 8,     // # of DM (data mask)
   parameter ODT_WIDTH             = 1,     // # of ODT outputs to memory.
   parameter BANK_WIDTH            = 3,     // # of memory Bank Address bits.
   parameter COL_WIDTH             = 10,    // # of memory Column Address bits.
   parameter CS_WIDTH              = 1,     // # of unique CS outputs to memory.
   parameter DQ_WIDTH              = 64,    // # of DQ (data)
   parameter DQS_WIDTH             = 8,
   parameter DQS_CNT_WIDTH         = 3,     // = ceil(log2(DQS_WIDTH))
   parameter DRAM_WIDTH            = 8,     // # of DQ per DQS
   parameter ECC                   = "OFF",
   parameter ECC_TEST              = "OFF",
   //parameter nBANK_MACHS           = 4,
   parameter nBANK_MACHS           = 4,
   parameter RANKS                 = 1,     // # of Ranks.
   parameter ROW_WIDTH             = 14,    // # of memory Row Address bits.
   parameter ADDR_WIDTH            = 28,    // # = RANK_WIDTH + BANK_WIDTH
                                            //     + ROW_WIDTH + COL_WIDTH;
                                            // Chip Select is always tied to low for
                                            // single rank devices

   //***************************************************************************
   // The following parameters are mode register settings
   //***************************************************************************
   parameter BURST_MODE            = "8",   // DDR3 SDRAM:
                                            // Burst Length (Mode Register 0).
                                            // # = "8", "4", "OTF".
                                            // DDR2 SDRAM:
                                            // Burst Length (Mode Register).
                                            // # = "8", "4".

   
   //***************************************************************************
   // The following parameters are multiplier and divisor factors for PLLE2.
   // Based on the selected design frequency these parameters vary.
   //***************************************************************************
   parameter CLKIN_PERIOD          = 5000,  // Input Clock Period
   parameter CLKFBOUT_MULT         = 8,     // write PLL VCO multiplier
   parameter DIVCLK_DIVIDE         = 1,     // write PLL VCO divisor
   parameter CLKOUT0_PHASE         = 337.5, // Phase for PLL output clock (CLKOUT0)
   parameter CLKOUT0_DIVIDE        = 2,     // VCO output divisor for PLL output clock (CLKOUT0)
   parameter CLKOUT1_DIVIDE        = 2,     // VCO output divisor for PLL output clock (CLKOUT1)
   parameter CLKOUT2_DIVIDE        = 32,    // VCO output divisor for PLL output clock (CLKOUT2)
   parameter CLKOUT3_DIVIDE        = 8,     // VCO output divisor for PLL output clock (CLKOUT3)
   parameter MMCM_VCO              = 800,   // Max Freq (MHz) of MMCM VCO
   parameter MMCM_MULT_F           = 4,     // write MMCM VCO multiplier
   parameter MMCM_DIVCLK_DIVIDE    = 1,     // write MMCM VCO divisor

   //***************************************************************************
   // Simulation parameters
   //***************************************************************************
   parameter SIMULATION            = "FALSE", // Should be TRUE during design simulations and
                                              // FALSE during implementations
   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************
   parameter TCQ                   = 100,
   parameter DRAM_TYPE             = "DDR3",
   
   //***************************************************************************
   // System clock frequency parameters
   //***************************************************************************
   parameter nCK_PER_CLK           = 4,       // # of memory CKs per fabric CLK

   //***************************************************************************
   // Debug parameters
   //***************************************************************************
   parameter DEBUG_PORT            = "OFF",   // # = "ON" Enable debug signals/controls.
                                              //   = "OFF" Disable debug signals/controls.
   parameter RST_ACT_LOW           = 0        // =1 for active low reset,
                                              // =0 for active high.
   )(

        // System
        input   wire              CLK_200MP         ,
        input   wire              CLK_200MN         ,
        input   wire              SYSRST            ,
        
        output  wire              USER_CLK          ,
        output  wire              USER_RST          ,

        // Connected wires w/ DDR3
        inout   wire    [63:0]    DDR3_DQ           ,
        inout   wire     [7:0]    DDR3_DQS_N        ,
        inout   wire     [7:0]    DDR3_DQS_P        ,
        output  wire    [13:0]    DDR3_ADDR         ,
        output  wire     [2:0]    DDR3_BA           ,
        output  wire              DDR3_RAS_N        ,
        output  wire              DDR3_CAS_N        ,
        output  wire              DDR3_WE_N         ,
        output  wire              DDR3_RESET_N      ,
        output  wire              DDR3_CK_P         ,
        output  wire              DDR3_CK_N         ,
        output  wire              DDR3_CKE          ,
        output  wire              DDR3_CS_N         ,
        output  wire     [7:0]    DDR3_DM           ,
        output  wire              DDR3_ODT          ,

        output  wire    [27:0]    app_addr2         ,
        output  wire     [2:0]    app_cmd2          ,
        output  wire              app_en2           ,
        output  wire              app_rdy2          ,
        
        output  wire    [31:0]    app_wdf_data2     ,
        output  wire              app_wdf_end2      ,
        output  wire              app_wdf_wren2     ,
        output  wire              app_wdf_rdy2      ,

        output  wire    [31:0]    app_rd_data2      ,
        output  wire              app_rd_data_end2  ,
        output  wire              app_rd_data_valid2,

        output  wire              init_calib_complete,

        input   wire              DATA_FIFO_EMPTY   ,
        input   wire              DATA_FIFO_READY   ,
        output  wire              DATA_FIFO_RD      ,
        //input   wire   [511:0]    WR_DATA           ,
        input   wire   [111:0]    WR_DATA           ,
        input   wire              WR_DATA_VAL       ,
        input   wire              SITCP_FIFO_FULL   ,
        input   wire              TCP_OPEN_ACK      ,
        output  wire              OUTVAL            ,
        output  wire     [7:0]    OUT               ,

        // debug
        output  wire              debug_ren         ,
        output  wire              debug_wen         ,
        output  wire    [27:0]    debug_addr        ,
        output  wire    [31:0]    debug_wdata       ,
        output  wire    [31:0]    debug_rdata       ,
        output  wire              debug_rdata_valid ,
        output  wire              debug_ready       ,
        output  wire              debug_wdf_ready   ,
        output  wire              debug_wdone       ,
        output  wire              debug_writting    ,
        output  wire              debug_dram_rdata  ,
        output  wire              debug_reg_data    ,
        output  wire     [2:0]    debug_reg_dat     ,
        output  wire     [7:0]    debug_rva_cnt     ,
        output  wire     [7:0]    debug_ren_cnt 
    );

    wire     [27:0]   app_addr;
    wire      [2:0]   app_cmd;
    wire              app_en;
    wire    [511:0]   app_wdf_data;
    wire              app_wdf_wren;
    wire    [511:0]   app_rd_data;
    wire              app_rd_data_end;
    wire              app_rd_data_valid;
    wire              app_rdy;
    wire              app_wdf_rdy;
    //wire              init_calib_complete;
    
    reg       [27:0]  dly_app_addr;
    reg       [2:0]   dly_app_cmd;
    reg               dly_app_en;
    reg      [31:0]   dly_app_wdf_data;
    reg               dly_app_wdf_end;
    reg               dly_app_wdf_wren;
    reg      [31:0]   dly_app_rd_data;
    reg               dly_app_rd_data_end;
    reg               dly_app_rd_data_valid;
    reg               dly_app_rdy;
    reg               dly_app_wdf_rdy;
    always@(posedge USER_CLK) begin
        //dly_app_addr          <= app_addr          ;
        //dly_app_cmd           <= app_cmd           ;
        //dly_app_en            <= app_en            ;
        //dly_app_wdf_data      <= app_wdf_data[31:0];
        //dly_app_wdf_end       <= 1'b0       ;
        //dly_app_wdf_wren      <= app_wdf_wren      ;
        //dly_app_rd_data       <= app_rd_data[31:0] ;
        //dly_app_rd_data_end   <= app_rd_data_end   ;
        //dly_app_rd_data_valid <= app_rd_data_valid ;
        //dly_app_rdy           <= app_rdy           ;
        //dly_app_wdf_rdy       <= app_wdf_rdy       ;       
        dly_app_addr          <= 0;
        dly_app_cmd           <= 0;
        dly_app_en            <= 0;
        dly_app_wdf_data      <= 0;
        dly_app_wdf_end       <= 0;
        dly_app_wdf_wren      <= 0;
        dly_app_rd_data       <= 0;
        dly_app_rd_data_end   <= 0;
        dly_app_rd_data_valid <= 0;
        dly_app_rdy           <= 0;
        dly_app_wdf_rdy       <= 0;       
    end
    assign app_addr2          = dly_app_addr;
    assign app_cmd2           = dly_app_cmd;
    assign app_en2            = dly_app_en;
    assign app_wdf_data2      = dly_app_wdf_data;
    assign app_wdf_end2       = dly_app_wdf_end;
    assign app_wdf_wren2      = dly_app_wdf_wren;
    assign app_rd_data2       = dly_app_rd_data;
    assign app_rd_data_end2   = dly_app_rd_data_end;
    assign app_rd_data_valid2 = dly_app_rd_data_valid;
    assign app_rdy2           = dly_app_rdy;
    assign app_wdf_rdy2       = dly_app_wdf_rdy;

    wire              sysrst = USER_RST | ~TCP_OPEN_ACK;

    wire              dram_ren;
    wire              dram_wen;
    wire     [23:0]   dram_addr;
    wire    [511:0]   dram_wdata;
    wire    [511:0]   dram_rdata;
    wire              dram_rdata_valid;
    wire              dram_ready;
    wire              dram_wdf_ready;
    wire              dram_wdone;

    wire              fifo_ren;
    reg               writting;
    wire              dram_full;
    wire              dram_empty;
    reg      [7:0]    cnt;
    wire              fifo_try_read;

    assign fifo_try_read = DATA_FIFO_READY | (cnt[7:0]==8'd199);
    assign DATA_FIFO_RD = fifo_ren & dram_ready & ~dram_full & fifo_try_read;
    assign fifo_ren =  DATA_FIFO_EMPTY | writting ? 1'b0 :
                      ~DATA_FIFO_EMPTY            ? 1'b1 : 1'b0;

    always@(posedge USER_CLK) begin
        if(sysrst | fifo_try_read) begin
            cnt[7:0] <= 8'd0;
        end else if(~DATA_FIFO_EMPTY) begin
            cnt[7:0] <= cnt[7:0] + 8'd1;
        end
    end

    reg           dly_dram_ren;
    reg           dly_dram_wen;
    reg   [23:0]  dly_dram_addr;
    reg   [31:0]  dly_dram_wdata;
    reg   [31:0]  dly_dram_rdata;
    reg           dly_dram_rdata_valid;
    reg           dly_dram_ready;
    reg           dly_dram_wdf_ready;
    reg           dly_dram_wdone;
    reg           dly_writting;

    always@(posedge USER_CLK) begin
        dly_dram_ren         <= dram_ren        ;
        dly_dram_wen         <= dram_wen        ;
        dly_dram_addr        <= dram_addr[23:0] ;
        dly_dram_wdata       <= dram_wdata[31:0];
        dly_dram_rdata       <= dram_rdata[31:0];
        dly_dram_rdata_valid <= dram_rdata_valid;
        dly_dram_ready       <= dram_ready      ;
        dly_dram_wdf_ready   <= dram_wdf_ready  ;
        dly_dram_wdone       <= dram_wdone      ;
        dly_writting         <= writting        ;
    end
    
    assign debug_ren         = dly_dram_ren;
    assign debug_wen         = dly_dram_wen;
    assign debug_addr        = {4'd0,dly_dram_addr};
    assign debug_wdata       = dly_dram_wdata;
    assign debug_rdata       = dly_dram_rdata;
    assign debug_rdata_valid = dly_dram_rdata_valid;
    assign debug_ready       = dly_dram_ready;
    assign debug_wdf_ready   = dly_dram_wdf_ready;
    assign debug_wdone       = dly_dram_wdone;
    assign debug_writting    = dly_writting;


    reg     [111:0]   reg_data;
    //reg     [511:0]   reg_data;
    reg      [24:0]   fifo_ndata;
    reg      [24:0]   waddr;
    reg      [24:0]   raddr;
    reg     [511:0]   wdata;
    reg               rd_data_en;
    reg               reading;

    assign  dram_empty = (waddr[24:0] == raddr[24:0]);
    assign  dram_full  = (waddr[24] != raddr[24]) && (waddr[23:0] == raddr[23:0]);

    always @(posedge USER_CLK) begin
        if(sysrst | ~init_calib_complete) begin
            fifo_ndata[24:0] <= 25'd0;
            waddr[24:0]      <= 25'd0;
            raddr[24:0]      <= 25'd0;
            wdata[511:0]     <= 512'd0;
            writting         <= 1'b0;
            reading          <= 1'b0;
        end else begin
            if(WR_DATA_VAL) begin
                fifo_ndata[24:0] <= fifo_ndata[24:0] + 25'd1;
            end

            //if(dram_wen) begin
            if(dram_wdone & ~(waddr[24:0]==fifo_ndata[24:0])) begin
                waddr[24:0]  <= waddr[24:0] + 25'd1;
            end else if(~dram_wdone & app_wdf_wren) begin
                waddr[24:0]  <= waddr[24:0] - 25'd1;
            end
            
            //if(dram_rdata_valid & (reg_data[111:104] != dram_rdata[111:104])) begin
            if(dram_rdata_valid) begin
                raddr[24:0]  <= raddr[24:0] + 25'd1;
            end

            if(WR_DATA_VAL) begin
                wdata[511:0] <= {399'd0, WR_DATA[111:25], SITCP_FIFO_FULL, waddr[23:0]};
            end

            if(WR_DATA_VAL) begin
                writting <= 1'b1;
            end else if(dram_wdone) begin
                writting <= 1'b0;
            end

            if(dram_ren) begin
                reading <= 1'b1;
            end else if(dram_rdata_valid) begin
                reading <= 1'b0;
            end

        end
    end

    reg   [7:0]   ren_cnt;
    reg   [7:0]   rva_cnt;
    always@(posedge USER_CLK) begin
        if(sysrst | dram_ren) begin
            ren_cnt[7:0] <= 8'd0;
        end else if(ren_cnt[7]) begin
            ren_cnt[7:0] <= ren_cnt[7:0];
        end else begin
            ren_cnt[7:0] <= ren_cnt[7:0] + 8'd1;
        end
        
        if(sysrst | app_rd_data_valid) begin
            rva_cnt[7:0] <= 8'd0;
        end else if(rva_cnt[7]) begin
            rva_cnt[7:0] <= rva_cnt[7:0];
        end else begin
            rva_cnt[7:0] <= rva_cnt[7:0] + 8'd1;
        end
    end
    assign debug_ren_cnt = ren_cnt;
    assign debug_rva_cnt = rva_cnt;

    assign  dram_wen =  writting & dram_ready & dram_wdf_ready; // need to add ddr3 full flag
    assign  dram_ren = ~writting & dram_ready & ~rd_data_en & ~SITCP_FIFO_FULL & TCP_OPEN_ACK & ~dram_empty & ~reading; // need to add ddr3 empty flag
    assign  dram_wdata[511:0] = wdata[511:0];

    assign  dram_addr[23:0] = dram_wen ? waddr[23:0] :
                              dram_ren ? raddr[23:0] : 24'hFF_FFFF;

    //  user interface for accessing  MIG
    MIG_UI mig_ui (
        .sysclk                 (USER_CLK             ),
        .sysrst                 (sysrst               ),
        // signals from/to user design side
        .i_rd_en                (dram_ren             ),
        .i_wr_en                (dram_wen             ),
        .i_addr                 (dram_addr[23:0]      ),
        .i_data                 (dram_wdata           ),
        //.i_mask                 (64'd0                ),
        .o_data                 (dram_rdata[511:0]    ),
        .o_data_valid           (dram_rdata_valid     ),
        .o_ready                (dram_ready           ),
        .o_wdf_ready            (dram_wdf_ready       ),
        .o_wdf_done             (dram_wdone           ),
        // signals to/from MIG
        .app_addr               (app_addr[27:0]       ), // out:
        .app_cmd                (app_cmd[2:0]         ), // out:
        .app_en                 (app_en               ), // out:
        .app_wdf_data           (app_wdf_data[511:0]  ), // out:
        .app_wdf_wren           (app_wdf_wren         ), // out:
        //.app_wdf_mask           (app_wdf_mask[63:0]   ), // out:
        .app_rdy                (app_rdy              ), // in :
        .app_wdf_rdy            (app_wdf_rdy          ), // in :
        .app_rd_data            (app_rd_data[511:0]   ), // in :
        .app_rd_data_valid      (app_rd_data_valid    ), // in :
        .init_calib_complete    (init_calib_complete  )  // in :
    );
    
    mig_kc705_ddr3 u_mig_kc705_ddr3 (
        // Connected wires w/ DDR3
        .ddr3_dq              (DDR3_DQ[63:0]       ), // io :
        .ddr3_dqs_n           (DDR3_DQS_N[7:0]     ), // io :
        .ddr3_dqs_p           (DDR3_DQS_P[7:0]     ), // io :
        .ddr3_addr            (DDR3_ADDR[13:0]     ), // out:
        .ddr3_ba              (DDR3_BA[2:0]        ), // out:
        .ddr3_ras_n           (DDR3_RAS_N          ), // out:
        .ddr3_cas_n           (DDR3_CAS_N          ), // out:
        .ddr3_we_n            (DDR3_WE_N           ), // out:
        .ddr3_reset_n         (DDR3_RESET_N        ), // out:
        .ddr3_ck_p            (DDR3_CK_P           ), // out:
        .ddr3_ck_n            (DDR3_CK_N           ), // out:
        .ddr3_cke             (DDR3_CKE            ), // out:
        .ddr3_cs_n            (DDR3_CS_N           ), // out:
        .ddr3_dm              (DDR3_DM[7:0]        ), // out:
        .ddr3_odt             (DDR3_ODT            ), // out:
        // System
        .sys_clk_p            (CLK_200MP           ), // in : clock from oscillator
        .sys_clk_n            (CLK_200MN           ), // in : clock from oscilaltor
        .sys_rst              (SYSRST              ), // in : system reset
        // User interface signals
        .app_addr             (app_addr[27:0]      ), // in : W/R address
        .app_cmd              (app_cmd[2:0]        ), // in : command (W/ or R mode)
        .app_en               (app_en              ), // in : app. enable
        .app_rdy              (app_rdy             ), // out: app. ready

        .app_wdf_data         (app_wdf_data[511:0] ), // in : write data
        .app_wdf_end          (app_wdf_wren        ), // in : write data end
        .app_wdf_mask         (64'd0               ), // in : write data mask
        .app_wdf_wren         (app_wdf_wren        ), // in : write data enable
        .app_wdf_rdy          (app_wdf_rdy         ), // out: app. write ready

        .app_rd_data          (app_rd_data[511:0]  ), // out: read data
        .app_rd_data_end      (app_rd_data_end     ), // out: read data end
        .app_rd_data_valid    (app_rd_data_valid   ), // out: read data valid

        .app_sr_req           (1'b0                ), // in : (unused)
        .app_ref_req          (1'b0                ), // in : (unused)
        .app_zq_req           (1'b0                ), // in : (unused)
        .app_sr_active        (                    ), // out: (unused)
        .app_ref_ack          (                    ), // out: (unused)
        .app_zq_ack           (                    ), // out: (unused)
        .ui_clk               (USER_CLK            ), // out: user clock (200MHz)
        .ui_clk_sync_rst      (USER_RST            ), // out: user reset signal
        .init_calib_complete  (init_calib_complete ), // out: inital-process complete signal
        .device_temp          (                    )  // out: device temperature
    );



    /// Reader 
    reg             dly_rd_data_en;
    //reg     [7:0]   dly_rd_data;
    reg     [3:0]   count;
    always@(posedge USER_CLK) begin
        if(sysrst) begin
            rd_data_en <= 1'b0;
        end else if(count[3:0]==4'd0) begin
            rd_data_en <= 1'b0;
        end else if(dram_rdata_valid) begin
        //end else if(dram_rdata_valid & (dram_rdata[111:104] != dly_rd_data[7:0])) begin
            rd_data_en <= 1'b1;
        end

        dly_rd_data_en <= rd_data_en;
        //if(sysrst) begin
        //    dly_rd_data[7:0] <= 8'd0;
        //end else if(dram_rdata_valid) begin
        //    dly_rd_data[7:0] <= dram_rdata[111:104];
        //end
    end         

    always@(posedge USER_CLK) begin
        if(sysrst) begin
            count[3:0] <= 4'd12;
        end else if(~rd_data_en | (count[3:0]==4'd0)) begin
            count[3:0] <= 4'd12;
        end else if(rd_data_en) begin
            count[3:0] <= count[3:0] - 4'd1;
        end
    end

    always@(posedge USER_CLK) begin
        if(sysrst) begin
            reg_data[111:0] <= 112'd0;
            //reg_data[511:0] <= 512'd0;
        end else if(dram_rdata_valid & ~rd_data_en) begin
            reg_data[111:0] <= dram_rdata[111:0];
            //reg_data[511:0] <= dram_rdata[511:0];
        end
    end

    assign debug_dram_rdata = dram_rdata[104];
    assign debug_reg_data   = reg_data[104];
    assign debug_reg_dat[2:0] = reg_data[29:27];

    reg     [7:0]   data_out;
    always@(posedge USER_CLK) begin
        case(count[3:0])
            4'd12:   data_out[7:0] <= reg_data[103: 96];
            4'd11:   data_out[7:0] <= reg_data[ 95: 88];
            4'd10:   data_out[7:0] <= reg_data[ 87: 80];
            4'd9:    data_out[7:0] <= reg_data[ 79: 72];
            4'd8:    data_out[7:0] <= reg_data[ 71: 64];
            4'd7:    data_out[7:0] <= reg_data[ 63: 56];
            4'd6:    data_out[7:0] <= reg_data[ 55: 48];
            4'd5:    data_out[7:0] <= reg_data[ 47: 40];
            4'd4:    data_out[7:0] <= reg_data[ 39: 32];
            4'd3:    data_out[7:0] <= reg_data[ 31: 24];
            4'd2:    data_out[7:0] <= reg_data[ 23: 16];
            4'd1:    data_out[7:0] <= reg_data[ 15:  8];
            4'd0:    data_out[7:0] <= reg_data[  7:  0];
            default: data_out[7:0] <= 8'hFF;
        endcase
    end

    assign OUTVAL   = dly_rd_data_en;
    assign OUT[7:0] = OUTVAL ? data_out[7:0] : 8'hCC;

endmodule


module MIG_UI (
        input   wire              sysclk             ,
        input   wire              sysrst             ,
        // signals from/to user design side
        input   wire              i_rd_en            ,
        input   wire              i_wr_en            ,
        input   wire     [23:0]   i_addr             ,
        input   wire    [511:0]   i_data             ,
        //input   wire     [63:0]   i_mask             ,
        output  wire    [511:0]   o_data             ,
        output  wire              o_data_valid       ,
        output  wire              o_ready            ,
        output  wire              o_wdf_ready        ,
        output  wire              o_wdf_done         ,
        // signals to/from MIG
        output  wire     [27:0]   app_addr           ,
        output  wire      [2:0]   app_cmd            ,
        output  wire              app_en             ,
        output  wire    [511:0]   app_wdf_data       ,
        output  wire              app_wdf_wren       ,
        //output  wire     [63:0]   app_wdf_mask       ,
        input   wire              app_rdy            ,
        input   wire              app_wdf_rdy        ,
        input   wire    [511:0]   app_rd_data        ,
        input   wire              app_rd_data_valid  ,
        input   wire              init_calib_complete
    );

    localparam STATE_CALIB           = 3'b000;
    localparam STATE_IDLE            = 3'b001;
    localparam STATE_ISSUE_CMD_WDATA = 3'b010;
    localparam STATE_ISSUE_CMD       = 3'b011;
    localparam STATE_ISSUE_WDATA     = 3'b100;

    localparam CMD_READ  = 3'b001;
    localparam CMD_WRITE = 3'b000;

    reg      [23:0]     addr;
    reg       [2:0]     cmd;
    reg                 en;
    reg     [511:0]     wdf_data;
    reg                 wdf_wren;
    //reg      [63:0]     wdf_mask;

    reg       [2:0]     state;

    assign o_data       = app_rd_data;
    assign o_data_valid = app_rd_data_valid;
    assign o_ready      = app_rdy & init_calib_complete;
    assign o_wdf_ready  = app_wdf_rdy;
    assign o_wdf_done   = app_rdy & app_wdf_rdy & (cmd[2:0]==CMD_WRITE) & en & wdf_wren;

    assign app_addr[27:0]      = {1'b0, addr[23:0], 3'b000};
    assign app_cmd[2:0]        = cmd[2:0];
    assign app_en              = en;
    assign app_wdf_data[511:0] = wdf_data[511:0];
    assign app_wdf_wren        = wdf_wren;
    //assign app_wdf_mask[63:0]  = wdf_mask[63:0];

    always @(posedge sysclk) begin
        if(sysrst) begin
            state           <= STATE_CALIB;
            cmd[2:0]        <= 3'd0;
            addr[23:0]      <= 24'd0;
            en              <= 1'd0;
            wdf_data[511:0] <= 512'd0;
            wdf_wren        <= 1'd0;
            //wdf_mask[63:0]  <= 64'd0;
         end else begin
            case (state)

                STATE_CALIB: begin              // waite for finishing inital calibration
                    if(init_calib_complete) begin
                        state <= STATE_IDLE;
                    end
                end

                STATE_IDLE: begin
                    if(i_wr_en) begin           // let's move to write phase
                        cmd[2:0]        <= CMD_WRITE;
                        addr[23:0]      <= i_addr[23:0];
                        en              <= 1'b1;
                        wdf_data[511:0] <= i_data[511:0];
                        wdf_wren        <= 1'b1;
                        //wdf_mask[63:0]  <= i_mask[63:0];
                        state[2:0]      <= STATE_ISSUE_CMD_WDATA;

                    end else if(i_rd_en) begin  // let's move to read phase
                        cmd[2:0]        <= CMD_READ;
                        addr[23:0]      <= i_addr[23:0];
                        en              <= 1'b1;
                        wdf_wren        <= 1'b0;
                        state[2:0]      <= STATE_ISSUE_CMD;
                    end
                end

                STATE_ISSUE_CMD_WDATA: begin
                    if(app_rdy && app_wdf_rdy) begin
                        if(i_wr_en) begin           // wrote 
                            cmd[2:0]        <= CMD_WRITE;
                            addr[23:0]      <= i_addr[23:0];
                            en              <= 1'b1;
                            wdf_data[511:0] <= i_data[511:0];
                            wdf_wren        <= 1'b1;
                            //wdf_mask[63:0]  <= i_mask[63:0];
                            state[2:0]      <= STATE_ISSUE_CMD_WDATA;

                        end else if(i_rd_en) begin  // reading
                            cmd[2:0]        <= CMD_READ;
                            addr[23:0]      <= i_addr[23:0];
                            en              <= 1'b1;
                            wdf_wren        <= 1'b0;
                            state[2:0]      <= STATE_ISSUE_CMD;

                        end else begin              // move to idle phase
                            en              <= 1'b1;
                            wdf_wren        <= 1'b0;
                            state[2:0]      <= STATE_IDLE;
                        end

                    end else if(app_rdy) begin      //
                        en          <= 1'b0;
                        state[2:0]  <= STATE_ISSUE_WDATA;

                    end else if(app_wdf_rdy) begin  // wait for app_rdy=1'b1
                        wdf_wren    <= 1'b0;
                        state[2:0]  <= STATE_ISSUE_CMD;
                    end
                end

                STATE_ISSUE_CMD: begin    // wdf_wren = 1'b0
                    if(app_rdy) begin
                        if(i_wr_en) begin           // let's move to write phase
                            cmd[2:0]        <= CMD_WRITE;
                            addr[23:0]      <= i_addr[23:0];
                            en              <= 1'b1;
                            wdf_data[511:0] <= i_data[511:0];
                            wdf_wren        <= 1'b1;
                            //wdf_mask[63:0]  <= i_mask[63:0];
                            state[2:0]      <= STATE_ISSUE_CMD_WDATA;

                        end else if(i_rd_en) begin  // wait for read data
                            cmd[2:0]        <= CMD_READ;
                            addr[23:0]      <= i_addr[23:0];
                            en              <= 1'b1;
                            wdf_wren        <= 1'b0;
                            state[2:0]      <= STATE_ISSUE_CMD;

                        end else begin              // wait for available command
                            en              <= 1'b0;
                            wdf_wren        <= 1'b0;
                            state[2:0]      <= STATE_IDLE;
                        end
                    end
                end

                STATE_ISSUE_WDATA: begin
                    if(app_wdf_rdy) begin
                        if(i_wr_en) begin           // write
                            cmd[2:0]        <= CMD_WRITE;
                            addr[23:0]      <= i_addr[23:0];
                            en              <= 1'b1;
                            wdf_data[511:0] <= i_data[511:0];
                            wdf_wren        <= 1'b1;
                            //wdf_mask[63:0]  <= i_mask[63:0];
                            state[2:0]      <= STATE_ISSUE_CMD_WDATA;

                        end else if(i_rd_en) begin  // wait for read data
                            cmd[2:0]        <= CMD_READ;
                            addr[23:0]      <= i_addr[23:0];
                            en              <= 1'b1;
                            wdf_wren        <= 1'b0;
                            state[2:0]      <= STATE_ISSUE_CMD;

                        end else begin              // wait for available command
                            wdf_wren        <= 1'b0;
                            state[2:0]      <= STATE_IDLE;
                        end
                    end
                end

                default: begin
                    en         <= 1'b0;
                    wdf_wren   <= 1'b0;
                    state[2:0] <= STATE_IDLE;
                end
            endcase
        end
    end

endmodule

