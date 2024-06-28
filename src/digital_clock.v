module digital_clock
#(parameter SIZE = 4)
(
	clk_i, 
	rst_i,
	one_second_o,
	unit_seconds_o,
	decimal_seconds_o
);

input  wire  				 clk_i; 
input  wire 				 rst_i;
output wire 				 one_second_o;
output wire [SIZE-1 : 0] unit_seconds_o;
output wire [SIZE-1 : 0] decimal_seconds_o;

localparam N = 26;

reg [N-1:0] 		slow_clk;
reg [SIZE-1 : 0]  r_unit_seconds;
reg [SIZE-1 : 0]  r_decimal_seconds;
  
wire enable;

always @(posedge clk_i) begin
	if (rst_i == 1'b1)
		slow_clk <= 26'b0;
	else begin
		if (slow_clk == 26'd49999999) slow_clk <= 26'b0;
		else slow_clk <= slow_clk + 1'b1;
	end
end

always @ (posedge clk_i) begin
	if (rst_i == 1'b1) begin
		r_unit_seconds <= 4'b0;
		r_decimal_seconds <= 4'b0;
	end
	else begin
	
	
		if (enable == 1'b1)
			if (r_unit_seconds == 4'b1001) // COUNT UNIT
			begin 
				r_unit_seconds <= 4'b0; 
				r_decimal_seconds <= r_decimal_seconds + 1'b1;
				if (r_decimal_seconds == 4'b1001) r_decimal_seconds <= 1'b0; // CLEAR DECIMAL
			end
			else  r_unit_seconds <= r_unit_seconds + 1'b1;
	end 
end

assign enable = (slow_clk == 26'd49999999); //  1 segundo

assign one_second_o = enable;
assign unit_seconds_o = r_unit_seconds;
assign decimal_seconds_o = r_decimal_seconds;

endmodule
