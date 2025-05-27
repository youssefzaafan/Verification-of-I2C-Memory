///////////////////////////////////////////////////////////////////////////////
// File:        driver.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: uvm_driver class implementation
///////////////////////////////////////////////////////////////////////////////
`ifndef DRIVER_SV
    `define DRIVER_SV
class driver extends uvm_driver#(transaction);
//Factory
`uvm_component_utils(driver)
//Instances
transaction tr;
virtual i2c_i vif;
//Constructor
function new(string name = "driver", uvm_component parent = null);
super.new(name, parent);
endfunction
//Build Phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
tr = transaction::type_id::create("tr");
if(!uvm_config_db#(virtual i2c_i)::get(this, "", "vif", vif)) 
`uvm_error("DRV", "Failed to get virtual interface")
endfunction
//Reset logic
task reset_dut();
  begin
    `uvm_info("DRV", "System Reset", UVM_MEDIUM);
    vif.rst       <= 1'b1;  ///active high reset
    vif.addr      <= 0;
    vif.din       <= 0; 
    vif.wr        <= 0;
    @(posedge vif.clk);
  end
endtask 
//Write logic
task write_d();
  begin
    `uvm_info("DRV", "System Write", UVM_MEDIUM);
    vif.rst       <= 1'b0;  ///active high reset
    vif.addr      <= tr.addr;
    vif.din       <= tr.din; 
    vif.wr        <= 1'b1;
    @(posedge vif.done);
  end
endtask 
//Read logic
task read_d();
  begin
    `uvm_info("DRV", "System Read", UVM_MEDIUM);
    vif.rst       <= 1'b0;  ///active high reset
    vif.addr      <= tr.addr;
    vif.din       <= 0; 
    vif.wr        <= 1'b0;
    @(posedge vif.done);
    //tr.datard = vif.datard; // Capture read data from the interface.

  end
endtask 
//ٌRun Phase
virtual task run_phase(uvm_phase phase);
forever begin
       seq_item_port.get_next_item(tr);
            if (tr.op == rstdut) begin
                reset_dut();
            end else if (tr.op == writed) begin
                write_d();
            end else if (tr.op == readd) begin
                read_d();
            end
            else begin
                `uvm_error("DRV", "Invalid transaction operation");
            end
                   seq_item_port.item_done();

end
endtask
endclass
`endif 