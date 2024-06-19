//
//  ContentView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 07/06/2024.
//

import SwiftUI

struct ImageContent {
    var image:NSImage
    var id = UUID()
}
struct ContentView: View {
    @StateObject private var manger  = ScreenCaptureManger()
    @State private var overlayWindow: NSWindow?
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 500))], content: {
                    ForEach(manger.images,id:\.id){ imageContent in
                        VStack {
                            Image(nsImage: imageContent.image)
                                .resizable()
                                .scaledToFit()
                                .draggable(imageContent.image)
                            Text(imageContent.id.description)
                                .font(.title)
                        }
                    }
                })
            }
            
            
            
            
            HStack {
                Button("close window") {
                    let application = NSApplication.shared
                    
                    // Filter visible windows
                    guard let overlayWindow = overlayWindow else {return}
                    overlayWindow.close()
                }
                
                Button("open overlays window") {
//                    manger.images.forEach { imageContent in
//                        var position = CGPoint(x: 50, y: 100)
//                        if let windowPostion = getWindowPostionBy(id: imageContent.id.description) {
//                            position = CGPoint(x: windowPostion.x, y: windowPostion.y + 100)
//                        }
//                        
//                        let overlayView = OverlayView(text: "Top Left Overlay", image: imageContent.image, id: imageContent.id.description)
//                        overlayWindow = createOverlayWindow(with: overlayView, id: imageContent.id.description, at: position)
//                        overlayWindow?.makeKeyAndOrderFront(nil)
//                    }
                }
                
                Button("create new window") {
                    openNewWindow(with: ContentView(), id: "newID",title: "new content view window")
                }
                Button ("Make a full screenShot") {
                    manger.takeScreenShot(from: .full)
                }
                Button ("Make a wnidow screenShot") {
                    manger.takeScreenShot(from: .window)
                }
                Button ("Make an area screenShot") {
                    manger.takeScreenShot(from: .area)
                }
            }
        }
        .padding()
    }
}

//

#Preview {
    ContentView()
}
