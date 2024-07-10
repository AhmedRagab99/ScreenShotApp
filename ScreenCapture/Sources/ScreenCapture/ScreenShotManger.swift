//
//  ScreenCaptureManger.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 07/06/2024.
//

import SwiftUI
import KeyboardShortcuts

public struct ImageContent {
     public var image:NSImage
     public var id = UUID()
    public init(image: NSImage, id: UUID = UUID()) {
        self.image = image
        self.id = id
    }
}

public extension KeyboardShortcuts.Name {
    static let screenShotCapture = Self("screenShotCapture", default: Shortcut(.three, modifiers: [.option, .command]))
    static let screenShotCaptureWindow = Self("screenShotCaptureWindow", default: Shortcut(.four, modifiers: [.option, .command]))
    static let screenShotCaptureFull = Self("screenShotCaptureFull", default: Shortcut(.five, modifiers: [.option, .command]))
}


public enum ScreenShotTypes: CaseIterable {
    case full
    case window
    case area
    
    var processArgs:[String] {
        switch self {
        case .full:
            return ["-c"]
        case .window:
            return ["-cw"]
        case .area:
            return ["-cs"]
        }
    }
    
    var titleDesc:String {
        switch self {
        case .area:
            return "area"
        case .full:
            return "full Window"
        case .window:
            return "single window"
        }
    }
}





public final class ScreenCaptureManger: ObservableObject {
    @Published public var images:[ImageContent] = [ImageContent]()
    @Published public var lastImage:ImageContent?
    private let screenCapturePath = "/usr/sbin/screencapture"
    
    public init() {
        KeyboardShortcuts.onKeyUp(for: .screenShotCapture) { [self] in
            takeScreenShot(from: .area)
        }
        
        KeyboardShortcuts.onKeyUp(for: .screenShotCaptureFull) { [self] in
            takeScreenShot(from: .full)
        }
        KeyboardShortcuts.onKeyUp(for: .screenShotCaptureWindow) { [self] in
            takeScreenShot(from: .window)
        }
    }
    
    
    public func takeScreenShot(from type:ScreenShotTypes) {
        let task =  Process()
        task.executableURL = URL(filePath:screenCapturePath)
        task.arguments = type.processArgs
        do {
            try task.run()
            task.waitUntilExit()
            getImagesFromPaste()
        } catch {
            print("error here from \(error.localizedDescription)")
        }
    }
    
    private func getImagesFromPaste() {
        guard NSPasteboard.general.canReadItem(withDataConformingToTypes: NSImage.imageTypes) else {return}
        guard let image = NSImage(pasteboard: NSPasteboard.general) else {return}
        lastImage = ImageContent(image: image)
        self.images.append(ImageContent(image: image))
    }
}
