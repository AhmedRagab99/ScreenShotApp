//
//  FilesStorageManger.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 06/07/2024.
//

import SwiftUI
import AppKit


final class FilesStorageManger : ObservableObject {
    @Published var saveImage: Bool = false
    private  var selectedPath: String? = nil
    func handleSaveAction() {
        if selectedPath == nil {
            checkPermissionAndOpenPanel()
        } else {
            saveImage = true
        }
    }
    
    func saveCapturedImage(_ fullImage: NSImage?) {
        guard let fullImage = fullImage else {
            print("Failed to capture image.")
            return
        }
        
        guard let selectedPath = selectedPath else {
            print("Selected path is nil.")
            return
        }
        
        guard let imageData = fullImage.tiffRepresentation,
              let imageRep = NSBitmapImageRep(data: imageData),
              let pngData = imageRep.representation(using: .png, properties: [:]) else {
            print("Failed to create PNG data.")
            return
        }
        
        let fileURL = URL(fileURLWithPath: selectedPath).appendingPathComponent("ScreenShotsApp")
        
        do {
            try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: true)
            // Generate a unique file name based on current timestamp
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
            let timestamp = dateFormatter.string(from: Date())
            let imageFileName = "image_\(timestamp).png"
            let imageFileURL = fileURL.appendingPathComponent(imageFileName)
            try pngData.write(to: imageFileURL)
            print("Image saved successfully at \(imageFileURL.path)")
            manageOverlayWindow(with: ToastView(imageName: "star.fill", message: "Image saved successfully", backgroundColor: .green, borderColor: .green), id: "imageSuccess",showDuration: 3.0)
        } catch {
            print("Error saving PNG file: \(error)")
            
        }
        self.saveImage = false
    }
    
    func checkPermissionAndOpenPanel() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.prompt = "Select"
        panel.message = "Please select a directory to save the images."
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                // Save the bookmark data for the selected directory
                do {
                    let bookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                    UserDefaults.standard.set(bookmarkData, forKey: "SavedDirectoryBookmark")
                    self.selectedPath = url.path
                    self.saveImage = true
                } catch {
                    print("Failed to save bookmark data: \(error)")
                }
            }
        }
    }
    
    private func openPanel() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK {
            self.saveImage = true
            self.selectedPath = panel.url?.path(percentEncoded: true)
        }
    }
    
}
