# Learning FPGA Using iCEstick Evaluation Kit with Apio
## Common Apio codes:

    apio system --lsftdi
    apio boards --list
    apio verify
    apio build
    apio upload

## Project 3:
The "assignment" is shown in ''3_basic_logic/_assignment.png'', and the connection is done according to ''3_basic_logic/_connection.png''. Then run the following:

    cd 3_basic_logic
    apio init -b icestick
    apio verify  
    apio build --top-module basic_logic
    apio upload --top-module basic_logic

## Project 4-6:
Similar operation to that of project 3

## Project 7:
The "assignment" is shown in ''7_sim_debounce/_assignment.png'', then run:

    cd 7_sim_debounce
    apio init -b icestick
    apio verify  
    apio sim

Because of the problem installing `gtkwave` on M1 MacOS, installed it on a Windows 11 PC instead and run:

    gtkwave main_tb.vcd

The result from the gtkwave GUI is shown by the screenshots: `7_sim_debounce/_sim_fullRange.png` showing the full simulation run when the `go` input is invoked every 10us in the simulation, and `7_sim_debounce/_sim_go_debouncingHandling` showing by the red vertical line where the simulated debouncing occurs.

<img src="https://github.com/SphericalCowww/Elec_FPGA_iCEstick_practice/blob/main/7_sim_debounce/_sim_fullRange.png">

<img src="https://github.com/SphericalCowww/Elec_FPGA_iCEstick_practice/blob/main/7_sim_debounce/_sim_go_debouncingHandling.png">

## Project 8:
The "assignment" is shown in ''8_block_RAM/_assignment.png''. To do an initial RAM test do:

    cd 8_block_RAM_simple_read
    apio init -b icestick
    apio verify 
    apio build -v --top-module _block_16x4_RAM
    apio sim --testbench blockRAMtester_tb.v

Note that ''blockRAMtester.pcf'' is just a placeholder to run ''apio build -v''. ''Crtl-f'' with ''Device utilisation'' to find the memory usage.

Giving up on project 8, since the memory block cannot be invoked even in the most basic case, see <a href="https://www.reddit.com/r/FPGA/comments/1evg8ix/problem_invoking_block_ram/">Reddit</a>. 

## Project 9-10:
The assignments are not done, however, implemented the improved ''_clock_divider.v'' and ''_debouncer.v'' against glitch. Also a phase-locked loop on ''_clock_divider.v'' is implemented so that the base clock is at 120MHz instead of 12MHz directly from the device. The project simply drives a 0.1Hz LED on the device.

    cd 9_10_phase_lock_loop
    apio init -b icestick
    apio raw "icepll -i 12 -o 120"
    apio verify 
    apio build -v
    apio upload

The command apio raw "icepll -i 12 -o 120" is used to obtain the instantiation info for the phase-locked loop (see also <a href="https://www.youtube.com/watch?v=QkoGsd0QvBs">YouTube</a> for implementation). Note that the ''apio build -v'' indicated that the phase-locked loop is enabled with the following output:

    Info: Device utilisation:
    Info: 	         ICESTORM_LC:    84/ 1280     6%
    Info: 	        ICESTORM_RAM:     0/   16     0%
    Info: 	               SB_IO:     3/  112     2%
    Info: 	               SB_GB:     3/    8    37%
    Info: 	        ICESTORM_PLL:     1/    1   100%
    Info: 	         SB_WARMBOOT:     0/    1     0%

## Project 9-10 Attempted Arbitrary Waveform Generator:
Connect the circuit just like in <a href="https://github.com/SphericalCowww/Elec_RaspPiPico_WaveformGen_practice">github link</a> in the following photo:

<img src="https://github.com/SphericalCowww/Elec_FPGA_iCEstick_practice/blob/main/9_10_arbitrary_waveform_generator/_connection.png" width="500">

    cd 9_10_arbitrary_waveform_generator
    apio init -b icestick
    apio verify 
    apio build --top-module main_test
    apio upload --top-module main_test
    apio sim

Where ''PERIOD_RES/120MHz'' is the resolution period of how fine the generate function look, and ''PERIOD_FUNC/120MHz'' is the function period. Setting ''PERIOD_FUNC = 120'' gives a frequency of 1MHz, and the corresponding square wave is shown in the following photo:

<img src="https://github.com/SphericalCowww/Elec_FPGA_iCEstick_practice/blob/main/9_10_arbitrary_waveform_generator/_waveform_1MHz.png" width="500">

If we further set ''PERIOD_FUNC = 12'' making the frequency 10MHz, the corresponding square wave is shown in the following photo, which is likely distorted because the OP amp used does not have sufficient timing response:

<img src="https://github.com/SphericalCowww/Elec_FPGA_iCEstick_practice/blob/main/9_10_arbitrary_waveform_generator/_waveform_10MHz.png" width="500">

Moreover, in the verilog code, the ''func_iter'' is a ''reg'' type that needs to invoke flip-flops and the output ''pmod'' is a wire type. The synthesis (see <a href="https://www.reddit.com/r/FPGA/comments/13umtpy/difference_bw_synthesis_and_implementation/">Reddit</a>) between these two variables is deemed difficult, especially when the system functions such as ''$sin'' is involved (see <a href="https://www.reddit.com/r/FPGA/comments/1cqfapk/how_to_work_around_non_constant_realvalued/">Reddit</a>). In other words, FPGA waveform generator is limited in how arbitrary the functions are allowed.

## Project 11-12:

Not done. Its implementation of RISC-V processor seems like it defeats the purpose of FPGA? (see <a href="https://www.youtube.com/watch?v=7Elgs5HzIbE">Youtube</a>)

## Keywords:
- Verilog elements:

| Name | Description (local understanding) |
| - | - |
| wire | define a link variable (like physical wire) to a device IO port. Note that for an output wire of a function (module), linking it with a wire will result in ''output of a function: cannot be driven by primitives or continuous assignment''. In this case, use reg instead. |
| assign | give link  to a wire |
| reg | define a variable (register) |
| input | define device input wire |
| output | define device output wire |
| input reg | define input reg for a function (module) |
| output reg | define output reg for a function (module) |
| localparam | define variable with a fixed value |
| parameter | define variable of a function |
| defparam | give value to a parameter for a function |

- sensitivity list: list of registers to track with positive or negative edges in an "always" loop

- finite state machine, finite state automata, formal language, parsing, regular expressing, type theory, pumping lemma
- Computerphile, Computers Without Memory - Computerphile (<a href="https://www.youtube.com/watch?v=vhiiia1_hC4">YouTube</a>)

- See this <a href="https://www.reddit.com/r/FPGA/comments/13umtpy/difference_bw_synthesis_and_implementation/">Reddit</a> for the discussion on what synthesis means and this <a href="https://www.reddit.com/r/yosys/comments/fyxubo/synthesizing_ice40_512x8_block_ram/">Reddit</a> on how to "instantiate" block RAM (to invoke firmware directly) as opposed to "infer" block RAM (interpreted by Verilog and compiled to code that invoke the firmware).

## References:
- DigiKey, Introduction to FPGA (<a href="https://www.youtube.com/watch?v=lLg1AgA2Xoo&list=PLEBQazB0HUyT1WmMONxRZn9NmQ_9CIKhb">YouTube</a>)
- Lattice iCE40 LP/HX Low-Power, High-Performance FPGA with Small BGA package for the thinnest devices (<a href="https://www.latticesemi.com/iCE40">Website</a>, <a href="https://www.latticesemi.com/view_document?document_id=49383">iCE40 Pinout HX1K</a>, <a href="https://docs.rs-online.com/056e/0900766b814f658c.pdf">DS1040 - iCE40 LP/HX Family Data Sheet - RS Components</a>, <a href="https://www.latticesemi.com/~/media/LatticeSemi/Documents/UserManuals/EI/icestickusermanual.pdf">icestickusermanual</a>)
- Imperial College London, Verilog cheatsheet (<a href="http://www.ee.ic.ac.uk/pcheung/teaching/ee2_digital/Verilog%20Quick%20Reference%20Card%20v2_0.pdf">pdf</a>)
- When to use and not use FPGA (<a href="https://www.youtube.com/watch?v=7Elgs5HzIbE">Youtube</a>, <a href="https://www.eejournal.com/article/11-reasons-you-should-not-use-an-fpga-for-a-design-and-four-reasons-you-should/">Article</a>, <a href="https://news.ycombinator.com/item?id=15391163">Hacker News</a>)
- FPGA DEV: A brief look at the iCE40 Phase Locked Loop: Multiplying a 3.58 MHz clock up to 42.96 MHz! (<a href="https://www.youtube.com/watch?v=QkoGsd0QvBs">YouTube</a>)
