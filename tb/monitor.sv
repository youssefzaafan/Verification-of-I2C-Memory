///////////////////////////////////////////////////////////////////////////////
// File:        monitor.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: uvm_monitor class implementation
///////////////////////////////////////////////////////////////////////////////
`ifndef MONITOR_SV
    `define MONITOR_SV
class monitor extends uvm_monitor;
//Factory
`uvm_component_utils(monitor)
//Instances
uvm_analysis_port #(transaction) send;
transaction                      tr;
virtual i2c_i                    vif;
logic [15:0] din;
logic [7:0] dout;

//Constructor
function new(string name = "monitor", uvm_component parent = null);
super.new(name, parent);
endfunction
//Build Phase
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
//Create analysis port
send = new("send", this);
//Create Transaction
tr =transaction ::type_id::create("tr", this);
//Get vif
if(!uvm_config_db#(virtual i2c_i)::get(this, "", "vif", vif)) 
`uvm_error("MON", "Failed to get virtual interface")
endfunction

   // Run Phase
   virtual task run_phase(uvm_phase phase);
       forever begin
           @(posedge vif.clk);

           if (vif.rst) begin
        tr.op      = rstdut; 
               `uvm_info("MON", "SYSTEM RESET DETECTED", UVM_NONE)
               send.write(tr);
           end 
         else begin
               if (vif.wr) begin
                   tr.op = writed;
                   tr.addr = vif.addr;
                   tr.din = vif.din;
                   @(posedge vif.done); 
                   `uvm_info("MON", $sformatf("DATA WRITE addr:%0d data:%0d", tr.addr, tr.din), UVM_NONE)
                   send.write(tr);
               end else if (!vif.wr) begin 
                   tr.op = readd; 
                   tr.addr = vif.addr; 
                   @(posedge vif.done);  
                   tr.datard = vif.datard; 
                   `uvm_info("MON", $sformatf("DATA READ addr:%0d data:%0d ", tr.addr, tr.datard), UVM_NONE)
                   send.write(tr); 
               end
         end 
       end
         endtask
                  
endclass
`endif