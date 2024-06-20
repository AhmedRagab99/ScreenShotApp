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
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        engine.updateDragGestureOnChangedState(from: value)
                    }).onEnded({ value in
                        engine.updateDragGestureOnEndedState(using: value)
                    })
            )
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

#Preview {
    ImageEditorView(image: ImageContent(image: NSImage(resource: .test)))
}



