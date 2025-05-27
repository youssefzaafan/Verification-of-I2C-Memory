///////////////////////////////////////////////////////////////////////////////
// File:        read_data_sequence.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: uvm_write_data_sequence class implementation First Scenario
///////////////////////////////////////////////////////////////////////////////
`ifndef READ_DATA_SEQUENCE_SV
    `define READ_DATA_SEQUENCE_SV
class read_data_sequence extends uvm_sequence#(transaction);
//Factory
`uvm_object_utils(read_data_sequence)
//Instances
transaction tr;
//Constructor
function new(string name = "read_data_sequence");
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
tr.op = readd;
    `uvm_info("SEQ", $sformatf("MODE : READ ADDR : %0d ", tr.addr), UVM_NONE);
finish_item(tr);  
end
  endtask
endclass
`endif