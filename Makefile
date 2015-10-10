MKDIR := mkdir --parents
UNIX2DOS := unix2dos --quiet --newfile -1252
RM := rm --recursive --force
CP := cp --force
ZIP := zip --to-crlf --verbose --recurse-paths
LUA := lua
BUSTED := busted --coverage
LUACOV := luacov --config .luacov
LUACOV_REPORT := luacov.report.out

ADDON_NAME := esoTERM
ADDON_DESCRIPTION := https://github.com/crashmaster/esoTERM
ADDON_TEXT_FILE := $(ADDON_NAME).txt
ESO_API_VERSION := 100012
ADDON_SAVED_VARIABLES := esoTERM_settings

USER_DOCUMENTS_DIR := C:/Users/$(USER)/Documents
ESO_ADDONS_DIR := $(USER_DOCUMENTS_DIR)/Elder\ Scrolls\ Online/liveeu/AddOns
ESO_TERM_DIR := $(ESO_ADDONS_DIR)/$(ADDON_NAME)

THIS_FILE := $(abspath $(lastword $(MAKEFILE_LIST)))
REPO_DIR := $(patsubst %/,%,$(dir $(THIS_FILE)))
TESTS_DIR := $(REPO_DIR)/tests
TEST_FILE_PATTERN := test_
RUN_TESTS := $(BUSTED) --pattern=$(TEST_FILE_PATTERN) $(TESTS_DIR)
TOOLS_DIR := $(REPO_DIR)/tools
LUACOV_PARSER := $(TOOLS_DIR)/parse_luacov_report.lua
SOURCES := $(foreach dir,$(REPO_DIR),$(wildcard $(dir)/$(ADDON_NAME)*))
BUILD_DIR := $(REPO_DIR)/build
BUILD_PKG_DIR := $(BUILD_DIR)/$(ADDON_NAME)
PKG_NAME := $(ADDON_NAME)_$(shell date --iso-8601).zip


.PHONY: all test test_silent gentxt install uninstall build

all: test coverage

test:
	@$(RUN_TESTS)

test_silent:
	@$(RUN_TESTS) > /dev/null

coverage: test_silent
	@$(LUACOV)
	@$(LUA) $(LUACOV_PARSER) $(LUACOV_REPORT)
	@$(RM) $(LUACOV_REPORT)

gentxt:
	@$(RM) $(ADDON_TEXT_FILE)
	@printf "## Title: %s\n" $(ADDON_NAME) > $(ADDON_TEXT_FILE)
	@printf "## Description: %s\n" $(ADDON_DESCRIPTION) > $(ADDON_TEXT_FILE)
	@printf "## APIVersion: %s\n" $(ESO_API_VERSION) >> $(ADDON_TEXT_FILE)
	@printf "## SavedVariables: %s\n\n" $(ADDON_SAVED_VARIABLES) >> $(ADDON_TEXT_FILE)
	@ls $(ADDON_NAME)*.lua >> $(ADDON_TEXT_FILE)

install: gentxt
	@$(MKDIR) $(ESO_TERM_DIR)
	@$(foreach file,$(SOURCES),$(UNIX2DOS) $(file) $(addprefix $(ESO_TERM_DIR)/,$(notdir $(file))) || exit $?;)
	@printf "%s installed to:\n%s\n" $(ADDON_NAME) $(ESO_TERM_DIR)

uninstall:
	@$(RM) $(ESO_TERM_DIR)
	@printf "%s uninstalled from:\n%s\n" $(ADDON_NAME) $(ESO_TERM_DIR)

build: gentxt
	@$(RM) $(BUILD_DIR)
	@$(MKDIR) $(BUILD_PKG_DIR)
	@$(CP) $(SOURCES) $(BUILD_PKG_DIR)
	@cd $(BUILD_DIR) && $(ZIP) $(PKG_NAME) $(ADDON_NAME)
	@$(RM) $(BUILD_PKG_DIR)
	@ls $(BUILD_DIR)/$(PKG_NAME)
