# Learning FPGA Using iCEstick Evaluation Kit
## Common apio codes:

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

## Project 4-5:
Similar operation to that of project 3

## Keywords:
- sensitivity list: list of registers to track with positive or negative edges in an "always" loop

finite state machine, finite state automata, formal language, parsing, regular expressing, type theory, pumping lemma
- Computerphile, Computers Without Memory - Computerphile (<a href="https://www.youtube.com/watch?v=vhiiia1_hC4">YouTube</a>)

## References:
- DigiKey, Introduction to FPGA (<a href="https://www.youtube.com/watch?v=lLg1AgA2Xoo&list=PLEBQazB0HUyT1WmMONxRZn9NmQ_9CIKhb">YouTube</a>)
- Lattice iCE40 LP/HX Low-Power, High-Performance FPGA with Small BGA package for the thinnest devices (<a href="https://www.latticesemi.com/iCE40">Website</a>, <a href="https://www.latticesemi.com/view_document?document_id=49383">iCE40 Pinout HX1K</a>, <a href="https://docs.rs-online.com/056e/0900766b814f658c.pdf">DS1040 - iCE40 LP/HX Family Data Sheet - RS Components</a>, <a href="https://www.latticesemi.com/~/media/LatticeSemi/Documents/UserManuals/EI/icestickusermanual.pdf">icestickusermanual</a>)
- Imperial College London, Verilog cheatsheet (<a href="http://www.ee.ic.ac.uk/pcheung/teaching/ee2_digital/Verilog%20Quick%20Reference%20Card%20v2_0.pdf">pdf</a>)
