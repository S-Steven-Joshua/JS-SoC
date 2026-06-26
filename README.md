# JS-SoC

**JS-SoC** is a 32-bit single-cycle **RISC-V System-on-Chip (SoC)** implemented entirely in **SystemVerilog**. The project demonstrates the complete design and integration of a custom RV32I processor with an **Advanced Peripheral Bus (APB)** architecture and multiple memory-mapped peripherals. 

---

## Features

* ✅ 32-bit RV32I Single-Cycle RISC-V Processor
* ✅ Custom ALU and Control Unit
* ✅ Register File
* ✅ Immediate Generator
* ✅ Instruction Memory
* ✅ Data Memory
* ✅ APB Master Interface
* ✅ Memory-Mapped I/O
* ✅ UART Peripheral
* ✅ PWM Peripheral
* ✅ Timer Peripheral
* ✅ Java-Based Control Word Generator

---

## System Architecture

```text
                    +----------------------+
                    |   RV32I Processor    |
                    | (Single-Cycle Core)  |
                    +----------+-----------+
                               |
                             Bridge
                               |
                          APB Master
                               |
        +----------------------+----------------------+
        |                      |                      |
   UART Peripheral       PWM Peripheral       Timer Peripheral
        |                      |                      |
   Serial Output          PWM Output           Delay/Timing
```

---

## Processor

The processor implements the **RV32I** instruction set architecture using a single-cycle datapath. Each instruction is fetched, decoded, executed, and completed in a single clock cycle.

Core components include:

* Program Counter (PC)
* Instruction Decoder
* Control Unit
* Register File
* ALU
* Immediate Generator
* Instruction Memory
* Data Memory

---

## APB Interconnect

JS-SoC uses the **Advanced Peripheral Bus (APB)** for communication between the processor and peripherals.

The APB master performs memory-mapped transactions, allowing peripherals to be accessed using standard RISC-V load and store instructions.

---

## Peripherals

### UART

The UART peripheral enables serial communication between the SoC and an external host.

Features include:

* Baud Rate Generator
* Serializer
* UART Transmitter
* UART Receiver
* Deserializer

---

### PWM

The PWM peripheral generates programmable pulse-width modulated waveforms.

Configurable parameters include:

* Period
* Duty Cycle

Suitable for applications such as LED brightness control and motor speed control.

---

### Timer

The timer peripheral provides programmable timing and delay functionality.

Typical applications include:

* Software delays
* Event timing
* Periodic operations

---

## Memory Map

| Address      | Peripheral  |
| ------------ | ----------- |
| `0x00000000` | Data Memory |
| `0x40000000` | UART        |
| `0x40000008` | PWM         |
| `0x4000000C` | Timer       |

---

## Java Control Word Generator

A Java application is included to simplify peripheral configuration.

The utility generates 32-bit control words based on user-selected parameters for:

* PWM period and duty cycle
* Timer configuration

These control words can be written directly to the corresponding memory-mapped peripheral registers.

---

## Verification

The entire SoC has been verified using comprehensive SystemVerilog testbenches.

Verified functionality includes:

* Processor instruction execution
* Register operations
* Memory access
* APB transactions
* UART communication
* PWM waveform generation
* Timer operation
* End-to-end SoC integration

---

## Future Enhancements

Planned improvements include:

* 5-Stage Pipelined RISC-V Processor
* Interrupt Controller
* GPIO Peripheral
* SPI Interface
* I²C Interface
* FPGA Deployment
* ASIC Design Flow Support
* Automated Assembly-to-Machine Code Toolchain

---

## Technologies Used

* **SystemVerilog**
* **Vivado Simulator**
* **Java**
* **RISC-V RV32I ISA**
* **Advanced Peripheral Bus (APB)**

---

## License

This project is released for educational and research purposes. Feel free to use, modify, and extend the design while providing appropriate attribution.

---

## Author

**Steven Joshua**
