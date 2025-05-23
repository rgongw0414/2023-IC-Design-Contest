#RTL simulation, single pattern
mkdir -p Netlist Report
xrun tb.sv LASER.v +define+P1+USECOLOR+RTL +access+r  -clean -createdebugdb -input xrun.tcl 

#RTL simulation, all pattern
mkdir -p Netlist Report
xrun tb.sv LASER.v +define+USECOLOR+RTL +access+r  -clean -createdebugdb -input xrun.tcl

#Gate-Level simuation
xrun tb.sv LASER_syn.v +define+USECOLOR+SDF  +access+r  -clean -createdebugdb -v /cad/CBDK/CBDK_IC_Contest_v2.5/Verilog/tsmc13_neg.v +ncmaxdelays
xrun tb.sv LASER_syn.v +define+USECOLOR+SDF  +access+r  -clean -createdebugdb -v ~/CBDK_IC_Contest_v2.1/Verilog/tsmc13_neg.v  +ncmaxdelays
