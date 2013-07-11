#!/bin/sh
set -e

cd $(dirname $0)

cd ..
pod spec lint