#!/bin/bash

#author:ldehai@gmail.com
#github:https://github.com/ldehai/iOSTips/packapp.sh

#脚本说明
#使用xcodebuild在命令行下编译打包app，最后输出ipa文件

#使用说明
#命令行下执行chmod +x packapp.sh,设置为可运行。将脚本里面的app路径修改为你项目的实际路径，配置好签名和证书就可以用了。
#运行方式：./packapp.sh

#1 设置各项根目录(修改为项目实际路径)
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

#4 编译app(指定项目实际的"CODE_SIGN_IDENTITY"和"PROVISIONING_PROFILE")
#  注意"PROVISIONING_PROFILE"要使用证书的uuid，不能直接用名字
echo "building..."
	xcodebuild \
	-workspace Chanel.xcworkspace \  #指定workspace
	-scheme Chanel \                 #指定schema
	VALID_ARCHS="arm64 armv7 armv7s" \   #指定archs
	DEBUG_INFORMATION_FORMAT="dwarf-with-dsym" \ #指定携带调试符号信息文件(与app同名的.dsym文件)，崩溃时可以打印堆栈信息
	-configuration Debug clean build CONFIGURATION_BUILD_DIR=$BUILD_PATH \ #自定义编译输出路径
	CODE_SIGN_IDENTITY="iPhone Distribution: XXXXXXXX" \  #签名
	PROVISIONING_PROFILE="a06c1a65-f449-4a95-8682-d05eab5b5c36"  #设置provisioning，要使用证书的uuid，不能直接用名字

#5 打包ipa
appfile=$BUILD_PATH/myapp.app
ipafile=$APP_PATH/myapp.ipa

#删除上次输出的ipa文件
rm -r $APP_PATH/myapp.ipa

#将编译生成的app打包成ipa文件，其实就是一个zip文件
/usr/bin/xcrun -sdk iphoneos PackageApplication -v $appfile -o $ipafile
