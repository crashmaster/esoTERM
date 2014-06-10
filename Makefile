MKDIR := mkdir -p
UNIX2DOS := unix2dos --quiet --newfile
RM := rm -rf

USER_DOCUMENTS_DIR := C:/Users/$(USER)/Documents
ESO_ADDONS_DIR := $(USER_DOCUMENTS_DIR)/Elder\ Scrolls\ Online/liveeu/AddOns
PINFO_DIR := $(ESO_ADDONS_DIR)/pinfo_dev
REPO_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

.PHONY: all test install uninstall

all: test

test:
	@echo "Test unit test helper:"
	@/usr/local/bin/busted $(REPO_DIR)/test_ut_helper.lua
	@echo "Test pinfo:"
	@/usr/local/bin/busted $(REPO_DIR)/test_pinfo.lua

install:
	@$(MKDIR) $(PINFO_DIR)
	@$(UNIX2DOS) $(REPO_DIR)/pinfo.txt $(PINFO_DIR)/pinfo.txt
	@$(UNIX2DOS) $(REPO_DIR)/pinfo.lua $(PINFO_DIR)/pinfo.lua
	@echo "pinfo installed to:"
	@echo $(PINFO_DIR)

uninstall:
	@$(RM) $(PINFO_DIR)
	@echo "pinfo uninstalled from:"
	@echo $(PINFO_DIR)
