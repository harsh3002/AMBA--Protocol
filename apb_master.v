`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2024 16:20:19
// Design Name: 
// Module Name: apb_master
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


module apb_master #(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 32) (
		//OUTPUTS
		output 					PSEL,
		output 					PENABLE,
		output  [ADDR_WIDTH-1:0] PADDR,
		output  [DATA_WIDTH-1:0]	PWRDATA,
		output  					PWRITE,
		output  [DATA_WIDTH-1:0]	PRDATA_o,
		
		//INPUTS
		input  [DATA_WIDTH-1:0]	PRDATA,
		input  [DATA_WIDTH-1:0] data_i,
		input  [ADDR_WIDTH-1:0]	addr_i,
		input 					PCLK,
		input 					PRESETn,
		input 					PREADY,
		input 					evnt_trig_i,
		input 					pwrite_i
);

parameter IDLE = 2'd0;
parameter SETUP = 2'd1;
parameter ACCESS = 2'd2;

reg [1:0]	state, next_state;

always@(posedge PCLK) begin
	if(!PRESETn)
		state <= IDLE ;
	else
		state <= next_state ;
end


//STATE MACHINE DEFINITION
always@(*) begin


	case(state)
		IDLE : begin
			if (evnt_trig_i)
				next_state <= SETUP ;
			else 
				next_state <= IDLE;
		end
		
		SETUP : next_state <= ACCESS;
		
		ACCESS : begin
			if(PREADY)
				next_state <= IDLE ;
			else 
				next_state <= ACCESS ;
		end
		
		default : next_state <= IDLE ;
	endcase
end



//OUTPUTS ASSIGNMENT 
assign PSEL = PRESETn ? (state != IDLE) : 1'b0;
assign PENABLE = (state == ACCESS) ;
assign PWRITE = pwrite_i;
assign PWRDATA = data_i;
assign PADDR = addr_i;
assign PRDATA_o = PRDATA;

endmodule
