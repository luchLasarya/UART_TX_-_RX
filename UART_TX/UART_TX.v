module UART_TX
	(
		input sck,
		input rst_n,
		input t,
		input [7 : 0] data,
		output TX,
		output [9 : 0] buff_test,
		output [1 : 0] state_test,
		output [9 : 0] next_buff_test
			
	);
	
	localparam  WAIT =		2'b00,
					BUFF = 		2'b01,
					TRANSMIT = 	2'b10;
	
	reg [1 : 0] state;
	reg [1 : 0] next_state;
	reg [3 : 0] cnt;
	reg [3 : 0] next_cnt;
	reg [9 : 0] buffer;
	reg [9 : 0] next_buffer;
	
	always @(posedge sck or negedge rst_n)
		begin
			if (!rst_n)
				begin
					state <= WAIT;
					buffer <= 10'b1111111111;
					cnt <= 4'b0;
				end
			//else if (t & (cnt==4'b0) & rst_n) //!! Отправка пакета будет происходить после отжатия кнопки t ("передача", transmit). 
				//begin		// При высоком уровне t по фронту sck будет происходить запись в буфер данных для отправки.
					//state <= BUFF;
					//cnt <= 4'b0;
					//buffer <= {1'b1, data[7 : 0], 1'b0};
			//	end
			else
				begin
					state <= next_state;
					buffer <= next_buffer;
					cnt <= next_cnt;
				end
		end
			
	always @*
		begin
			next_state = state;
			case (state)
					WAIT : 		if (t)						      next_state = BUFF;
					BUFF : 		/*if (buffer[8 : 1] == data)*/ next_state = TRANSMIT;
					TRANSMIT :	if (cnt == 4'b1010)        next_state = WAIT;
			endcase
		end
		
	always @*
		begin
			next_cnt = cnt + 1'b1;
			case (state)
				WAIT :									next_cnt = 4'b0;
				BUFF :									next_cnt = 4'b0;
				TRANSMIT :	if (cnt == 4'b1010)	next_cnt = 4'b0;
			endcase
		end
	always @*
		begin
			case (state)
				WAIT :		next_buffer = 10'b1111111111;
				BUFF :		next_buffer = {1'b1, data[7 : 0], 1'b0};
				TRANSMIT :	next_buffer = {1'b1, {buffer[9 : 1]}};
			endcase
		end
		
		assign TX = (state == TRANSMIT)? buffer[0] : 1'b1;
		assign buff_test[9 : 0] = buffer[9 : 0];
		assign state_test[1 : 0] = state[1 : 0];
		assign next_buff_test[9 : 0] = next_buffer[9 : 0];
	
endmodule //UART_TX
