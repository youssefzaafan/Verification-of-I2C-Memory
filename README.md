# I2C Memory UVM Verification Project

## 📘 Project Overview

This project implements a **UVM-based verification environment** for an **I2C memory module**. The testbench verifies I2C read, write, and reset operations according to the standard I2C protocol timing and behavior.
---
## 🧪 Protocol Summary

I2C is a synchronous, multi-master, multi-slave, packet-switched, single-ended, serial communication protocol. The figure below illustrates a standard I2C transaction:

- START condition
- 7-bit address + Read/Write bit
- Acknowledge bit
- Data bytes with Acknowledge bits
- STOP condition

![I2C Timing Diagram](./Screenshot%20(1).png)
---

## 🧠 Architecture

### UVM Testbench Components:
- **`transaction`**: Encapsulates I2C transaction fields like op (read/write/reset), address, data, and write/read signals.
- **`sequence`**: Includes multiple sequences:
  - `reset_dut_sequence`
  - `write_data_sequence`
  - `read_data_sequence`
- **`driver`**: Drives I2C signals to the DUT based on the transaction.
- **`monitor`**: Observes and records the DUT outputs.
- **`agent`**: Includes sequencer, driver, and monitor.
- **`subscriber`**: Collects functional coverage.
- **`scoreboard`**: Checks correctness of read/write operations.
- **`env`**: Integrates all components.
- **`test`**: Instantiates sequences and starts the simulation.
---

### DUT Operation Flow
Write and Read transactions flow as follows:

![I2C Operation Flow](./Screenshot%20(2).png)
---

## 📂 Directory Structure

```
i2c_memory_uvm_project/
├── rtl/                    # DUT files (I2C memory)
├── tb/                     # UVM testbench files
   ├── transaction.sv
   ├── driver.sv
   ├── monitor.sv
   ├── agent.sv
   ├── scoreboard.sv
   ├── env.sv
   ├── test.sv
   └── sequences/
       ├── base_sequence.sv
       ├── write_data_sequence.sv
       ├── read_data_sequence.sv
       └── reset_dut_sequence.sv

```
---

## 🔧 Tools & Technologies

- **Language**: SystemVerilog
- **Methodology**: UVM (Universal Verification Methodology)
- **Simulator**: Adlec Riviera Pro 2023.04
- **Target Design**: I2C Memory with clocked output

---
## 🚀 How to Run

1. **Compile** the RTL and testbench:
   ```bash
   vsim +access+r;
    run -all;
    acdb save;
    acdb report -db fcover.acdb -txt -o coverage_data.txt;
    exit
   ```
   

2. **Run Simulation**:
   [EDA Playground Link](https://www.edaplayground.com/x/HfsZ)
---

## ✅ Coverage & Results

The environment includes a functional coverage model for:
- Address space coverage
- Input data range

Example output:
```systemverilog
# KERNEL: ----------------------------------------------------------------
# KERNEL: UVM_INFO /home/runner/read_data_sequence.sv(27) @ 397970: uvm_test_top.env.ag.seqr@@rds [SEQ] MODE : READ ADDR : 0 
# KERNEL: UVM_INFO /home/runner/driver.sv(51) @ 397970: uvm_test_top.env.ag.drv [DRV] System Read
# KERNEL: UVM_INFO /home/runner/monitor.sv(58) @ 398450: uvm_test_top.env.ag.mon [MON] DATA READ addr:0 data:100 
# KERNEL: UVM_INFO /home/runner/scoreboard.sv(33) @ 398450: uvm_test_top.env.scb [SCO] DATA MATCHED : addr:0, rdata:100
# KERNEL: ----------------------------------------------------------------
# KERNEL: UVM_INFO /home/build/vlib1/vlib/uvm-1.2/src/base/uvm_objection.svh(1271) @ 398450: reporter [TEST_DONE] 'run' phase is ready to proceed to the 'extract' phase
# KERNEL: UVM_INFO /home/runner/subscriber.sv(35) @ 398450: uvm_test_top.env.sub [subscriber] Functional Coverage is 100.00%
# KERNEL: UVM_INFO /home/build/vlib1/vlib/uvm-1.2/src/base/uvm_report_server.svh(869) @ 398450: reporter [UVM/REPORT/SERVER] 
# KERNEL: --- UVM Report Summary ---
# KERNEL: 
# KERNEL: ** Report counts by severity
# KERNEL: UVM_INFO : 3264
# KERNEL: UVM_WARNING :    0
# KERNEL: UVM_ERROR :    0
# KERNEL: UVM_FATAL :    0
# KERNEL: ** Report counts by id
# KERNEL: [DRV]   815
# KERNEL: [MON]   815
# KERNEL: [RNTST]     1
# KERNEL: [SCO]   815
# KERNEL: [SEQ]   815
# KERNEL: [TEST_DONE]     1
# KERNEL: [UVM/RELNOTES]     1
# KERNEL: [subscriber]     1
# KERNEL: 
# RUNTIME: Info: RUNTIME_0068 uvm_root.svh (521): $finish called.
# KERNEL: Time: 398450 ns,  Iteration: 62,  Instance: /tb,  Process: @INITIAL#26_2@.
# KERNEL: stopped at time: 398450 ns
# VSIM: Simulation has finished. There are no more test vectors to simulate.
acdb save;
acdb report -db fcover.acdb -txt -o coverage_data.txt;
exit
# VSIM: Simulation has finished.
Done
```
---

## Package Structure

All UVM components including interfaces, sequences, transaction, and environment components are encapsulated within a single package (`pkg.sv`). This makes the design modular and easy to include in other projects. To use the package, simply include:

```systemverilog
`include "pkg.sv"
import pkg::*;
```
---
## 👨‍💻 Author

Youssef Zaafan Atya  
Email: youssefzafan@gmail.com  
LinkedIn: [Youssef Zaafan](https://www.linkedin.com/in/youssef-zaafan-211482169)
