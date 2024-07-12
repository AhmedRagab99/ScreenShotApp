# ScreenShotApp 
MacOS app takes screenshots and freely edit screenshots images and save it with the ability to control app through menubar and settings with global shortcuts

[![Platform](http://img.shields.io/badge/platform-MacOS-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![](http://img.shields.io/badge/language-Swift-brightgreen.svg?color=orange)](https://developer.apple.com/swift)
[![](http://img.shields.io/badge/Framework-SwiftUI-brightgreen.svg?color=orange)](https://developer.apple.com/swiftUI)


## 🧐 About
ScreenShotApp is MacOS application that let you take and edit screenshots built with swift ui and Multi modules through local SPM's and using mac os features like interact with app with menubars and  keyboard shortcuts
![](header.png)


- [Screenshots](#screenshots)
- [Requirements](#requirements)
- [Libraries](#libraries)
- [Installation](#installation)
- [Architecture](#Architecture)

## Screenshots

<img src="https://github.com/user-attachments/assets/0d1f7bb1-b219-40e7-8067-810ed9d12739" width="1000" height="500">

## Requirements

* MacOS 14.5+
* Xcode 15.4

## libraries
 - KeyboardShortcuts   

## Installation
- Simply Clone project
-  From xcode file menu go to packages and click on resolve packges
-  Select Development Team and  change Bundle Id
-  Build and Run


## Architecture
- Main App :
      Main module advantages of Swift UI with Macos Support and uses menubars with custom settings action and reusable views.
- DrawingEngine : 
   The module responsible for Drawing views and update shapes in Canvas with the redo and undo logic in it
- ScreenCapture :
   The module responsible for take screen shots and interact with screen shot cli app on mac
- MacOS Helpers:
    helper functions to interact with AppKit NSWindow and mac os related logic
