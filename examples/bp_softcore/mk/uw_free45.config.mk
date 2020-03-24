#===============================================================================
# UW OPENROAD FREE45 CONFIGURATION FILE
# -------------------------------------
# This file contains variables to setup and tweak the performance of the cad
# flow that are specific to the design.
#===============================================================================

# Name of the toplevel module
DESIGN_NAME := bp_softcore_top

# File for the fakeram configuration (blank is acceptable)
FAKERAM_CONFIG := $(DESIGN_DIR)/cfg/fakeram45.cfg

# Floorplan parameters
FP_ASPECT_RATIO := 1.0
FP_UTILIZATION  := 0.20
FP_CORE_SPACE   := 0.0

# Placement Density Control
PLACEMENT_DENSITY := 0.40

#===============================================================================
# Design Specific Makefile Splicing

# Paths used in design tcl scripts
export BLACKPARROT_DIR  := $(DESIGN_DIR)/imports/black-parrot
export BASEJUMP_STL_DIR := $(BLACKPARROT_DIR)/external/basejump_stl

# Add the repo checkouts to the prep targets
prep: $(DESIGN_DIR)/imports/black-parrot

# Checkout the black-parrot repo
$(DESIGN_DIR)/imports/black-parrot:
	mkdir -p $(@D)
	git clone https://github.com/black-parrot/black-parrot.git $@
	cd $@ && git checkout c7f47ef
	cd $@ && git submodule update --init external/basejump_stl

