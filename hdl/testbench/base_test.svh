`ifndef BASE_TEST_H
`define BASE_TEST_H

`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;

`include "Led7_test_env.svh" 

class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task reset_dut();

    virtual reset_intf resetn;

    Led7_test_env env;

endclass

function base_test::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction

function void base_test::build_phase(uvm_phase phase);
    if (!uvm_config_db #(virtual reset_intf)::get(this, "", "resetn", resetn)) 
        `uvm_fatal("BFM", "Failed to get bfm");

    env = Led7_test_env::type_id::create("env", this);

endfunction

task base_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    reset_dut();
    env.uart_sequence_inst.start(env.uart_agent_inst.uart_sequecer_inst);
    phase.drop_objection(this);
endtask

task base_test::reset_dut();
    resetn.resetn = 0;
    #100;
    resetn.resetn = 1;
    #200;
endtask


`endif