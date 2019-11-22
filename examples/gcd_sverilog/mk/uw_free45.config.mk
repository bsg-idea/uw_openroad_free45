#===============================================================================
# UW OPENROAD FREE45 CONFIGURATION FILE
# -------------------------------------
# This file contains variables to setup and tweak the performance of the cad
# flow that are specific to the design.
#===============================================================================

# Name of the toplevel module
DESIGN_NAME := gcd

# File for the fakeram configuration (blank is acceptable)
FAKERAM_CONFIG :=

# Floorplan parameters
FP_ASPECT_RATIO := 1.0
FP_UTILIZATION  := 50.0
FP_CORE_SPACE   := 0.0

# Skip macro placement?
# For this design, there are no macros, so we should skip macro placement.
FP_MACRO_SKIP := true

# PDN currently not supported, come back soon!
FP_PDN_SKIP := true

