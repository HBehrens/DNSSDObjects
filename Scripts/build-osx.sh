#!/bin/sh
set -e

cd $(dirname $0)

cd ../Examples/OSX_DNSDObjects
xctool -workspace OSX_DNSDObjects.xcworkspace -scheme OSX_DNSDObjects clean build 