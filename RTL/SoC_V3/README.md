# JS SoC Bootloader

A synthesizable SystemVerilog bootloader integrated with the **JS SoC** for loading instructions into instruction memory during the system boot process.

The bootloader receives 8-bit data transfers, assembles them into 32-bit instructions, and writes the instructions sequentially into instruction memory. The current version has been integrated with the JS SoC, functionally verified, and is **lint-clean with no linting errors**.

## Overview

The bootloader provides a simple interface for transferring a program into the JS SoC's instruction memory before processor execution begins.

Each instruction is transferred as four 8-bit data values:

```text
Byte 0       Byte 1       Byte 2       Byte 3
[31:24]      [23:16]      [15:8]       [7:0]
   |            |            |            |
   +------------+------------+------------+
                    32-bit instruction
```

The bootloader automatically generates the instruction-memory write pulse and increments the instruction address after each complete instruction.

## Features

* SystemVerilog RTL implementation
* Integrated with the **JS SoC**
* 8-bit input data interface
* 32-bit instruction assembly
* Four 8-bit transfers per instruction
* Configurable number of instructions to load
* Automatic instruction-memory address increment
* `ready` handshake mechanism
* Instruction-memory write control through `imem_write`
* Processor hold control through `hold`
* Instruction-memory selection through `sel`
* Synchronous active-high reset
* FSM-based control logic
* Synthesizable RTL
* **Functional verification completed with the JS SoC**
* **Lint-clean — no linting errors**

## Module

```text
bootloader
```

### Interface

| Signal       | Direction | Width | Description                                            |
| ------------ | --------- | ----: | ------------------------------------------------------ |
| `clk`        | Input     |     1 | System clock                                           |
| `rst`        | Input     |     1 | Synchronous active-high reset                          |
| `data_in`    | Input     |     8 | Input byte from the bootloader interface               |
| `write`      | Input     |     1 | Indicates a valid input transfer                       |
| `ready`      | Output    |     1 | Indicates that the bootloader is ready to receive data |
| `data_out`   | Output    |    32 | Completed 32-bit instruction                           |
| `address`    | Output    |     5 | Instruction-memory address                             |
| `sel`        | Output    |     1 | Instruction-memory/bootloader selection                |
| `imem_write` | Output    |     1 | Instruction-memory write enable                        |
| `hold`       | Output    |     1 | Holds the processor during bootloading                 |

## Bootloading Protocol

The bootloader expects the input stream in the following format:

```text
+----------------+----------------+---------------------------+
| Instruction    | Instruction    | Instruction Data         |
| Count          | 0              | ...                      |
+----------------+----------------+---------------------------+
```

The first byte received after reset specifies the number of instructions to be loaded.

Each instruction is then transferred using four consecutive bytes.

For example, to load:

```text
32'h12345678
```

the input sequence is:

```text
12 34 56 78
```

The bootloader assembles the bytes as:

```text
mem[31:24] = 8'h12
mem[23:16] = 8'h34
mem[15:8]  = 8'h56
mem[7:0]   = 8'h78
```

Resulting instruction:

```text
data_out = 32'h12345678
```

After the fourth byte, `imem_write` is asserted and the instruction is written to the current instruction-memory address.

## FSM

The bootloader is controlled by a five-state finite state machine:

```text
idle
  |
  v
load_counter
  |
  v
load_data <------+
  |              |
  | 4 bytes      |
  v              |
increment_address
  |
  | more instructions
  +--------------+
  |
  | instruction count reached
  v
done
```

### `idle`

Initial operating state.

The bootloader prepares the interface and transitions to `load_counter`.

### `load_counter`

Receives the number of instructions that will be loaded.

The instruction counter, memory byte counter, and instruction-memory address are initialized.

### `load_data`

Receives four bytes for each 32-bit instruction.

The byte counter selects the appropriate section of the instruction:

```text
00 -> [31:24]
01 -> [23:16]
10 -> [15:8]
11 -> [7:0]
```

After the fourth byte:

* The instruction is completed.
* `data_out` is updated.
* `imem_write` is asserted.
* The instruction counter is incremented.
* The FSM determines whether another instruction needs to be loaded.

### `increment_address`

Increments the instruction-memory address and prepares the bootloader to receive the next instruction.

### `done`

Entered after the requested number of instructions has been loaded.

The bootloader releases the processor by deasserting `hold` and disables the bootloader selection.

## JS SoC Integration

The bootloader has been integrated into the **JS SoC** as part of the instruction loading and boot process.

The high-level data flow is:

```text
        External Boot Data
                |
                | 8-bit
                v
        +---------------+
        |  Bootloader   |
        +-------+-------+
                |
                | 32-bit instruction
                | address
                | write enable
                v
        +---------------+
        | Instruction   |
        |    Memory     |
        +-------+-------+
                |
                v
        +---------------+
        |    JS SoC     |
        |     CPU       |
        +---------------+
```

During bootloading, the `hold` signal keeps the processor from executing instructions while the instruction memory is being populated.

Once all requested instructions have been written, the bootloader enters the `done` state and releases the processor.

## Functional Verification

Functional verification of the **bootloader integrated with the JS SoC has been completed**.

The verification confirms the bootloader's operation within the SoC integration, including:

* Instruction-count reception
* Sequential byte reception
* 32-bit instruction assembly
* Instruction-memory addressing
* Instruction-memory write generation
* Multiple-instruction loading
* Bootloader completion
* Processor release after bootloading

The bootloader was verified as an integrated component of the JS SoC rather than only as an isolated RTL module.

## RTL / Lint Status

The current implementation has been checked for RTL lint issues and is:

**Lint status: PASS**

There are currently **no reported linting errors** in this version of the bootloader.

The design uses:

* `always_ff` for sequential logic
* Enumerated SystemVerilog FSM states
* Non-blocking assignments for sequential logic
* Explicit synchronous reset behavior
* Synthesizable RTL constructs

## Reset Behavior

The bootloader uses a synchronous active-high reset.

When `rst` is asserted, the following are initialized:

```text
counter        = 0
instr_counter  = 0
ready          = 0
data_out       = 0
address        = 0
sel            = 0
hold           = 1
imem_write     = 0
mem            = 0
mem_counter    = 0
state          = idle
```

## Project Status

| Item                    | Status   |
| ----------------------- | -------- |
| Bootloader RTL          | Complete |
| JS SoC Integration      | Complete |
| Functional Verification | Complete |
| RTL Linting             | Pass     |
| Lint Errors             | None     |

