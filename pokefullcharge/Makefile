ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PokeFullCharge
PokeFullCharge_FILES = PFCRootListController.m
PokeFullCharge_INSTALL_PATH = /Library/PreferenceBundles
PokeFullCharge_FRAMEWORKS = UIKit
PokeFullCharge_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PokeFullCharge.plist$(ECHO_END)