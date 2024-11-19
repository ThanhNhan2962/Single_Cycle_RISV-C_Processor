module wrapper (
	input  wire  		 CLOCK_50,
	input  wire [17:0] SW,
	input  wire [3:0]  BTN,
	output wire [16:0] LEDR,
	output wire [7:0]  LEDG,
	output wire [6:0]  HEX0,
	output wire [6:0]  HEX1,
	output wire [6:0]  HEX2,
	output wire [6:0]  HEX3,
	output wire [6:0]  HEX4,
	output wire [6:0]  HEX5,
	output wire [6:0]  HEX6,
	output wire [6:0]  HEX7,
	output wire [7:0]  LCD_DATA,
	output wire 		 LCD_RW,
	output wire 		 LCD_RS,
	output wire 		 LCD_EN,
	output wire 		 LCD_ON
);
	wire [31:0]  io_sw;
	wire [31:0]  io_btn;
	wire [31:0]  io_lcd;
	wire [31:0]  io_ledr;
	wire [31:0]  io_ledg;
	wire [6:0]   io_hex0;
	wire [6:0]   io_hex1;
	wire [6:0]   io_hex2;
	wire [6:0]   io_hex3;
	wire [6:0]   io_hex4;
	wire [6:0]   io_hex5;
	wire [6:0]   io_hex6;
	wire [6:0]   io_hex7;

	assign HEX0 = io_hex0;
	assign HEX1 = io_hex1;
	assign HEX2 = io_hex2;
	assign HEX3 = io_hex3;
	assign HEX4 = io_hex4;
	assign HEX5 = io_hex5;
	assign HEX6 = io_hex6;
	assign HEX7 = io_hex7;

  assign LEDR  = io_ledr[16:0];
  assign LEDG  = io_ledg[7:0];

  assign LCD_DATA = io_lcd[7:0];
  assign LCD_RW   = io_lcd[8];
  assign LCD_RS   = io_lcd[9];
  assign LCD_EN   = io_lcd[10];
  assign LCD_ON   = io_lcd[31];

  assign io_sw   = {14'b0, SW};
  assign io_btn  = {28'b0, BTN};
	singlecycle SINGLECYCLE_PROCESSOR( 
                       .i_clk     	(CLOCK_50),
                       .i_rst_n   	(SW[17]),
                       .i_io_sw   	(io_sw),
                       .i_io_btn  	(io_btn),
                       .o_io_ledr 	(io_ledr),
                       .o_io_ledg 	(io_ledg),
                       .o_io_hex0 	(io_hex0),
                       .o_io_hex1 	(io_hex1),
                       .o_io_hex2 	(io_hex2),
                       .o_io_hex3 	(io_hex3),
                       .o_io_hex4 	(io_hex4),
                       .o_io_hex5 	(io_hex5),
                       .o_io_hex6 	(io_hex6),
                       .o_io_hex7 	(io_hex7),
							  .o_io_lcd  	(io_lcd)
	);
endmodule