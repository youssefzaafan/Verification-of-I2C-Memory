# I2C Memory UVM Verification Project

## 📘 Project Overview

This project implements a **UVM-based verification environment** for an **I2C memory module**. The testbench verifies I2C read, write, and reset operations according to the standard I2C protocol timing and behavior.

## 🧪 Protocol Summary

I2C is a synchronous, multi-master, multi-slave, packet-switched, single-ended, serial communication protocol. The figure below illustrates a standard I2C transaction:

- START condition
- 7-bit address + Read/Write bit
- Acknowledge bit
- Data bytes with Acknowledge bits
- STOP condition

![I2C Timing Diagram](./Screenshot%20(1).png)

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

### DUT Operation Flow
Write and Read transactions flow as follows:

![I2C Operation Flow](./Screenshot%20(2).png)

## 📂 Directory Structure

```
i2c_memory_uvm_project/
├── rtl/                    # DUT files (I2C memory)
├── tb/                     # UVM testbench files
│   ├── transaction.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── agent.sv
│   ├── scoreboard.sv
│   ├── env.sv
│   ├── test.sv
│   └── sequences/
│       ├── base_sequence.sv
│       ├── write_data_sequence.sv
│       ├── read_data_sequence.sv
│       └── reset_dut_sequence.sv
├── run/                    # Simulation scripts and logs
├── README.md
└── Makefile / sim.tcl      # Compilation and run scripts
```

## 🚀 How to Run

1. **Compile** the RTL and testbench:
   ```bash
   vcs -full64 -sverilog +acc +vpi +vcs+lic+wait -debug_pp        rtl/*.sv tb/*.sv tb/sequences/*.sv -o simv
   ```

2. **Run Simulation**:
   ```bash
   ./simv
   ```

3. **View Coverage**:
   Functional coverage is reported via UVM `subscriber`.

## ✅ Coverage & Results

The environment includes a functional coverage model for:
- Write/read operations
- Address space coverage
- Input data range

Example output:
```
UVM_INFO ... Functional Coverage is 60.68%
```

> Note: Add more bins to cover full address/data ranges to reach 100% functional coverage.

## 👨‍💻 Author

Youssef Zaafan Atya  
Email: youssefzafan@gmail.com  
LinkedIn: [Youssef Zaafan](https://www.linkedin.com/in/youssef-zaafan-211482169)
## Package Structure

All UVM components including interfaces, sequences, transaction, and environment components are encapsulated within a single package (`i2c_pkg.sv`). This makes the design modular and easy to include in other projects. To use the package, simply include:

```systemverilog
`include "i2c_pkg.sv"
import i2c_pkg::*;
```
