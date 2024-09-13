`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2024 18:43:09
// Design Name: 
// Module Name: APB_slave
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


module APB_slave #( parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32)(
    //OUTPUTS
    output  reg [DATA_WIDTH-1:0] PRDATA,
    output                       PREADY_o,
    
    //INPUTS
    input                    PREADY,
    input   [DATA_WIDTH-1:0] PWRDATA, 
    input   [ADDR_WIDTH-1:0] PADDR,
    input                    PCLK,
    input                    PRESETn,
    input                    PWRITE,
    input                    PENABLE,
    input                    PSEL
    );
    

    
    parameter  IDLE   = 2'd0, SETUP = 2'd1, ACCESS =2'd2;
   
   //MEMORY DEFINTION
    reg [DATA_WIDTH-1:0]    APB_MEM [ADDR_WIDTH-1:0];
    
    //STATE VARIABLES
    reg [1:0] prsnt_state , next_state ;
    
    
    // STATE REG ASSIGNMENT
    always@(posedge PCLK , negedge PRESETn) begin   
        if(!PRESETn)
            prsnt_state <= IDLE ;
        else 
            prsnt_state <= next_state ;
    end
   
   
   // NEXT STATE ASSIGNMENT
   always@(* ) begin
        next_state <= prsnt_state;
        case (prsnt_state)
            //IDLE STATE DEFINITION    
            IDLE : begin
                if(PSEL )
                    next_state <= SETUP;        
                else 
                    next_state <= IDLE;
            end
            
            // SETUP STATE DEFINITION
            SETUP : begin
                if(PENABLE)
                    next_state <= ACCESS;
                else 
                    next_state <= IDLE;
            end
            
            // ACCESS STATE DEFINITION
            ACCESS : begin
                if(PREADY) begin
                    if(!PSEL) 
                        next_state <= IDLE ;
                    else
                        next_state <= SETUP ;
                end
                else 
                    next_state <= ACCESS;
            end
            
            //default definition 
            default : next_state <= IDLE;
        endcase
   end
   
   // READ/WRITE logic 
   always@(*) begin
         if(!PRESETn)
            PRDATA <= 32'd0;
         else begin
            if((next_state == ACCESS) && !PWRITE)
                PRDATA <= APB_MEM[PADDR];
            else if((next_state == ACCESS) && PWRITE)
                APB_MEM[PADDR] <= PWRDATA ;
            else 
                PRDATA <= 32'd0;    
         end
   end
   
   //PREADY ASSIGNMENT
   assign PREADY_o = PREADY ;
    
endmodule
