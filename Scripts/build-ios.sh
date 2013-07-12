#!/bin/sh
set -e

cd $(dirname $0)

cd ../Examples/iOS_DNSDObjects
xctool -workspace iOS_DNSDObjects.xcworkspace -scheme iOS_DNSDObjects -arch i386 -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO build 