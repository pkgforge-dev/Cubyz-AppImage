#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q cubyz-bin | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/pixmaps/cubyz.png
export DESKTOP=/usr/share/applications/cubyz.desktop
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export DEPLOY_SDL=1 # SDL is statically linked, we still need to do this to cover dlopened libraries

# Deploy dependencies
mkdir -p ./AppDir/bin
cp -rv /opt/cubyz/* ./AppDir/bin
ln -s Cubyz ./AppDir/bin/cubyz
quick-sharun ./AppDir/bin/*
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
