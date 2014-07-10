MKDIR := mkdir -p
UNIX2DOS := unix2dos --quiet --newfile -1252
RM := rm -rf
BUSTED := $(shell which busted)

USER_DOCUMENTS_DIR := C:/Users/$(USER)/Documents
ESO_ADDONS_DIR := $(USER_DOCUMENTS_DIR)/Elder\ Scrolls\ Online/liveeu/AddOns
PINFO_DIR := $(ESO_ADDONS_DIR)/pinfo
REPO_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
UNIT_TESTS := $(shell find $(REPO_DIR) -name "test_*.lua")

.PHONY: all test install uninstall test2

all: test

test:
	@for test in $(UNIT_TESTS); do \
		printf "%s:" $$test; \
		$(BUSTED) $$test; \
	done

install:
	@$(MKDIR) $(PINFO_DIR)
	@$(UNIX2DOS) $(REPO_DIR)/pinfo.txt $(PINFO_DIR)/pinfo.txt
	@$(UNIX2DOS) $(REPO_DIR)/pinfo.lua $(PINFO_DIR)/pinfo.lua
	@$(UNIX2DOS) $(REPO_DIR)/pinfo_char.lua $(PINFO_DIR)/pinfo_char.lua
	@$(UNIX2DOS) $(REPO_DIR)/pinfo_event_handler.lua $(PINFO_DIR)/pinfo_event_handler.lua
	@$(UNIX2DOS) $(REPO_DIR)/pinfo_init.lua $(PINFO_DIR)/pinfo_init.lua
	@$(UNIX2DOS) $(REPO_DIR)/pinfo_output.lua $(PINFO_DIR)/pinfo_output.lua
	@printf "pinfo installed to:\n"
	@printf "%s\n" $(PINFO_DIR)

uninstall:
	@$(RM) $(PINFO_DIR)
	@printf "pinfo uninstalled from:\n"
	@printf "%s\n" $(PINFO_DIR)
