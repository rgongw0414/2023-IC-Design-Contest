set company "CIC"
set designer "Student"
set search_path      "./ ~/CBDK_IC_Contest_v2.1/SynopsysDC/db  $search_path"
set target_library   "slow.db"
set link_library     "* $target_library dw_foundation.sldb"
set symbol_library   "generic.sdb"
set synthetic_library "dw_foundation.sldb"

set hdlin_translate_off_skip_text "TRUE"
set edifout_netlist_only "TRUE"
set verilogout_no_tri true

set hdlin_enable_presto_for_vhdl "TRUE"
set sh_enable_line_editing true
set sh_line_editing_mode emacs
history keep 100
alias h history

set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
define_name_rules name_rule -allowed {a-z A-Z 0-9 _} -max_length 255 -type cell
define_name_rules name_rule -allowed {a-z A-Z 0-9 _[]} -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}


#Read All Files
read_file -format verilog  LASER.v
#read_file -format sverilog  LASER.v
current_design LASER
link

#Setting Clock Constraints
source -echo -verbose LASER.sdc
check_design
set high_fanout_net_threshold 0
uniquify
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]
#set_max_area 0
#Synthesis all design
#compile -map_effort high -area_effort high
#compile -map_effort high -area_effort high -inc
compile_ultra

write -format ddc     -hierarchy -output "Netlist/LASER_syn.ddc"
write_sdf -version 1.0  "Netlist/LASER_syn.sdf"
write -format verilog -hierarchy -output "Netlist/LASER_syn.v"  
report_area > "Report/area.log"
report_timing > "Report/timing.log"
report_qor   >  "Report/LASER_syn.qor"

# Additional reporting commands can be added here if needed
# For example: report_power > "Report/power.log"
# report_power > "Report/power.log"  # Un-commenting to enable power report
# Further optimize settings before exit if applicable

# Optionally add any additional optimizations or reports
# Consider verifying and adjusting other settings as needed

exit
