USER_DOCUMENTS_DIR := C:/Users/$(USER)/Documents
ESO_ADDONS_DIR := $(USER_DOCUMENTS_DIR)/Elder\ Scrolls\ Online/liveeu/AddOns

.PHONY: all
all:
	@/usr/local/bin/busted ./test_pinfo.lua

.PHONY: install
install:
	@ls $(ESO_ADDONS_DIR)
