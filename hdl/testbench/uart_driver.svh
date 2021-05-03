`ifndef UART_DRIVER_H
`define UART_DRIVER_H

`include "uart_sequence_item.svh"

`include "uvm_macros.svh"
import uvm_pkg::*;

class uart_driver extends uvm_driver #(uart_sequence_item);

    `uvm_component_utils(uart_driver)

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    virtual UART_intf uart_rx;
    uart_sequence_item uart_sequence_item_inst;

endclass

function uart_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void uart_driver::build_phase(uvm_phase phase);
    if (!uvm_config_db #(virtual UART_intf)::get(this, "", "uart_rx", uart_rx)) 
        `uvm_fatal("BFM", "Failed to get bfm");
endfunction

task uart_driver::run_phase(uvm_phase phase);
    forever begin
        seq_item_port.get_next_item(uart_sequence_item_inst);
       
        uart_rx.put_to_uart(uart_sequence_item_inst.get_led7_id(), uart_sequence_item_inst.delay_id);
    	uart_rx.put_to_uart(uart_sequence_item_inst.value, uart_sequence_item_inst.delay);

        seq_item_port.item_done();
    end
endtask

`endif