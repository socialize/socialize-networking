.PHONY: test clean framework package

PROJECT_VERSION=$(shell cat version)
RELEASE_ZIP=socialize-api-client-ios-$(PROJECT_VERSION).zip
API_TARGET=SocializeAPIClient
FRAMEWORK_NAME=$(API_TARGET).framework
CHECK_FRAMEWORK_DIR=build/check-framework-dir

default: release

-include subst.mk

test: subst
	GHUNIT_CLI=1 WRITE_JUNIT_XML=YES RUN_CLI=1 JUNIT_XML_DIR="build/test-results" xcodebuild -scheme 'SocializeAPIClient Tests' -configuration Debug -sdk iphonesimulator

clean: clean-subst
	xcodebuild -scheme 'SocializeAPIClient Tests' -configuration Debug -sdk iphonesimulator clean
	rm -rfd build

framework:
	BUILD_FRAMEWORK=1 xcodebuild -scheme "$(API_TARGET)" -configuration Release

release: framework
	cd build && rm -f ${RELEASE_ZIP} && zip -r $(RELEASE_ZIP) $(FRAMEWORK_NAME)
