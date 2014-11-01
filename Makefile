MKDIR := mkdir -p
UNIX2DOS := unix2dos --quiet --newfile -1252
RM := rm -rf
CP := cp -f
ZIP := zip --to-crlf --verbose --recurse-paths
LUA := lua
BUSTED := busted --coverage
LUACOV := luacov --config .luacov
LUACOV_REPORT := luacov.report.out

ADDON_NAME := esoTERM
USER_DOCUMENTS_DIR := C:/Users/$(USER)/Documents
ESO_ADDONS_DIR := $(USER_DOCUMENTS_DIR)/Elder\ Scrolls\ Online/liveeu/AddOns
ESO_TERM_DIR := $(ESO_ADDONS_DIR)/$(ADDON_NAME)

THIS_FILE := $(abspath $(lastword $(MAKEFILE_LIST)))
REPO_DIR := $(patsubst %/,%,$(dir $(THIS_FILE)))
TESTS_DIR := $(REPO_DIR)/tests
TOOLS_DIR := $(REPO_DIR)/tools
LUACOV_PARSER := $(TOOLS_DIR)/parse_luacov_report.lua
TESTS := $(foreach dir,$(TESTS_DIR),$(wildcard $(dir)/test_*.lua))
SOURCES := $(foreach dir,$(REPO_DIR),$(wildcard $(dir)/$(ADDON_NAME)*))
BUILD_DIR := $(REPO_DIR)/build
BUILD_PKG_DIR := $(BUILD_DIR)/$(ADDON_NAME)
PKG_NAME := $(ADDON_NAME)_$(shell date --iso-8601).zip


.PHONY: all test install uninstall build

all: test coverage

test:
	@$(foreach file,$(TESTS),printf "%s:" $(notdir $(file)) && $(BUSTED) $(file) || exit $?;)

coverage: test
	@$(LUACOV)
	@$(LUA) $(LUACOV_PARSER) $(LUACOV_REPORT)
	@$(RM) $(LUACOV_REPORT)

install:
	@$(MKDIR) $(ESO_TERM_DIR)
	@$(foreach file,$(SOURCES),$(UNIX2DOS) $(file) $(addprefix $(ESO_TERM_DIR)/,$(notdir $(file))) || exit $?;)
	@printf "%s installed to:\n%s\n" $(ADDON_NAME) $(ESO_TERM_DIR)

uninstall:
	@$(RM) $(ESO_TERM_DIR)
	@printf "%s uninstalled from:\n%s\n" $(ADDON_NAME) $(ESO_TERM_DIR)

build:
	@$(RM) $(BUILD_DIR)
	@$(MKDIR) $(BUILD_PKG_DIR)
	@$(CP) $(SOURCES) $(BUILD_PKG_DIR)
	@cd $(BUILD_DIR) && $(ZIP) $(PKG_NAME) $(ADDON_NAME)
	@$(RM) $(BUILD_PKG_DIR)
	@ls $(BUILD_DIR)/$(PKG_NAME)
