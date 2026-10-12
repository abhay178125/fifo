# Synchronous FIFO using Verilog HDL

A single-clock First-In, First-Out (FIFO) buffer with configurable data width and depth.

## Features
- Synchronous write and read controls
- `full` and `empty` status flags
- Configurable `DATA_WIDTH` and `ADDR_WIDTH`
- Self-checking testbench
- VCD waveform output for GTKWave

## Interface
| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | Clock |
| `rst_n` | Input | Active-low asynchronous reset |
| `wr_en` | Input | Write request |
| `rd_en` | Input | Read request |
| `din` | Input | Input data |
| `dout` | Output | Last read data |
| `full` | Output | FIFO cannot accept a write |
| `empty` | Output | FIFO has no stored entries |

This implementation assumes `DEPTH == 2**ADDR_WIDTH` and `DEPTH >= 2`.

## Project structure
```text
Synchronous-FIFO-Verilog/
├── README.md
├── rtl/
│   └── sync_fifo.v
├── testbench/
│   └── sync_fifo_tb.v
└── .gitignore
```

## Simulate
Install Icarus Verilog, then run from the project directory:

```bash
iverilog -g2012 -o fifo_sim rtl/sync_fifo.v testbench/sync_fifo_tb.v
vvp fifo_sim
```

The testbench checks basic write/read ordering and status flags. It creates `fifo_wave.vcd`, which can be opened using:

```bash
gtkwave fifo_wave.vcd
```

## GitHub description
`Parameterized synchronous FIFO in Verilog HDL with read/write control, full/empty flags, and a simulation testbench.`

## Learning objectives
- Design a small sequential RTL block
- Manage read/write pointers and occupancy count
- Prevent writes when full and reads when empty
- Verify FIFO ordering through simulation

This is an educational starter project. Run and review the simulation before listing it as completed on your resume or LinkedIn.
