//
//  ScreenCaptureManger.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 07/06/2024.
//

import SwiftUI

enum ScreenShotTypes:CaseIterable {
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



final class ScreenCaptureManger:ObservableObject {
    @Published var images:[ImageContent] = [ImageContent]()
    @Published var lastImage:ImageContent?
    private let screenCapturePath = "/usr/sbin/screencapture"
    
    func takeScreenShot(from type:ScreenShotTypes) {
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
