#!/bin/bash

#author:ldehai@gmail.com
#github:https://github.com/ldehai/iOSTips/packapp.sh

#1 设置各项根目录
PROJ_PATH="/Users/andy/myapp"
INFO_PATH="/Users/andy/myapp/myapp/Info.plist"
BUILD_PATH="/Users/andy/release/build"
APP_PATH="/Users/andy/release"

#2 进入项目目录
cd $PROJ_PATH

#3 设置Info.plist版本
appversion=1.0
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '${appversion}'" $INFO_PATH
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${appversion}'" $INFO_PATH

#4 编译app
echo "building..."
      xcodebuild
			-workspace Chanel.xcworkspace   #指定workspace
			-scheme Chanel                  #指定schema
			VALID_ARCHS="arm64 armv7 armv7s"    #指定archs
			-configuration Debug clean build CONFIGURATION_BUILD_DIR=$BUILD_PATH  #自定义编译输出路径
			CODE_SIGN_IDENTITY="iPhone Distribution: XXXXXXXX"   #签名
			PROVISIONING_PROFILE="a06c1a65-f449-4a95-8682-d05eab5b5c36"  #设置provisioning，要使用证书的uuid，不能直接用名字

#5 打包ipa
appfile=$BUILD_PATH/myapp.app
ipafile=$APP_PATH/myapp.ipa

rm -r $APP_PATH/channel.ipa
/usr/bin/xcrun -sdk iphoneos PackageApplication -v $appfile -o $ipafile