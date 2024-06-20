//
//  ImageEditorView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 19/06/2024.
//

import SwiftUI


struct ImageEditorButtonsView : View {
    @ObservedObject  var engine:DrawingEngine
    @Binding var isShowingTextInput:Bool
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                HStack {
                    ColorPicker("", selection: $engine.selectedColor)
                    Slider(value: $engine.selectedLineWidth, in: 1...20) {
                        Text("linewidth")
                    }.frame(minWidth: 200)
                    Text(String(format: "%.0f", engine.selectedLineWidth))
                    
                }
                Spacer()
                
                Button {
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .imageScale(.large)
                }
                
                
                Button {
                    engine.setDrawingType(with: .rectangle)
                } label: {
                    Image(systemName: "rectangle")
                        .imageScale(.large)
                }
                
                
                Button {
                    engine.setDrawingType(with: .line)
                } label: {
                    Image(systemName: "pencil")
                        .imageScale(.large)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "eraser")
                        .imageScale(.large)
                }
                
                
                Button {
                    engine.setDrawingType(with: .arrow)
                } label: {
                    Image(systemName: "arrow.down.left")
                        .imageScale(.large)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "line.diagonal")
                        .imageScale(.large)
                }
                
                Button {
               
                } label: {
                    Image(systemName: "t.square.fill")
                        .imageScale(.large)
                }
                
                
                Button {
                    
                } label: {
                    Image(systemName: "highlighter")
                        .imageScale(.large)
                }
                
                VStack {
                    Button{
                        engine.undoDrawing()
                    } label: {
                        Text("undo")
                    }
                    .disabled(engine.undoValidation())
                    
                    
                    Button{
                        engine.redoDrawing()
                    } label: {
                        Text("redo")
                    }
                    .disabled(engine.redoValidation())
                }.padding(.top)
            }
            .padding()
        }
    }
    
}

struct ImageEditorView: View {
    @State private var isShowingTextInput = false
    @StateObject private var engine = DrawingEngine()
    @State var image:NSImage
    var body: some View {
        VStack {
            ImageEditorButtonsView(engine: engine, isShowingTextInput: $isShowingTextInput)
            ZStack {
                Color.black
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
                Canvas { context, size in
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
                
            }
            
        }
    }
}

#Preview {
    ImageEditorView(image: NSImage(resource: .test))
}



