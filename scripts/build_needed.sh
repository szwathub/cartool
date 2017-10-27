#!/bin/bash

set -e

# We need an absolute path to the dir we're in.
CARTOOL_DIR=$(cd "$(dirname "$0")/.."; pwd)

# Will be a short git hash or just '.' if we're not in a git repo.
REVISION=$((\
  git --git-dir="${CARTOOL_DIR}/.git" log -n 1 --format=%h 2> /dev/null) || \
  echo ".")
# If we're in a git repo, figure out if any changes have been made to cartool.
if [[ "$REVISION" != "." ]]; then
  NUM_CHANGES=$(\
    (cd "$CARTOOL_DIR" && git status --porcelain "$CARTOOL_DIR") | wc -l)
  HAS_GIT_CHANGES=$([[ $NUM_CHANGES -gt 0 ]] && echo YES || echo NO)
else
  HAS_GIT_CHANGES=NO
fi
XCODEBUILD_VERSION=$(xcodebuild -version)
XCODEBUILD_VERSION=`expr "$XCODEBUILD_VERSION" : '^.*Build version \(.*\)'`
BUILD_OUTPUT_DIR="$CARTOOL_DIR"/build/$REVISION/$XCODEBUILD_VERSION
CARTOOL_PATH="$BUILD_OUTPUT_DIR"/Products/Release/bin/cartool
if [[ -e "$CARTOOL_PATH" && $REVISION != "." && $HAS_GIT_CHANGES == "NO" && \
      "$1" != "TEST_AFTER_BUILD=YES" ]];
then
  echo 0
else
  echo 1
fi
