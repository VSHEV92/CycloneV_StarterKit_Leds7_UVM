`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "base_test.svh"

module top_tb();

	parameter CLK_FREQ = 50;         // тактовая частота в МГц
	parameter RESET_DEASSIGN = 300;  // неативаный уровень стброса в нс 
	parameter BIT_RATE = 115200;     // скорость данных в бит/с
	
	logic clk = 0;
 	
	// интерфейсы
	UART_intf
	#(
		.BIT_RATE(BIT_RATE)
	) uart_rx ();
	
	Leds_intf leds();
	reset_intf resetn();

	// тестируемый модуль
	device_top
	#(
	  	.CLK_FREQ(CLK_FREQ),
    	.BIT_RATE(BIT_RATE)
	)
	DUT 
	(
		.*, 
		.resetn(resetn.resetn)
	);

	// тактовый сигнал 
	initial
		forever #(1e3 / CLK_FREQ / 2) clk = ~ clk;

	// старт теста
	initial begin
        uvm_config_db #(virtual UART_intf)::set(null, "*", "uart_rx", uart_rx); 
		uvm_config_db #(virtual Leds_intf)::set(null, "*", "leds", leds);
		uvm_config_db #(virtual reset_intf)::set(null, "*", "resetn", resetn);
        run_test("base_test");
	end

endmodule : top_tb