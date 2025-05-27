///////////////////////////////////////////////////////////////////////////////
// File:        transaction.sv
// Author:      Youssef Zaafan Atya
// Date:        2025-05-27
// Description: uvm_sequence_item class
///////////////////////////////////////////////////////////////////////////////
`ifndef TRANSACTION_SV
`define TRANSACTION_SV
typedef enum bit [1:0]   {readd = 0, writed = 1, rstdut = 2} oper_mode;
class transaction extends uvm_sequence_item;
//Factory
`uvm_object_utils(transaction)

//Fields
  oper_mode          op;
        logic        wr;
  randc logic  [6:0] addr;
  rand  logic  [7:0] din;
        logic  [7:0] datard;
        logic        done;
         
  constraint addr_c { addr <= 10;}
  //Constructor
    function new(string name = "transaction");
        super.new(name);
    endfunction

//Do_copy Func
  function void do_copy(uvm_object rhs);
    transaction rhs_;
    if (!$cast(rhs_, rhs))
      `uvm_fatal("COPY", "Failed to cast rhs");
    op = rhs_.op;
    wr = rhs_.wr;
    addr = rhs_.addr;
    din = rhs_.din;
    datard = rhs_.datard;
    done = rhs_.done;
  endfunction

//Convert2string
 function string convert2string();
  return $sformatf("op=%s, wr=%0b, addr=0x%0h, din=0x%0h, datard=0x%0h, done=%0b",
                   op.name(), wr, addr, din, datard, done);
endfunction

endclass
`endif 