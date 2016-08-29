THIS_FILE := $(abspath $(lastword $(MAKEFILE_LIST)))
REPO_DIR_LOCAL := $(patsubst %/,%,$(dir $(THIS_FILE)))

MKDIR := mkdir --parents
UNIX2DOS := unix2dos --quiet --newfile -1252
RM := rm --recursive --force
CP := cp --force
ZIP := zip --to-crlf --verbose --recurse-paths
LUA := lua
BUSTED := busted --verbose --coverage
LUACOV := luacov --config .luacov
LUACOV_REPORT := luacov.report.out

ADDON_NAME := esoTERM
ADDON_DESCRIPTION := https://github.com/crashmaster/esoTERM
ADDON_TXT_FILE := $(ADDON_NAME).txt
ESO_API_VERSION := 100014
ADDON_SAVED_VARIABLES := esoTERM_settings

USER_DOCUMENTS_DIR := C:/Users/$(USER)/Documents
ESO_ADDONS_DIR := $(USER_DOCUMENTS_DIR)/Elder\ Scrolls\ Online/liveeu/AddOns
ESO_TERM_DIR := $(ESO_ADDONS_DIR)/$(ADDON_NAME)

SOURCES := $(foreach dir,$(REPO_DIR_LOCAL),$(wildcard $(dir)/$(ADDON_NAME)*))
BUILD_DIR := $(REPO_DIR_LOCAL)/build
BUILD_PKG_DIR := $(BUILD_DIR)/$(ADDON_NAME)
PKG_NAME := $(ADDON_NAME)_$(shell date --iso-8601).zip

DOCKER := /usr/bin/docker
DOCKER_TAG := eso_term
DOCKER_CONFIG_PATH := $(REPO_DIR_LOCAL)/.
DOCKER_VOLUME := --volume=$(REPO_DIR_LOCAL):/$(DOCKER_TAG)
DOCKER_OPTS := --tty --interactive
DOCKER_BUILD := $(DOCKER) build --tag=$(DOCKER_TAG) $(DOCKER_CONFIG_PATH)
DOCKER_RUN := docker run $(DOCKER_VOLUME) $(DOCKER_OPTS) $(DOCKER_TAG)

REPO_DIR_DOCKER = /$(DOCKER_TAG)

TESTS_DIR := tests
TEST_FILE_PATTERN := test_

TOOLS_DIR := $(REPO_DIR_DOCKER)/tools
LUACOV_PARSER := $(TOOLS_DIR)/parse_luacov_report.lua

CALL_TEST := sh -c "cd $(REPO_DIR_DOCKER) && $(BUSTED) --pattern=$(TEST_FILE_PATTERN) $(TESTS_DIR)"
CALL_COVERAGE := sh -c "cd $(REPO_DIR_DOCKER) && $(LUACOV) && $(LUA) $(LUACOV_PARSER) $(LUACOV_REPORT); $(RM) $(LUACOV_REPORT)"

.PHONY: all test test_silent generate_addon_txt_file install uninstall build docker_build

all: test coverage

debug_docker: docker_build
	@$(DOCKER_RUN) bash

test: docker_build
	@$(DOCKER_RUN) $(CALL_TEST)

test_silent:
	@$(DOCKER_RUN) $(CALL_TEST) > /dev/null

coverage:
	@$(DOCKER_RUN) $(CALL_COVERAGE)

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

docker_build:
	@$(DOCKER_BUILD)
