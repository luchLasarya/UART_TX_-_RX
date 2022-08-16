
`timescale 1ns / 1ps

module UART_RX_test;
	reg sck;
	reg rst_n;
	reg RX;
	wire [7 : 0] data_out;
	
	UART_RX DUT
		(
			.sck(sck),
			.rst_n(rst_n),
			.RX(RX),
			.data_out(data_out)
		);
		
	initial
		begin
			sck =1;
			rst_n = 0; RX = 0; #50; RX = 1; #50;
			rst_n = 1; RX = 1; #100;
			RX = 0; #20; 
			RX = 1; #20; 
			RX = 1; #20; 
			RX = 0; #20; 
			RX = 1; #20; 
			RX = 0; #20;
			RX = 1; #20;
			RX = 1; #20;
			RX = 0; #20; 
			RX = 1; #75;
			
			RX = 0; #20; 
			RX = 1; #20; 
			RX = 0; #20; 
			RX = 0; #20; 
			RX = 1; #20; 
			RX = 0; #20;
			RX = 1; #20;
			RX = 0; #20;
			RX = 1; #20; 
			RX = 1; #75;
			
			rst_n = 0; # 20;
			rst_n = 1; # 17;
			
			RX = 0; #20; 
			RX = 1; #20; 
			RX = 0; #20; 
			RX = 0; #20; 
			RX = 1; #20; 
			RX = 0; #20;
			RX = 1; #20;
			RX = 0; #20;
			RX = 1; #20; 
			RX = 1; #75;
			
			
			
		end
		
	always #10 sck = ~ sck;
	
endmodule
              		