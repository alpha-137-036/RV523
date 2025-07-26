for y in */*.ys; do (cd $(dirname $y) && yosys $(basename $y) ) ; done
