//
//  ImageEditorView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 19/06/2024.
//

import SwiftUI

struct ImageEditorView: View {
    @State private var saveImage = false
    @StateObject private var engine = DrawingEngine()
    @State var image:ImageContent
    var body: some View {
        VStack {
            Canvas { context, size in
                context.draw(context.resolve(Image(nsImage: image.image)), in: .init(x: 0, y: 0, width: size.width, height: size.height))
                engine.draw(using: context, and: size)
                engine.setCanvasSize(with: size)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        engine.updateDragGestureOnChangedState(from: value)
                    }).onEnded({ value in
                        engine.updateDragGestureOnEndedState(using: value)
                    })
            )
            .captureImage(size: engine.getCanvasSize(), shouldCapture: saveImage) { fullImage in
                //                self.image.image = fullImage!
                guard let imageData = fullImage?.tiffRepresentation else {
                    print("image data error")
                    return
                }
                
                guard let imageRep = NSBitmapImageRep(data: imageData) else {
                    print("bit image error")
                    return
                }
                
                guard let pngData = imageRep.representation(using: .png, properties: [:]) else {
                    print("png error")
                    return
                }
                
                guard let desktopURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
                    print("desktop url error")
                    return
                }
                
                let fileURL = desktopURL.appendingPathComponent("image" + ".png")
                
                do {
                    try pngData.write(to: fileURL)
                    
                } catch {
                    print("Error saving PNG file:", error)
                    
                }
            }
            .draggable(image.image)
            
            
        }
        
        .toolbar {
            ToolbarItem(placement: .automatic) {
                ImageEditorButtonsView(engine: engine)
            }
            
            ToolbarItem(placement: .automatic) {
                Button {
                    saveImage = true
                } label: {
                    Text("save")
                }
            }
        }
    }
}
import SwiftUI
import AppKit

extension View {
    
    func captureImage(size: CGSize, scale: CGFloat = 1.0, shouldCapture: Bool, completion: @escaping (NSImage?) -> Void) -> some View {
        if shouldCapture {
            DispatchQueue.main.async {
                guard shouldCapture else {
                    completion(nil)
                    return
                }
                
                let nsImage = NSImage(size: size)
                
                // Create an NSHostingView to render the SwiftUI view
                let hostingView = NSHostingView(rootView: self)
                hostingView.frame = CGRect(origin: .zero, size: size)
                
                // Capture the view's drawing into an NSBitmapImageRep
                let bitmap = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds)!
                hostingView.cacheDisplay(in: hostingView.bounds, to: bitmap)
                
                // Convert the bitmap representation to NSImage
                nsImage.addRepresentation(bitmap)
                
                // Call the completion handler with the captured NSImage
                completion(nsImage)
            }
        }
        
        // Return the original view
        return self
    }
}

#Preview {
    ImageEditorView(image: ImageContent(image: NSImage(resource: .test)))
}



