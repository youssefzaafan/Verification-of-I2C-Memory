///////////////////////////////////////////////////////////////////////////////
// File:        agent.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: uvm_agent class implementation
///////////////////////////////////////////////////////////////////////////////
`ifndef AGENT_SV
    `define AGENT_SV
class agent extends uvm_agent;
//Factory
`uvm_component_utils(agent)
//Instances
driver drv;
monitor mon;
uvm_sequencer#(transaction) seqr;
//Constructor
function new(string name = "agent", uvm_component parent = null);
super.new(name, parent);
endfunction
//Build phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
//Create driver, monitor, and sequencer
drv = driver::type_id::create("drv", this);
mon = monitor::type_id::create("mon", this);
seqr = uvm_sequencer#(transaction)::type_id::create("seqr",this);
endfunction
//Connect Phase
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
//Connect driver to sequencer
drv.seq_item_port.connect(seqr.seq_item_export);
endfunction
endclass
`endif