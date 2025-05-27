class subscriber extends uvm_subscriber#(transaction);

  `uvm_component_utils(subscriber)

  transaction tr;
  real cov;

  covergroup cg @(tr);

    COV2 : coverpoint (tr.addr) {
      bins address[] = {[0:10]}; 
    }

    COV3 : coverpoint tr.din;
  endgroup

  function new(string name = "subscriber", uvm_component parent = null);
    super.new(name, parent);
    cg = new();
  endfunction

  function void write(transaction t);
    tr = t;
    cg.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov = cg.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("Functional Coverage is %0.2f%%", cov), UVM_LOW)
  endfunction

endclass
