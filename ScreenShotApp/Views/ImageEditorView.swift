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
        HStack {
            ColorPicker("", selection: $engine.selectedColor)
            Slider(value: $engine.selectedLineWidth, in: 1...20) {
                Text("linewidth")
            }
            Text(String(format: "%.0f", engine.selectedLineWidth))
            
            Spacer()
            
            Button {
                engine.setDrawingType(with: .ellipse)
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
                
            } label: {
                Image(systemName: "arrow.uturn.backward.circle")
                    .imageScale(.large)
            }
            
            Button {
                
            } label: {
                Image(systemName: "line.diagonal")
                    .imageScale(.large)
            }
            
            Button {
                engine.setDrawingType(with: .text)
                isShowingTextInput = true
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
                    let last = engine.lines.removeLast()
                    engine.deletedLines.append(last)
                } label: {
                    Text("undo")
                }.disabled(engine.lines.count == 0)
                
                
                Button{
                    let last = engine.deletedLines.removeLast()
                    engine.lines.append(last)
                } label: {
                    Text("redo")
                }.disabled(engine.deletedLines.count == 0)
            }.padding(.top)
        }
        .padding()
    }
    
}

struct ImageEditorView: View {
    
    @State private var selectedLineWidth: CGFloat = 2
    @State private var selectedColor: Color = .red
    @State private var isShowingTextInput = false
    @StateObject private var engine = DrawingEngine()
    var image:NSImage
    
    var body: some View {
        VStack {
            ImageEditorButtonsView(engine: engine, isShowingTextInput: $isShowingTextInput)
            
           
            
            
            ZStack {
                Image(nsImage: NSImage(resource: .test))
                    .resizable()
                    .padding()
                Canvas { context, size in
                    engine.draw(using: context, and: size)
                }
                .gesture(DragGesture(minimumDistance: 0).onChanged({ value in
                    engine.updateDragGestureOnChangedState(from: value)
                }).onEnded({ value in
                    engine.updateDragGestureOnEndedState(using: value)
            }))
            }
            .sheet(isPresented: $isShowingTextInput) {
                       TextInputView(drawingEngine: engine, isShowing: $isShowingTextInput)
                }
        }
    }
}
struct TextInputView: View {
    @ObservedObject var drawingEngine: DrawingEngine
    @Binding var isShowing: Bool
    @State private var inputText = ""
    
    var body: some View {
        VStack {
            TextField("Enter text", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            HStack {
                Button("Cancel") {
                    isShowing = false
                }
                Spacer()
                Button("Done") {
                    drawingEngine.text = inputText
                    isShowing = false
                }
            }
            .padding()
        }
    }
}
#Preview {
    ImageEditorView(image: NSImage(resource: .test))
}



