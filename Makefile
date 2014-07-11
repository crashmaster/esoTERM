MKDIR := mkdir -p
UNIX2DOS := unix2dos --quiet --newfile -1252
RM := rm -rf
BUSTED := $(shell which busted)

USER_DOCUMENTS_DIR := C:/Users/$(USER)/Documents
ESO_ADDONS_DIR := $(USER_DOCUMENTS_DIR)/Elder\ Scrolls\ Online/liveeu/AddOns
PINFO_DIR := $(ESO_ADDONS_DIR)/pinfo

THIS_FILE := $(abspath $(lastword $(MAKEFILE_LIST)))
REPO_DIR := $(patsubst %/,%,$(dir $(THIS_FILE)))
TESTS := $(foreach dir,$(REPO_DIR),$(wildcard $(dir)/test_*.lua))
SOURCES := $(foreach dir,$(REPO_DIR),$(wildcard $(dir)/pinfo*))


.PHONY: all test install uninstall

all: test

test:
	@$(foreach file,$(TESTS),printf "%s:" $(notdir $(file)) && $(BUSTED) $(file) || exit $?;)

install:
	@$(MKDIR) $(PINFO_DIR)
	@$(foreach file,$(SOURCES),$(UNIX2DOS) "$(file)" "$(addprefix $(PINFO_DIR)/,$(notdir $(file)))" || exit $?;)
	@printf "pinfo installed to:\n%s\n" $(PINFO_DIR)

uninstall:
	@$(RM) $(PINFO_DIR)
	@printf "pinfo uninstalled from:\n%s\n" $(PINFO_DIR)
