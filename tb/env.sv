///////////////////////////////////////////////////////////////////////////////
// File:        env.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: uvm_env class implementation
///////////////////////////////////////////////////////////////////////////////
`ifndef UVM_ENV_SV
    `define UVM_ENV_SV

class env extends uvm_env;
//Factory
`uvm_component_utils(env)
//Instances
agent ag;
scoreboard scb;
subscriber sub;
//Constructor
function new(string name = "env", uvm_component parent = null);
super.new(name, parent);
endfunction
//Build Phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
//Create agent and scoreboard instances
ag = agent::type_id::create("ag", this);
scb = scoreboard::type_id::create("scb", this);
sub = subscriber::type_id::create("sub", this);
endfunction
//Connect Phase
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
//Connect monitor and scoreboard ports
ag.mon.send.connect(scb.recv);
ag.mon.send.connect(sub.analysis_export);
endfunction
endclass
`endif