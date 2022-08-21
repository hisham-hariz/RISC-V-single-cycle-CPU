## Aim
- Implementing all instructions of the RV32I set to make a single cycle CPU.

## Given
The goal of the single cycle CPU is to implement all instructions (except `FENCE`, `ECALL` and `EBREAK`) in the RV32I instruction set (pg. 130 of riscv-spec.pdf uploaded on Moodle).  For this, we will assume a simplified memory model, where data and instruction memory can be read in a single cycle (provide the address, and the memory responds with data in the same cycle), while allowing write at the next edge of the clock.  we are already provided with memory modules that behave as required, along with the following:
- Test bench with test cases including BRANCH instructions
    - Test bench will feed one input instruction per clock cycle
    - All registers are assumed initialized to 0 
- IMEM and DMEM are given as modules in the test bench. 

We need to implement code for the `cpu` module, that will read in the instructions and execute them. All functionality should be correct, so that the PC cannot be assumed to increment automatically by 4, and should be implemented correctly as per BRANCH instructions.

### Test cases

Test cases are given under the `test/` folder, with appropriate imem and dmem files.  Each imem file contains a set of instructions at the end that will dump all the register values into the first several locations in dmem.  The test bench will then read out these values from dmem and compare with expected results.

The file `dump.s` in the top folder also shows an example of assembly code that you can write to create your own test cases.  You can compile and disassemble as follows to generate the instruction codes.  Note that function calls need to be handled with care: the addresses for functions are not resolved till the Link step completes, so disassembled code will not look or work as expected.

```bash
$ riscv32-unknown-elf-gcc -c dump.s
$ riscv32-unknown-elf-objdump -d -Mnumeric,no-aliases dump.o
```
## Testing
The `run.sh` script performs all the steps required to compile and test your code.  The `iverilog` compiler is used for running the verilog simulations.
