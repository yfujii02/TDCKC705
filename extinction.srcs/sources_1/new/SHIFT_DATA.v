module SHIFT_DATA(
    RST,
    CLK,
    EN,
    SHIFT,
    CNTRIN,
    CNTROUT
);
    //parameter  NLEN = 1088;
    parameter  NLEN = 688;

    input                   RST     ;
    input                   CLK     ;
    input                   EN      ;
    input                   SHIFT   ;
    input    [NLEN*24-1:0]  CNTRIN  ;
    output          [23:0]  CNTROUT ;

    wire            [23:0]  CNTROUT ;

    reg      [NLEN*24-1:0]  regCNTR ;

    assign CNTROUT = regCNTR[1119:1096];

    always@ (posedge CLK) begin
        if(RST) begin
            //regCNTR <= 26112'd0;  // 200MHz
            regCNTR <= 16512'd0;  // 125MHz
        end else begin
            if(EN) begin
                regCNTR <= CNTRIN; 
            end else if(SHIFT) begin
                regCNTR <= (regCNTR << 24);
            end else begin
                regCNTR <= regCNTR;
            end
        end
    end
endmodule
