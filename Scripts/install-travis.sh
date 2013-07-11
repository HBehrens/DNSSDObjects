#!/bin/sh
set -ev

brew install xctool
brew install appledoc

pod --version
gem update cocoapods