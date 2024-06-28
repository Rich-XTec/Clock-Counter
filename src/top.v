
`timescale 1ns / 1ps

module top
(
	clk_i,
	rst_i,
	load_i,
	sw_i,
	but0_i,but1_i,but2_i,but3_i,
	led_one_second_o,
	unit_second_o,
	decimal_second_o
);

localparam N = 7;
localparam Z = 4;
localparam A = 0;
localparam [Z-1:0]offset;
input wire 			clk_i;
input wire 			rst_i, but0_i,but1_i,but2_i,but3_i;
input wire 			load_i;
input wire  [N-1:0]	sw_i;
output wire 		led_one_second_o;
output wire [N-1:0] unit_second_o;
output wire [N-1:0] decimal_second_o;

wire [Z-1:0] w_unit_second;
wire [Z-1:0] w_decimal_second;

//Carrego um numero de 0 a 15 direto no display atraves de 4 botões = offset
//1001 = 9
initial begin
clk_i = 1'b0;
rst_i = 1'b1;

but0_i= 1'b1;
but1_i= 1'b0;
but2_i= 1'b0;
but3_i= 1'b0;
offset[0] = but0_i;
offset[1] = but1_i;
offset[2] = but2_i;
offset[3] = but3_i;
sw_i = offset;

	if(rst_i == 1'b1)
		if(load_i == 1'b1)
			A=A+offset;
	else	begin//reset 
		w_unit_second= 4'b0;
		w_decimal_second= 4'b0;
	
	end

end

initial begin
		$display("*********************************************");
		$display("Monitor changes ShiftRight and ShiftLeft module");
        $monitor("offset=%b, sw = %d, Unit Seg = %d, Decimal Seg = %d",
			$offset, sw_i, w_unit_second, w_decimal_second);
		$display("*********************************************");
    end

always #10 clk_i = ~clk_i;
	 
digital_clock U00
(
	.clk_i       	  (clk_i), 
	.rst_i       	  (rst_i),
	.one_second_o	  (led_one_second_o), // LED
	.unit_seconds_o   (w_unit_second),
	.decimal_seconds_o(w_decimal_second)
);

// UNIT
dec7seg U01
(
    .bcd_i  (w_unit_second),
    .seg_o  (unit_second_o)
);

// DECIMAL
dec7seg U02
(
    .bcd_i  (w_decimal_second),
    .seg_o  (decimal_second_o)
);

endmodule
