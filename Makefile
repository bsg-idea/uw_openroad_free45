export TOP_DIR :=$(shell git rev-parse --show-toplevel)

##==============================================================================
##  _   ___      __   ___                 ___  ___   _   ___    ___ _            
## | | | \ \    / /  / _ \ _ __  ___ _ _ | _ \/ _ \ /_\ |   \  | __| |_____ __ __
## | |_| |\ \/\/ /  | (_) | '_ \/ -_) ' \|   / (_) / _ \| |) | | _|| / _ \ V  V /
##  \___/  \_/\_/    \___/| .__/\___|_||_|_|_\\___/_/ \_\___/  |_| |_\___/\_/\_/ 
##                        |_|                                                    
##==============================================================================

export PREP_DIR    := $(CURDIR)/flow_prep
export BUILD_DIR   := $(CURDIR)/current_build

export PREP_VPATH  := $(PREP_DIR)/touchfiles
export BUILD_VPATH := $(BUILD_DIR)/touchfiles
export VPATH       := $(PREP_VPATH) $(BUILD_VPATH)

.DEFAULT_GOAL := finish

include $(TOP_DIR)/Makefile.setup
include $(TOP_DIR)/cad/Makefile.include

export DESIGN_NAME

#=======================================
# Build setup
#=======================================

DATE := $(shell date "+%Y_%m_%d_%H_%M_%S")

new_build:
	@## Start a new build. The new build directory will be called build.<date>
	@## and the 'current_build' link will be updated to this new build.
	-rm $(BUILD_DIR)
	$(MAKE) build_setup

build_setup: | prep
	@# Intentionally left undocumented
	mkdir -p build.$(DATE)
	ln -nsf build.$(DATE) $(BUILD_DIR)
	mkdir -p $(BUILD_VPATH)
	touch $(BUILD_VPATH)/$@

rename_build.%:
	@## Rename the current build. Replace '%' with the new name of the build. All
	@## build directories have the format 'build.<name>'.
	$(eval RAW_BUILD_DIR=$(shell cd $(BUILD_DIR); pwd -P))
	mv $(RAW_BUILD_DIR) build.$*
	ln -nsf build.$* $(BUILD_DIR)

link_build.%:
	@## Change the 'current_build' link pointer to the build with the given name.
	@## Replace '%' with the name of the build that you want to reactivate.
	@[ -d build.$* ] || (echo "Error: build.$* does not exist!" && false)
	ln -nsf build.$* $(BUILD_DIR)

#=======================================
# Misc. targets
#=======================================

where_am_i:
	@## Print the last build target that finished successfully.
	@ls -1t $(BUILD_VPATH) | head -1

what_is_left:
	@## Print all the targets left to run before the chip is finished.
	@make -nd 2>/dev/null | grep remade | sed -e 's/^\s*//g' | cut -d ' ' -f 5 | cut -c2- | rev | cut -c3- | rev

what_is_next:
	@## Print the next target to run to move towards the finished chip.
	@make -nd 2>/dev/null | grep remade | sed -e 's/^\s*//g' | cut -d ' ' -f 5 | cut -c2- | rev | cut -c3- | rev | head -1

next_step:
	@## Run the target that is next in line.
	make $(shell make what_is_next)

echo.%:
	@## Print the value of the specified variable. Replace '%' with the name of
	@## the variable you want to print.
	@echo $*=$($*)

DISABLE_SAFETY_PROMPT ?= false
are_you_sure:
	@## This target is used as a dependancy to prompt the user for a yes/no
	@## response because the target they are running is "dangerous". The user is
	@## not expected to ever run this target directly (doesn't really do
	@## anything...). You can disable this prompt by either setting
	@## DISABLE_SAFETY_PROMPT=true or by touching the file 'are_you_sure' in the
	@## repos root dir.
	@$(DISABLE_SAFETY_PROMPT) || (echo -n "Are you sure [Y/n]? " && read ans && ([ "$$ans" == "Y" ] || [ "$$ans" == "y" ]))

#=======================================
# Help targets
#=======================================

help: $(addsuffix .help,$(MAKEFILE_LIST))
	@## Print information about all of the targets in this makefile
	@## infrastructure. Only targets with documentation are printed out.
	@## This means that some targets might not be listed. These targets are
	@## either undocumented or intentionally left out because the user should not
	@## execute those targets directly.

help.main: $(TOP_DIR)/Makefile.help
	@## Print information about makefile targets in this file.

help.prep: help.%: $(TOP_DIR)/cad/flow/%/Makefile.include.help
	@## Print information about prep makefile targets.

help.fakeram: help.%: $(TOP_DIR)/cad/flow/%/Makefile.include.help
	@## Print information about fakeram makefile targets.

help.pdkmod: help.%: $(TOP_DIR)/cad/flow/%/Makefile.include.help
	@## Print information about pdkmod makefile targets.

help.sv2v: help.%: $(TOP_DIR)/cad/flow/%/Makefile.include.help
	@## Print information about sv2v makefile targets.

help.synth: help.%: $(TOP_DIR)/cad/flow/%/Makefile.include.help
	@## Print information about synth makefile targets.

help.pnr: help.%: $(TOP_DIR)/cad/flow/%/Makefile.include.help
	@## Print information about pnr makefile targets.

help.drc_lvs: help.%: $(TOP_DIR)/cad/flow/%/Makefile.include.help
	@## Print information about drc_lvs makefile targets.

help.viewer: help.%: $(TOP_DIR)/cad/flow/%/Makefile.include.help
	@## Print information about viewer makefile targets.

%.help:
	@# Intentionally left undocumented
	@egrep -h '^##' $* || true
	@egrep -B1 -h '^\s*@##' $* | sed -e 's/@##\s*//g' | sed -e 's/:.*$$/:/g' || true

or:
	openroad

