#!/bin/sh

set -ex

cd ../android
ANDROID=`git rev-parse --short HEAD`
cd -
IOS=`git rev-parse --short HEAD`

CONTENT="
// auto generated file, do not modify
enum CommitHash {
    static let android = \"$ANDROID\";
    static let ios = \"$IOS\";
}
"

echo "$CONTENT" > ${SRCROOT:-.}/Fountains/Resources/CommitHash.swift
