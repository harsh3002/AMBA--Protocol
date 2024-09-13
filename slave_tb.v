`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2024 11:13:20
// Design Name: 
// Module Name: slave_tb
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


module slave_tb();
    parameter DATA_WIDTH = 32, ADDR_WIDTH = 32;
    
        //OUTPUTS
		wire [DATA_WIDTH-1:0]	PRDATA_o;
		
		//INPUTS
		reg 					PCLK_i;
		reg 					PRESETn_i;
		reg [DATA_WIDTH-1:0]	PWRDATA_i;
		reg [ADDR_WIDTH-1:0]	PADDR_i;
		reg 					PWRITE_i;
		reg 					PREADY_i;
		reg 					EVENT_i;
    
   apb_top #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut 
   (
                  // O/Ps
                  .PRDATA_o(PRDATA_o),
                  
                  // I/Ns
		          .PCLK_i(PCLK_i),
			      .PRESETn_i(PRESETn_i),
			      .PWRDATA_i(PWRDATA_i),
		          .PADDR_i(PADDR_i),
			      .PWRITE_i(PWRITE_i),
			      .PREADY_i(PREADY_i),
			      .EVENT_i(EVENT_i)
                  ); 
                  
 always #5 PCLK_i = ~PCLK_i;
 
   task initialize; 
   begin
        PCLK_i = 0; PRESETn_i = 1;
        PWRITE_i = 0; 
        PADDR_i = 0;
        PREADY_i = 1;
        PWRDATA_i  = 0;
   end
   endtask
   
   task reset;
        begin
            PCLK_i = 0;
            PRESETn_i  = 1'b0;
            @(posedge PCLK_i);
             #1 PRESETn_i <= 1'b1;
            @(posedge PCLK_i);
        end
   endtask
   
   task event_trig ;
        begin
            EVENT_i <= 1;
            #11 EVENT_i <= 0;
        end
   endtask
   
   task write_stimulus ;
    input [DATA_WIDTH-1:0] WRDATA;
    input [ADDR_WIDTH-1:0] WRADDR; 
        begin
            @(posedge PCLK_i) ;
            PWRITE_i = 1;
            PWRDATA_i = WRDATA ;
            PADDR_i = WRADDR ;
            @(posedge PCLK_i);
            PREADY_i = 0;
            @(posedge PCLK_i);
            PREADY_i = 1;
            repeat (5) @(posedge PCLK_i);
        end
   endtask

   task read_stimulus ;
    input [ADDR_WIDTH-1:0] RDADDR; 
        begin
            @(posedge PCLK_i);
            PWRITE_i = 0;
            PADDR_i = RDADDR ;
            @(posedge PCLK_i);
            PREADY_i = 0;
            @(posedge PCLK_i);
            PREADY_i = 1;
            repeat (5) @(posedge PCLK_i);
        end
   endtask   
   
   initial begin
   
        initialize;
        reset;
        event_trig;
        write_stimulus(25,14);
        event_trig;
        write_stimulus(20,12);
        event_trig;
        write_stimulus(30,16);
        event_trig;
        write_stimulus(10,0);
        event_trig;
        write_stimulus(13,1);
        event_trig;
        write_stimulus(15,31);
        event_trig;
        write_stimulus(50,30);
        event_trig;
        read_stimulus (14);
        event_trig;
        read_stimulus (12);
        event_trig;
        read_stimulus (16);
        event_trig;
        read_stimulus (0);
        event_trig;
        read_stimulus (1);
        event_trig;
        read_stimulus (31);
        event_trig;
        read_stimulus (30);

        
        
        #10 $stop;
   end
   
endmodule
