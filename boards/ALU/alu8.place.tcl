read_lef ../../lib/RV523_tech.lef
read_lef ../../lib/RV523_cells.lef
read_liberty ../../lib/RV523.lib
read_verilog alu8.netlist.v
link_design adder

read_def -floorplan_initialize alu8_floorplan.def

# For some reason place_pin crashes. 
# Fortunately, the fixed pin locations in the .DEF file works


#initialize_floorplan -die_area "0 0 100 100 " -core_area "0 0 50 70.4" -site CoreSite 
global_placement -density 1 -routability_driven
detailed_placement

write_def alu8_top_placed.def
