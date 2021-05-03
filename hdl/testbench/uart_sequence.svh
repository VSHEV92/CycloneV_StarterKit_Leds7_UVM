`ifndef UART_SEQUENCE_H
`define UART_SEQUENCE_H

`include "uart_sequence_item.svh"

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_sequence extends uvm_sequence #(uart_sequence_item);
    
    `uvm_object_utils(uart_sequence)

    extern function new(string name = "uart_sequence");
    extern task body();

    int transactions_number = 100;

    uart_sequence_item uart_sequence_item_inst;
endclass

function uart_sequence::new(string name = "uart_sequence");
    super.new(name);
endfunction

task uart_sequence::body();
    repeat(transactions_number) begin
        uart_sequence_item_inst = uart_sequence_item::type_id::create("uart_sequence_item_inst");

        start_item(uart_sequence_item_inst);
        
        assert(uart_sequence_item_inst.randomize());
        
        finish_item(uart_sequence_item_inst);
    end
endtask

`endif