//
//  ActionsCommands.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 12/07/2024.
//

import SwiftUI
import ScreenCapture
import MacOSHelpers

struct ActionsCommands: Commands {
    @ObservedObject var screenshotManger: ScreenCaptureManger
    private let width: CGFloat = (NSScreen.main?.frame.width ?? 0) - 200
    private let height: CGFloat = 700
    
    var body: some Commands {
        CommandMenu("Actions") {
            Button("New Window") {
                openNewWindow(with: ContentView(manger: screenshotManger), id: "New Window")
            }
            .keyboardShortcut("N", modifiers: [.command])
            
            
            Button("Full Screen Shot") {
                screenshotManger.takeScreenShot(from: .full)
            }
            .keyboardShortcut("O", modifiers: [.command])
            
            
            Button(" Window Screen Shot") {
                screenshotManger.takeScreenShot(from: .window)
            }
            .keyboardShortcut("T", modifiers: [.command])
            
            Divider()
            
            Button(" Open Editor") {
                if let lastImage = screenshotManger.lastImage {
                    openNewWindow(with: ImageEditorView(image: lastImage), id: "imageEditorId",title: "Image Editor",width: width , height: height)
                }
            }
            .keyboardShortcut("E", modifiers: [.command])
            
            
            
            Button(" Close Editor") {
                let window = getWindowBy(id: "imageEditorId")
                window?.close()
            }
            .keyboardShortcut("X", modifiers: [.command])
            
        }
    }
    
    
}
