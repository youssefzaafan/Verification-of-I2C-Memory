///////////////////////////////////////////////////////////////////////////////
// File:        scoreboard.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: uvm_scoreboard class implementation
///////////////////////////////////////////////////////////////////////////////
`ifndef SCOREBOARD_SV
    `define SCOREBOARD_SV
class scoreboard extends uvm_scoreboard;
//Factory
`uvm_component_utils(scoreboard)
//Instaces
uvm_analysis_imp#(transaction,scoreboard) recv;
 bit [7:0] arr[128] = '{default:0};
 bit [7:0] data_rd = 0;
 //Constructor
 function new(string name = "scoreboard", uvm_component parent = null);
 super.new(name, parent);
 recv = new("recv", this);
 endfunction
 // Checking Algorthim
 virtual function void write(transaction tr);
    if (tr.op == rstdut) begin
    `uvm_info("SCO", "SYSTEM RESET DETECTED", UVM_NONE);
    end
    else if (tr.op == writed) begin
        arr[tr.addr] = tr.din;
       `uvm_info("SCO", $sformatf("DATA WRITE OP  addr:%0d, wdata:%0d arr_wr:%0d",tr.addr,tr.din,  arr[tr.addr]), UVM_NONE);
        end
    else if (tr.op == readd) begin
        data_rd = arr[tr.addr];
        if (data_rd == tr.datard) begin
    `uvm_info("SCO", $sformatf("DATA MATCHED : addr:%0d, rdata:%0d",tr.addr,tr.datard), UVM_NONE)
        end
        else begin
    `uvm_info("SCO",$sformatf("TEST FAILED : addr:%0d, rdata:%0d data_rd_arr:%0d",tr.addr,tr.datard,data_rd), UVM_NONE) 
        end
    end
        $display("----------------------------------------------------------------");
endfunction
endclass
`endif
