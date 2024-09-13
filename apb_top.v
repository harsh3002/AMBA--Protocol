`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2024 16:51:43
// Design Name: 
// Module Name: apb_top
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


module apb_top #(parameter DATA_WIDTH = 32 , parameter ADDR_WIDTH = 32) (
		//OUTPUTS
		output [DATA_WIDTH-1:0]	PRDATA_o,
		
		//INPUTS
		input 					PCLK_i,
		input 					PRESETn_i,
		input [DATA_WIDTH-1:0]	PWRDATA_i,
		input [ADDR_WIDTH-1:0]	PADDR_i,
		input 					PWRITE_i,
		input 					PREADY_i,
		input 					EVENT_i
);

	//INTERCONNECT WIRE DECLARATION
	wire [DATA_WIDTH-1:0]	p_rd_intr, pwrdata_intr, paddr_intr;
	wire 					p_ready_intr, psel_intr, pena_intr, pwrite_intr;				
	
	
	//APB_MASTER INTEGRATION
	apb_master  #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH))  master_inst(
		//inputs
		.PCLK(PCLK_i),
		.PRESETn(PRESETn_i),
		.evnt_trig_i(EVENT_i),
		.data_i(PWRDATA_i),
		.addr_i(PADDR_i),
		.pwrite_i(PWRITE_i),
		.PRDATA(p_rd_intr),
		.PREADY(p_ready_intr),
		
		//outputs
		.PSEL(psel_intr),
		.PENABLE(pena_intr),
		.PADDR(paddr_intr),
		.PWRDATA(pwrdata_intr),
		.PWRITE(pwrite_intr),
		.PRDATA_o(PRDATA_o)
	);
	
	//APB_SLAVE INTEGRATION
	APB_slave #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) slave_inst(
		//inputs
		.PREADY(PREADY_i),
		.PWRDATA(pwrdata_intr), 
		.PADDR(paddr_intr),
		.PCLK(PCLK_i),
		.PRESETn(PRESETn_i),
		.PWRITE(pwrite_intr),
		.PENABLE(pena_intr),
		.PSEL(psel_intr),
		
		//outputs
		.PRDATA(p_rd_intr),
		.PREADY_o(p_ready_intr)
	);

endmodule
