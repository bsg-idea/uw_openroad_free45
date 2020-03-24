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

# Skip sv2v because our files are already well formed
SV2V_SKIP    := true
PICKLED_V    := $(DESIGN_DIR)/gcd.v
PICKLED_SDC  := $(DESIGN_DIR)/constraints.sdc

# Floorplan parameters
FP_ASPECT_RATIO := 1.0
FP_UTILIZATION  := 0.10
FP_CORE_SPACE   := 0.0

