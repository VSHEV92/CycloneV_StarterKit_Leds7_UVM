`ifndef SCOREBOARD_H
`define SCOREBOARD_H

`include "uart_sequence_item.svh"
`uvm_analysis_imp_decl(_uart)
`uvm_analysis_imp_decl(_led7)

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern virtual function void write_uart(uart_sequence_item uart_sequence_item_inst);
    extern virtual function void write_led7(uart_sequence_item uart_sequence_item_inst);
    extern function void processing();
    
    uart_sequence_item seq_item_queue_in[$];
    uart_sequence_item seq_item_queue_out[$];

    uvm_analysis_imp_uart #(uart_sequence_item, scoreboard) analysis_port_uart;
    uvm_analysis_imp_led7 #(uart_sequence_item, scoreboard) analysis_port_led7;
    
endclass

function scoreboard::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void scoreboard::build_phase(uvm_phase phase);
    analysis_port_uart = new("analysis_port_uart", this);
    analysis_port_led7 = new("analysis_port_led7", this);
endfunction

function void scoreboard::write_uart(uart_sequence_item uart_sequence_item_inst);
    seq_item_queue_in.push_back(uart_sequence_item_inst);
endfunction

function void scoreboard::write_led7(uart_sequence_item uart_sequence_item_inst);
    seq_item_queue_out.push_back(uart_sequence_item_inst);
    processing();
endfunction

function void scoreboard::processing();
    uart_sequence_item seq_item_inst_in;
    uart_sequence_item seq_item_inst_out;

    seq_item_inst_in = seq_item_queue_in.pop_front();
    seq_item_inst_out = seq_item_queue_out.pop_front();

    if (!seq_item_inst_in.compare(seq_item_inst_out))
        `uvm_error("FAIL", seq_item_inst_in.convert2string())
    else
        `uvm_info("PASS",  seq_item_inst_in.convert2string(), UVM_LOW)
endfunction

`endif