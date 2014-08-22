MKDIR := mkdir -p
UNIX2DOS := unix2dos --quiet --newfile -1252
RM := rm -rf
CP := cp -f
ZIP := zip --to-crlf --verbose --recurse-paths
BUSTED := busted --coverage
LUACOV := luacov --config .luacov

ADDON_NAME := pinfo
USER_DOCUMENTS_DIR := C:/Users/$(USER)/Documents
ESO_ADDONS_DIR := $(USER_DOCUMENTS_DIR)/Elder\ Scrolls\ Online/liveeu/AddOns
PINFO_DIR := $(ESO_ADDONS_DIR)/$(ADDON_NAME)

THIS_FILE := $(abspath $(lastword $(MAKEFILE_LIST)))
REPO_DIR := $(patsubst %/,%,$(dir $(THIS_FILE)))
TESTS := $(foreach dir,$(REPO_DIR),$(wildcard $(dir)/test_*.lua))
SOURCES := $(foreach dir,$(REPO_DIR),$(wildcard $(dir)/pinfo*))
BUILD_DIR := $(REPO_DIR)/build
BUILD_PKG_DIR := $(BUILD_DIR)/$(ADDON_NAME)
PKG_NAME := $(ADDON_NAME)_$(shell date --iso-8601).zip


.PHONY: all test install uninstall build

all: test

test:
	@$(foreach file,$(TESTS),printf "%s:" $(notdir $(file)) && $(BUSTED) $(file) || exit $?;)
	@echo
	@$(LUACOV) && sed -n '/Summary/,$$p' luacov.report.out && rm ./luacov.report.out

install:
	@$(MKDIR) $(PINFO_DIR)
	@$(foreach file,$(SOURCES),$(UNIX2DOS) $(file) $(addprefix $(PINFO_DIR)/,$(notdir $(file))) || exit $?;)
	@printf "pinfo installed to:\n%s\n" $(PINFO_DIR)

uninstall:
	@$(RM) $(PINFO_DIR)
	@printf "pinfo uninstalled from:\n%s\n" $(PINFO_DIR)

build:
	@$(RM) $(BUILD_DIR)
	@$(MKDIR) $(BUILD_PKG_DIR)
	@$(CP) $(SOURCES) $(BUILD_PKG_DIR)
	@cd $(BUILD_DIR) && $(ZIP) $(PKG_NAME) $(ADDON_NAME)
	@$(RM) $(BUILD_PKG_DIR)
	@ls $(BUILD_DIR)/$(PKG_NAME)
