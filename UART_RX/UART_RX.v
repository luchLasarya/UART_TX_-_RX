module UART_RX
	(
		input sck,
		input rst_n,
		input RX,
		output reg [8 : 0] data_out
	);
	
	localparam 	WAIT = 0,
					RECEIVE = 1;
	reg state;
	reg next_state;
	
	reg [9 : 0] buffer;
	reg [9 : 0] next_buffer;
	
	reg [3 : 0] cnt;
	reg [3 : 0] next_cnt;
	
	always @(posedge sck or negedge rst_n)
		begin
			if (! rst_n)
				begin
					state <= WAIT;
					cnt <= 4'b0;
				end
			else
				begin
					state <= next_state;
					cnt <= next_cnt;
					buffer <= next_buffer;
				end
		end
		
	always @*
		begin
			next_state = state;
			case (state)
				WAIT : 		if (! RX) 				next_state = RECEIVE;
				RECEIVE : 	if (cnt == 4'b1010) 	next_state = WAIT;
			endcase
		end
		
	always @*
		begin
			next_cnt = cnt + 1;
			case (state)
				WAIT : 									next_cnt = 4'b0;
				RECEIVE : 	if (cnt == 4'b1010) 	next_cnt = 4'b0;
			endcase
		end
		
	always @*
		begin
			case (state)
				WAIT :		next_buffer = buffer;
				RECEIVE :  	next_buffer = {buffer[8 : 0], RX};
			endcase
		end
		
	always @ (posedge sck)
		begin
			if (cnt == 4'b1001) data_out <= buffer[8 : 1]; 
		end
	
endmodule //UART_RX

