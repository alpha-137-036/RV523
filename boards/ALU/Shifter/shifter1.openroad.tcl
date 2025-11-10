read_lef ../../../lib/RV523_tech.lef
read_lef ../../../lib/RV523_cells.lef
read_liberty ../../../lib/RV523.lib
read_verilog shifter1.netlist.v

link_design shifter1

puts "Generate shifter1.floorplan.def"
exec python3 generate_shifter1_floorplan.py > shifter1.floorplan.def

read_def -floorplan_initialize shifter1.floorplan.def

# For some reason place_pin crashes. 
# Fortunately, the fixed pin locations in the .DEF file works


#place_endcaps -endcap DECAP 

# abuse command tapcell to also insert DECAP as if they were tap cells
#tapcell -endcap DECAP -tapcell_master DECAP -distance 60

#initialize_floorplan -die_area "0 0 100 100 " -core_area "0 0 50 70.4" -site CoreSite 
global_placement -density 0.9 -routability_driven
set max_placement_iters 100
set iter 0
while {$iter < $max_placement_iters} {
    incr iter
    improve_placement -random_seed $iter
}
set max_improve_iters 100
set iter 0
detailed_placement
detailed_placement
detailed_placement
detailed_placement
detailed_placement
while {$iter < $max_improve_iters} {
    incr iter
    improve_placement -random_seed $iter
}

write_def shifter1.placed.def

puts "Write shifter1.placed.csv"
set csv [open "shifter1.placed.csv" w]
puts $csv "ref,x,y"

foreach cell [[[[ord::get_db] getChip] getBlock] getInsts] {
    set name [$cell getName]
    set x [expr {[[$cell getBBox] xMin] / 1000}]
    set y [[$cell getBBox] yMin]
    set kicadY [expr {(100000 - 4000 - $y) / 1000}]
    puts $csv "sh1.$name,$x,$kicadY"
}
close $csv
