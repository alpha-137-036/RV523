import sys
import os

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(parent_dir)

import generate_pwl_generic

generate_pwl_generic.generate_pwl("pwl_Inputs.sp", ["A", "B", "C", "D"])