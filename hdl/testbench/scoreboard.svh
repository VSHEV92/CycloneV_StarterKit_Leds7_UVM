`ifndef SCOREBOARD_H
`define SCOREBOARD_H

`include "uart_sequence_item.svh"
`uvm_analysis_imp_decl(_uart)
//`uvm_analysis_imp_decl(_out)

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern virtual function void write_uart(uart_sequence_item uart_sequence_item_inst);
    // extern virtual function void write_out(seq_item seq_item_inst);
    // extern function void processing();
    // extern function bit[8:0] get_ideal_sum(bit[7:0] a, bit[7:0] b);

    // seq_item seq_item_queue_in[$];
    // seq_item seq_item_queue_out[$];

    uvm_analysis_imp_uart #(uart_sequence_item, scoreboard) analysis_port_uart;
    //uvm_analysis_imp_out #(seq_item, scoreboard) analysis_port_out;

endclass

function scoreboard::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void scoreboard::build_phase(uvm_phase phase);
    analysis_port_uart = new("analysis_port_uart", this);
    //analysis_port_out = new("analysis_port_out", this);
endfunction

function void scoreboard::write_uart(uart_sequence_item uart_sequence_item_inst);
    //seq_item_queue_in.push_back(uart_sequence_item);
    `uvm_info("", uart_sequence_item_inst.convert2string(), UVM_LOW)
endfunction

// function void scoreboard::write_out(seq_item seq_item_inst);
//     seq_item_queue_out.push_back(seq_item_inst);
//     processing();
// endfunction

// function void scoreboard::processing();
//     seq_item seq_item_inst_in;
//     seq_item seq_item_inst_out;

//     seq_item_inst_in = seq_item_queue_in.pop_front();
//     seq_item_inst_in.c = get_ideal_sum(seq_item_inst_in.a, seq_item_inst_in.b);

//     seq_item_inst_out = seq_item_queue_out.pop_front();
//     seq_item_inst_out.a = seq_item_inst_in.a;
//     seq_item_inst_out.b = seq_item_inst_in.b;

//     if (!seq_item_inst_in.compare(seq_item_inst_out)) begin
//         `uvm_error("FAIL", seq_item_inst_in.convert2string())
//         test_result = 0;
//     end else
//         `uvm_info("PASS",  seq_item_inst_in.convert2string(), UVM_LOW)
// endfunction

// function bit[8:0] scoreboard::get_ideal_sum(bit[7:0] a, bit[7:0] b);
//     return a + b;
// endfunction

`endif