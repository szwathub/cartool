CARTOOL_DIR = $(shell cd $(shell dirname "$0"); pwd)
BINARY = cartool
REVISION = $(shell git --git-dir="${CARTOOL_DIR}/.git" log -n 1 --format=%h 2> /dev/null || echo ".")
XCODEBUILD_VERSION = $(shell expr "$(shell xcodebuild -version)" : '^.*Build version \(.*\)')
BUILD_OUTPUT_DIR = $(CARTOOL_DIR)/build/$(REVISION)/$(XCODEBUILD_VERSION)
CARTOOL_PATH = $(BUILD_OUTPUT_DIR)/Products/Release/$(BINARY)

.PHONY: build
build:
	@xcodebuild \
      -project $(CARTOOL_DIR)/cartool.xcodeproj \
      -scheme $(BINARY) \
      -configuration Release \
      -IDEBuildLocationStyle=Custom \
      -IDECustomBuildLocationType=Absolute \
      -IDECustomBuildProductsPath=$(BUILD_OUTPUT_DIR)/Products \
      -IDECustomBuildIntermediatesPath=$(BUILD_OUTPUT_DIR)/Intermediates

clean:
	rm -rf $(CARTOOL_DIR)/build

install: build
	mkdir -p $(PREFIX)/bin
	cp $(CARTOOL_PATH) $(PREFIX)/bin/$(BINARY)
