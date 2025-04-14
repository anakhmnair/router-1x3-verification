# Router 1x3 Verification Project

This project verifies a packet-based Router 1x3 module using **SystemVerilog** and the **Universal Verification Methodology (UVM)** framework.

##  Overview

The Router 1x3 is designed to receive a network packet byte-by-byte from a source LAN and route it to one of three destinations based on the header. This project includes:

- RTL design written in **Verilog**
- UVM-based testbench for functional verification
- Assertions and coverage tracking for comprehensive testing

##  Verification Features

- **UVM Testbench**: Modular testbench architecture using UVM components (driver, monitor, scoreboard, agents)
- **Assertions**: Functional correctness checked using **SystemVerilog Assertions (SVA)**
- **Coverage**: Functional coverage to ensure complete test scenarios
- **Simulation Tool**: Verified using **Mentor QuestaSim**

## 📁 Directory Structure
rtl/ # Verilog RTL design 
tb/ # Testbench top and environment 
src_agt_top/ # Source agent UVM components 
dst_agt_top/ # Destination agent UVM components 
sim/ # Simulation files and scripts 
test/ # Test sequences

## 🛠️ Tools Used

- Verilog, SystemVerilog, UVM, SVA
- QuestaSim
- Linux Shell Scripting

## 👨‍💻 Author

**Anakh M Nair**  
[LinkedIn](https://www.linkedin.com/in/anakh-m-nair)

---

> This project is part of my VLSI Design and Verification training at Maven Silicon.