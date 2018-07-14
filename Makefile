include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PokeFullCharge
PokeFullCharge_FILES = Tweak.xm

PokeFullCharge_FRAMEWORKS = AVFoundation AudioToolbox

BUNDLE_NAME = com.6ilent.pokefullcharge
com.6ilent.pokefullcharge_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	echo "Real All The Time."
	install.exec "killall -9 SpringBoard"
	
SUBPROJECTS += pokefullcharge
include $(THEOS_MAKE_PATH)/aggregate.mk
