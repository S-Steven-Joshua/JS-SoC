# JS-SoC

**JS-SoC** is a 32-bit single-cycle **RISC-V System-on-Chip (SoC)** implemented entirely in **SystemVerilog**. The project integrates a custom **RV32I processor**, an **APB-based peripheral subsystem**, and an independent **Peripheral RAM** for peripheral-to-processor data transfer.

The primary goal of JS-SoC is to demonstrate the design and integration of a complete RISC-V-based SoC, including processor datapath, memory system, APB interconnect, memory-mapped peripherals, and peripheral write-back functionality.

---

## Features

* ✅ 32-bit RV32I Single-Cycle RISC-V Processor
* ✅ Custom ALU and Control Unit
* ✅ Register File
* ✅ Immediate Generator
* ✅ Instruction Memory (IMEM)
* ✅ Data Memory
* ✅ APB Master Interface
* ✅ APB Peripheral Address Decoder
* ✅ Memory-Mapped I/O
* ✅ UART Peripheral
* ✅ PWM Peripheral
* ✅ Timer Peripheral
* ✅ I²C Peripheral
* ✅ Independent Peripheral RAM
* ✅ Peripheral-to-CPU Write-Back Path
* ✅ Data-Path MUX for Data Memory / Peripheral RAM Selection
* ✅ Java-Based Control Word Generator
* ✅ SystemVerilog Functional Verification

---

## System Architecture

```text
                         +----------------------+
                         |    RV32I Processor   |
                         |    Single-Cycle      |
                         +----------+-----------+
                                    |
                           Load / Store Access
                                    |
                              +-----+-----+
                              |   Bridge  |
                              +-----+-----+
                                    |
                    +---------------+---------------+
                    |                               |
              Normal Memory                   APB Peripheral
                 Access                           Access
                    |                               |
                    v                               v
             +-------------+              +----------------+
             | Data Memory |              |   APB Master   |
             +-------------+              +-------+--------+
                                                    |
                              +---------------------+---------------------+
                              |          |            |                  |
                             UART        PWM         Timer               I²C
                              |          |            |                  |
                              +----------+------------+------------------+
                                                    |
                                         Peripheral Write-Back
                                                    |
                                                    v
                                           +----------------+
                                           | Peripheral RAM |
                                           |     [31:0]     |
                                           +-------+--------+
                                                   |
                                                   v
                                            +--------------+
                                            | Data-Path    |
                                            |     MUX      |
                                            +------+-------+
                                                   |
                                                   v
                                             CPU Writeback
```

---

# Processor

The processor implements the **RISC-V RV32I instruction set architecture** using a single-cycle datapath.

Each instruction is fetched, decoded, executed, and completed within a single clock cycle.

### Core Components

* Program Counter (PC)
* Instruction Memory (IMEM)
* Instruction Decoder
* Control Unit
* Register File
* ALU
* Immediate Generator
* Data Memory
* Write-Back Logic

The processor accesses peripherals through standard RISC-V load (`LW`) and store (`SW`) instructions.

---

# Bridge and Peripheral Access

The bridge connects the processor's memory-access path to the APB peripheral subsystem.

The bridge performs address decoding for the APB peripheral address space:

```text
0x4000_0000 - 0x4000_0017
```

Only memory access operations can target the peripheral address space.

### Store Access

For an `SW` instruction, the bridge uses the controller-generated **`mem_write`** signal to identify a store operation.

If the address falls within the APB address range, the bridge generates the appropriate peripheral select signal and initiates an APB write transaction.

### Load Access

For an `LW` instruction, the bridge checks the **instruction opcode** to identify the load operation.

If the address belongs to the APB peripheral range, the bridge performs the corresponding peripheral read operation.

### Other Instructions

For instructions that are not memory accesses, the bridge ignores the APB address and data.

Therefore, an address in the APB range does not automatically result in a peripheral transaction. The instruction must represent a valid `LW` or `SW` access.

---

# APB Address Map

The current peripheral address map is:

| Address Range               | Peripheral | APB Select |
| --------------------------- | ---------- | ---------- |
| `0x4000_0000 – 0x4000_0007` | UART       | `3'b001`   |
| `0x4000_0008 – 0x4000_000B` | PWM        | `3'b010`   |
| `0x4000_000C – 0x4000_0013` | Timer      | `3'b011`   |
| `0x4000_0014 – 0x4000_0017` | I²C        | `3'b100`   |

The bridge uses these address ranges to select the corresponding APB peripheral.

---

# Peripherals

## UART

The UART peripheral provides serial communication between the SoC and an external host.

The UART implementation includes:

* Baud Rate Generator
* UART Transmitter
* UART Receiver
* Serializer
* Deserializer

The UART is accessed through memory-mapped registers using RISC-V load and store instructions.

---

## PWM

The PWM peripheral generates programmable **Pulse-Width Modulated (PWM)** waveforms.

Configurable parameters include:

* Period
* Duty Cycle

The PWM peripheral can be used for applications such as:

* LED brightness control
* Motor speed control
* Servo control
* General-purpose waveform generation

---

## Timer

The Timer peripheral provides programmable timing and delay functionality.

Typical applications include:

* Software delays
* Event timing
* Periodic operations
* Time-based peripheral control

The timer is controlled through memory-mapped registers.

---

## I²C

The I²C peripheral provides **Inter-Integrated Circuit (I²C)** communication using the standard two-wire interface:

* **SDA** — Serial Data
* **SCL** — Serial Clock

The I²C peripheral is integrated into the APB subsystem and can be controlled by the RISC-V processor through memory-mapped accesses.

Potential applications include communication with:

* Sensors
* EEPROMs
* Real-time clocks
* GPIO expanders
* ADC/DAC devices
* Other I²C-compatible devices

---

# Peripheral RAM

JS-SoC contains a dedicated **Peripheral RAM** that is independent of the normal Data Memory in the processor datapath.

The Peripheral RAM provides a mechanism for peripherals to write data back to the processor.

### Peripheral Write-Back Path

```text
Peripheral
    |
    v
Peripheral RAM
    |
    v
Data-Path MUX
    |
    v
CPU Writeback
```

The Peripheral RAM is therefore separate from the processor's normal Data Memory.

When a peripheral produces data that needs to be read by the processor, the data is stored in the Peripheral RAM.

The processor can then access this data through the appropriate load path.

---

# Data-Path MUX

A MUX is present in the processor's data path to select the source of data written back to the register file.

The MUX separates:

```text
Normal CPU Data Access:

Data Memory
     |
     v
    MUX
     |
     v
CPU Writeback
```

from:

```text
Peripheral Data Access:

Peripheral RAM
     |
     v
    MUX
     |
     v
CPU Writeback
```

This allows the Peripheral RAM to remain independent from the normal Data Memory while still providing peripheral-generated data to the processor.

---

# Peripheral RAM Access

Peripheral RAM access is handled separately from normal data-memory access.

When the processor performs a load operation targeting the peripheral data path, the bridge and datapath determine whether the returned data should come from the Peripheral RAM rather than the normal Data Memory.

This provides a dedicated path for:

**Peripheral → Peripheral RAM → MUX → CPU**

without requiring the Peripheral RAM to be part of the processor's normal Data Memory.

---

# Java Control Word Generator

A Java-based utility is included to simplify peripheral configuration.

The application generates 32-bit control words based on user-selected peripheral parameters.

The utility is intended to simplify configuration of peripherals such as:

* PWM period and duty cycle
* Timer configuration
* I²C configuration

Generated control words can be written to the corresponding memory-mapped peripheral registers.

---

# Verification

The functionality of JS-SoC is verified using **SystemVerilog functional testbenches** within this repository.

Verification covers both individual components and complete SoC-level functionality.

### Verified Functionality

* RV32I instruction execution
* Register operations
* ALU operations
* Data-memory access
* Bridge operation
* Peripheral address decoding
* `LW` peripheral access
* `SW` peripheral access
* APB transactions
* UART communication
* PWM waveform generation
* Timer operation
* I²C functionality
* Peripheral RAM write-back
* Data-path MUX selection
* End-to-end SoC functional behavior

The functional verification is focused on validating the intended RTL behavior of the complete SoC.

---

# Shortcomings / Current Limitations

The current implementation is a functional single-cycle SoC and has several areas that can be improved.

### 1. Single-Cycle Processor

The processor currently uses a single-cycle architecture.

As the design becomes more complex, a single-cycle implementation limits the achievable operating frequency because the critical path includes instruction fetch, decode, execution, memory access, and write-back within one clock cycle.

**Planned improvement:** Move toward a pipelined RISC-V implementation.

---

### 2. No Bootloader

Currently, the instruction memory is populated using a predefined/hardcoded instruction image.

This limits flexibility because changing the application requires modifying the instruction-memory contents.

**Planned improvement:** Implement a bootloader that loads instructions into IMEM during reset.

---

### 3. Limited Peripheral Set

The current SoC includes:

* UART
* PWM
* Timer
* I²C

Additional commonly used interfaces such as GPIO and SPI are not currently implemented.

---

### 4. No Interrupt Architecture

The current design does not implement a general-purpose interrupt controller or interrupt-driven peripheral architecture.

Peripheral communication is handled through the existing memory-mapped and Peripheral RAM data paths.

**Planned improvement:** An interrupt architecture can be considered in a future revision if required.

---

### 5. Peripheral RAM Interface

The Peripheral RAM provides a dedicated peripheral-to-CPU data path, but the current mechanism is relatively simple compared with more sophisticated DMA or interrupt-driven data-transfer architectures.

**Potential improvement:** Develop a more scalable peripheral data-transfer mechanism for higher-throughput peripherals.

---

### 6. No Hardware Deployment Yet

The current project focuses on RTL design and functional verification.

FPGA deployment and physical implementation are not currently part of this repository.

---

### 7. No Automated Software Toolchain

The current instruction-memory workflow relies on predefined instruction contents.

A complete automated flow from RISC-V assembly/C code to the IMEM image is not yet integrated into the project.

The planned bootloader and future software-toolchain work will improve this workflow.

---

# Future Enhancements

The major planned improvements include:

* **Bootloader for dynamic IMEM initialization**
* 5-stage pipelined RISC-V processor
* GPIO peripheral
* SPI interface
* Improved peripheral data-transfer mechanisms
* Automated assembly-to-machine-code workflow
* FPGA deployment
* ASIC implementation flow

The **LibreLane-based implementation flow** will be developed and maintained in a separate repository. That repository will focus on synthesis, physical implementation, and related implementation-level checks.

---

# Technologies Used

* **SystemVerilog**
* **Vivado Simulator**
* **Java**
* **RISC-V RV32I ISA**
* **Advanced Peripheral Bus (APB)**
* **I²C Protocol**

---

# License

This project is released for educational and research purposes.

Feel free to use, modify, and extend the design while providing appropriate attribution.

---

# Author

**Steven Joshua**

**Swatish Subramanian**

