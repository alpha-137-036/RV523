read_lef ../../../lib/RV523_tech.lef
read_lef ../../../lib/RV523_cells.lef
read_liberty ../../../lib/RV523.lib
read_verilog shifter1.netlist.v
link_design shifter1

read_def -floorplan_initialize shifter1_floorplan.def

# For some reason place_pin crashes. 
# Fortunately, the fixed pin locations in the .DEF file works


#initialize_floorplan -die_area "0 0 100 100 " -core_area "0 0 50 70.4" -site CoreSite 
global_placement -density 0.85 -routability_driven
detailed_placement -disallow_one_site_gaps 
improve_placement -random_seed 1234
improve_placement -random_seed 6666
improve_placement -random_seed 9999
improve_placement -random_seed 8888
improve_placement -random_seed 7777
improve_placement -random_seed 4444
improve_placement -random_seed 2222
improve_placement -random_seed 1111
improve_placement -random_seed 9876
improve_placement -random_seed 911

write_def shifter1_placed.def

#pin_access -via_in_pin_bottom_layer M1

#global_route -verbose
#detailed_route  -via_in_pin_bottom_layer M1
