APB Slave

This repository contains a Verilog implementation of an APB (Advanced Peripheral Bus) slave. The APB is a low-bandwidth, low-latency bus designed for interfacing with peripheral devices in SoCs.

Features

APB Slave Interface: Implements a basic APB slave module.

Read/Write Support: Handles read and write operations.

Address Decoding: Basic address decoding for peripheral address space.

Simple Control Logic: Basic control signals for data transfer.

Files

apb_master.v: Verilog module for the dummy APB master/bridge.

APB_slave.v: Verilog module for the APB slave.

slave_tb.v: Testbench for the APB slave module.

README.md: This file.


Testbench
The provided testbench (slave_tb.v) includes basic scenarios to validate the functionality of the APB slave. It covers:

Read and write operations.
Address decoding.
Basic timing and control signals.

Acknowledgements

ARM for providing the APB specification.
