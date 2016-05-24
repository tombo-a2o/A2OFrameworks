# Tombo StoreKit

Tombo StoreKit is a StoreKit implementation which connects to Tombo API Servers.

## How to open the project

At first, you must execute CocoaPods installer.

```
gem install cocoapods
pod install
```

You can open the StoreKit project like below.

```
open StoreKit.xcworkspace
```

NOTE: don't open StoreKit.xcodeproj because we use CocoaPods and it generates the workspace to combine StoreKit and CocoaPods.

## How to test

1. Select the target StoreKit
2. <kbd>command</kbd> + <kbd>U</kbd>

## How to build

1. Select the target Framework
2. <kbd>command</kbd> + <kbd>B</kbd>

It generates a fat binary for all architectures.

## Reference

- [How to create, develop, and distribute iOS Static Frameworks quickly and efficiently](https://github.com/jverkoey/iOS-Framework)
