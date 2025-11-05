#!/bin/sh

cd ../android
ANDROID=`git rev-parse --short HEAD`
cd -
IOS=`git rev-parse --short HEAD`

CONTENT="
public enum CommitHash {
  public static let android = \"$ANDROID\";
  public static let ios = \"$IOS\";
}
"

echo $CONTENT > ${SRCROOT:-.}/Fountains/Resources/CommitHash.swift
