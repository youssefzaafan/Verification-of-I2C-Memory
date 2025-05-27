///////////////////////////////////////////////////////////////////////////////
// File:        reset_dut_sequence.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: uvm_reset_dut_sequence class implementation First Scenario
///////////////////////////////////////////////////////////////////////////////
`ifndef RESET_DUT_SEQUENCE_SV
    `define RESET_DUT_SEQUENCE_SV
class reset_dut_sequence extends uvm_sequence#(transaction);
//Factory
`uvm_object_utils(reset_dut_sequence)
//Instances
transaction tr;
//Constructor
function new(string name = "reset_dut_sequence");
super.new(name);
endfunction
//Build phase
task body();
repeat (15) begin
//Create a transaction
tr = transaction::type_id::create("tr");
//Write data to the DUT
start_item(tr);
assert(tr.randomize());
tr.op = rstdut;
        `uvm_info("SEQ", "MODE : RESET", UVM_NONE);
finish_item(tr);  
end
  endtask

endclass

`endif