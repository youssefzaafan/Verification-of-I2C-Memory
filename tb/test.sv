///////////////////////////////////////////////////////////////////////////////
// File:        test.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: uvm_test class implementation
///////////////////////////////////////////////////////////////////////////////
`ifndef TEST_SV
    `define TEST_SV
class test extends uvm_test;
//Factory
`uvm_component_utils(test)
//Instances
env e;
write_data_sequence wds;
read_data_sequence rds;
reset_dut_sequence  rstds;
//Constructor
function new(string name = "test", uvm_component parent = null);
super.new(name, parent);
endfunction
//Build Phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
//Create the environment
e = env::type_id::create("env", this);
//Create sequences
wds = write_data_sequence::type_id::create("wds");
rds = read_data_sequence::type_id::create("rds");
rstds = reset_dut_sequence::type_id::create("rstds");
endfunction
//Run Phase
virtual task run_phase(uvm_phase phase);
phase.raise_objection(this);
//Run sequences

rstds.start(e.ag.seqr);

wds.start(e.ag.seqr);

rds.start(e.ag.seqr);

phase.drop_objection(this);
endtask
endclass

`endif
