//
//  Helpers+Funcitons.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 07/06/2024.
//

import AppKit
import Cocoa
import SwiftUI

fileprivate var windowsDictionary: [String: NSWindow] = [:]

public func createOverlayWindow<Content:View>(with view:Content,id:String,at postion:CGPoint,withWidth width: CGFloat = 400,andHeight height:CGFloat = 400) ->NSWindow {
    let window = NSWindow(
        contentRect: NSRect(x: postion.x, y: postion.y, width: width, height: height),
        styleMask: [.borderless,.resizable],
        backing: .buffered,
        defer: false
    )
    window.isOpaque  = false
    window.backgroundColor = .clear
    window.level = .floating
    window.isMovable = true
    window.contentView = NSHostingView(rootView: view)
    windowsDictionary[id] = window
    return window
}

public func openNewWindow<Content: View>(with view: Content,id:String, title: String = "New Window", width: CGFloat = 300, height: CGFloat = 200) {
    let newWindowView = NSHostingController(rootView: view)
    
    // Create the window and set properties
    let newWindow = NSWindow(contentViewController: newWindowView)
    newWindow.title = title
    newWindow.setContentSize(NSSize(width: width, height: height))
    newWindow.styleMask = [.titled, .closable, .resizable, .miniaturizable]
    newWindow.center()
    windowsDictionary[id] = newWindow
    newWindow.makeKeyAndOrderFront(nil)
}

public func getWindowBy(id:String) -> NSWindow?  {
    guard let window = windowsDictionary[id] else  {return nil}
    return window
}


public func getWindowPostionBy(id:String) -> CGPoint? {
    guard let window = windowsDictionary[id] else {return nil}
    return window.frame.origin
}

