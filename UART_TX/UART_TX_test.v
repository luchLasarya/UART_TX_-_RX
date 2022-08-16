
`timescale 1ns / 1ps

module UART_TX_test;

	reg sck;
	reg rst_n;
	reg t;
	reg [7 : 0] data;
	wire TX;
	wire [9 : 0]buff_test;
	wire [1 : 0] state_test;
	wire [9 : 0] next_buff_test;
	
	UART_TX DUT
		(
			.sck(sck),
			.rst_n (rst_n),
			.t (t),
			.data (data),
			.TX(TX),
			.buff_test(buff_test),
			.state_test(state_test),
			.next_buff_test(next_buff_test)
		);
		
	initial
		begin
			sck = 0;
			rst_n = 0; t = 0; data = 8'b11001011; #60;
			t = 1; #30;
			rst_n = 1; # 80;
			rst_n = 0; # 80;
			rst_n = 1; t = 0; data = 8'b10101101; #80;
			t = 1; #5;
			t = 0; #200;
			t = 1; #20;
			t = 0; #200;
			data = 8'b11111111; #35;
			t = 1; #20;
			t = 0; #20;
			
			end
		
	always #10 sck = ~sck;
	
endmodule // UART_TX_test