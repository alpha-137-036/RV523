read_lef ../../lib/RV523_tech.lef
read_lef ../../lib/RV523_cells.lef
read_liberty ../../lib/RV523.lib
read_verilog comparator.netlist.v
link_design comparator

read_def -floorplan_initialize comparator_floorplan.def

# For some reason place_pin crashes. 
# Fortunately, the fixed pin locations in the .DEF file works


#initialize_floorplan -die_area "0 0 100 100 " -core_area "0 0 50 70.4" -site CoreSite 
global_placement -density 1 -routability_driven
detailed_placement -disallow_one_site_gaps 
improve_placement -random_seed 1234
improve_placement -random_seed 6666
improve_placement -random_seed 9999

write_def comparator_placed.def
