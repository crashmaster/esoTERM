# Variables: level 1
ADDON_NAME := esoTERM
BUSTED := busted --verbose --coverage
CP := cp --force
DOCKER := /usr/bin/docker
DOCKER_OPTS := --tty --interactive
ESO_API_VERSION := 100019
LUA := lua
LUACOV := luacov --config .luacov
LUACOV_REPORT := luacov.report.out
MKDIR := mkdir --parents
RM := rm --recursive --force
TESTS_DIR := tests
TEST_FILE_PATTERN := test_
THIS_FILE := $(abspath $(lastword $(MAKEFILE_LIST)))
UNIX2DOS := unix2dos --quiet --newfile -1252
USER_DOCUMENTS_DIR := C:/Users/$(USER)/Documents
ZIP := zip --to-crlf --verbose --recurse-paths

# Variables: level 2
ADDON_DESCRIPTION := https://github.com/crashmaster/$(ADDON_NAME)
ADDON_SAVED_VARIABLES := $(ADDON_NAME)_settings
ADDON_TXT_FILE := $(ADDON_NAME).txt
DOCKER_TAG := $(shell echo $(ADDON_NAME) | tr '[:upper:]' '[:lower:]')
ESO_ADDONS_DIR := $(USER_DOCUMENTS_DIR)/Elder\ Scrolls\ Online/liveeu/AddOns
PKG_NAME := $(ADDON_NAME)_$(shell date --iso-8601).zip
REPO_DIR_DOCKER = /$(ADDON_NAME)
REPO_DIR_LOCAL := $(patsubst %/,%,$(dir $(THIS_FILE)))

# Variables: level 3
BUILD_DIR := $(REPO_DIR_LOCAL)/build
TEST_COMMAND := cd $(REPO_DIR_DOCKER) && $(BUSTED) --pattern=$(TEST_FILE_PATTERN) $(TESTS_DIR)
CALL_TEST := sh -c "$(TEST_COMMAND)"
DOCKER_CONFIG_PATH := $(REPO_DIR_LOCAL)/.
DOCKER_VOLUME := --volume=$(REPO_DIR_LOCAL):/$(ADDON_NAME)
ESO_TERM_DIR := $(ESO_ADDONS_DIR)/$(ADDON_NAME)
SOURCES := $(foreach dir,$(REPO_DIR_LOCAL),$(wildcard $(dir)/$(ADDON_NAME)*))
TOOLS_DIR := $(REPO_DIR_DOCKER)/tools

# Variables: level 4
BUILD_PKG_DIR := $(BUILD_DIR)/$(ADDON_NAME)
DOCKER_BUILD := $(DOCKER) build --tag=$(DOCKER_TAG) $(DOCKER_CONFIG_PATH)
DOCKER_RUN := docker run $(DOCKER_VOLUME) $(DOCKER_OPTS) $(DOCKER_TAG)
LUACOV_PARSER := $(TOOLS_DIR)/parse_luacov_report.lua

# Variables: level 5
COVERAGE_COMMAND := cd $(REPO_DIR_DOCKER) && $(LUACOV) && $(LUA) $(LUACOV_PARSER) $(LUACOV_REPORT); $(RM) $(LUACOV_REPORT)
TEST_AND_COVERAGE_COMMAND := $(TEST_COMMAND) && echo && $(COVERAGE_COMMAND)
CALL_TEST_AND_COVERAGE := sh -c "$(TEST_AND_COVERAGE_COMMAND)"

all: test_and_coverage

docker_build:
	@$(DOCKER_BUILD)

docker_shell: docker_build
	@$(DOCKER_RUN) bash

test: docker_build
	@$(DOCKER_RUN) $(CALL_TEST)

test_silent: docker_build
	@$(DOCKER_RUN) $(CALL_TEST) > /dev/null 2>&1

test_and_coverage: docker_build
	$(DOCKER_RUN) $(CALL_TEST_AND_COVERAGE)

generate_addon_txt_file:
	@$(RM) $(ADDON_TXT_FILE)
	@printf "## Title: %s\n" $(ADDON_NAME) > $(ADDON_TXT_FILE)
	@printf "## Description: %s\n" $(ADDON_DESCRIPTION) > $(ADDON_TXT_FILE)
	@printf "## APIVersion: %s\n" $(ESO_API_VERSION) >> $(ADDON_TXT_FILE)
	@printf "## SavedVariables: %s\n\n" $(ADDON_SAVED_VARIABLES) >> $(ADDON_TXT_FILE)
	@ls $(ADDON_NAME)*.lua >> $(ADDON_TXT_FILE)

install: generate_addon_txt_file
	@$(MKDIR) $(ESO_TERM_DIR)
	@$(foreach file,$(SOURCES),$(UNIX2DOS) $(file) $(addprefix $(ESO_TERM_DIR)/,$(notdir $(file))) || exit $?;)
	@printf "%s installed to:\n%s\n" $(ADDON_NAME) $(ESO_TERM_DIR)

uninstall:
	@$(RM) $(ESO_TERM_DIR)
	@printf "%s uninstalled from:\n%s\n" $(ADDON_NAME) $(ESO_TERM_DIR)

build: generate_addon_txt_file
	@$(RM) $(BUILD_DIR)
	@$(MKDIR) $(BUILD_PKG_DIR)
	@$(CP) $(SOURCES) $(BUILD_PKG_DIR)
	@cd $(BUILD_DIR) && $(ZIP) $(PKG_NAME) $(ADDON_NAME)
	@$(RM) $(BUILD_PKG_DIR)
	@ls $(BUILD_DIR)/$(PKG_NAME)

.PHONY: \
	all \
	build \
	docker_build \
	docker_shell \
	generate_addon_txt_file \
	install \
	test \
	test_and_coverage \
	test_silent \
	uninstall
