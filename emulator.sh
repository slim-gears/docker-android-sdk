#!/bin/bash

emulator -avd android-$AVD -no-window -no-audio
echo Holding...
cat
#adb shell input keyevent 82
#./android-wait-for-emulator
