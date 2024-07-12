//
//  ImageEditorButtonsView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 20/06/2024.
//

import SwiftUI
import DrawingEngine


fileprivate enum ImageEditorButtonsViewPlacholder: CaseIterable {
    static let circle = "Circle"
    static let rectangle = "Rectangle"
    static let oval = "Oval"
    static let line = "Line"
    static let redo = "Redo"
    static let undo = "Undo"
    static let delete = "Delete"
    static let arrow = "Arrow"
    
}
struct ImageEditorButtonsView : View {
    @ObservedObject var engine:DrawingEngine
    @State private var showConfirmation: Bool = false
    
    var body: some View {
        HStack {
            
            ColorPicker("", selection: $engine.selectedColor)
            Slider(value: $engine.selectedLineWidth, in: 1...20) {
                Text("linewidth")
            }.frame(minWidth: 200)
            Text(String(format: "%.0f", engine.selectedLineWidth))
            
            Spacer(minLength: 50)
            Button {
                engine.setDrawingType(with: .line)
            } label: {
                Image(systemName: "line.diagonal")
                    .imageScale(.large)
            }
            .help(ImageEditorButtonsViewPlacholder.line)
            
            Button {
                engine.setDrawingType(with: .rectangle)
            } label: {
                Image(systemName: "rectangle")
                    .imageScale(.large)
            }
            .help(ImageEditorButtonsViewPlacholder.rectangle)
            
            Button {
                engine.setDrawingType(with: .circle)
            } label: {
                Image(systemName: "circle")
                    .imageScale(.large)
            }
            .help(ImageEditorButtonsViewPlacholder.circle)
            
            
            Button {
                engine.setDrawingType(with: .ellipse)
            } label: {
                Image(systemName: "oval")
                    .imageScale(.large)
            }
            .help(ImageEditorButtonsViewPlacholder.oval)
            
            Button {
                engine.setDrawingType(with: .arrow)
            } label: {
                Image(systemName: "arrow.down.left")
                    .imageScale(.large)
            }
            .help(ImageEditorButtonsViewPlacholder.arrow)
            
            Spacer(minLength: 50)
            
            Button {
                engine.undoDrawing()
            } label: {
                Image(systemName: "arrow.uturn.backward.circle")
                    .imageScale(.large)
            }
            .disabled(engine.undoValidation())
            .keyboardShortcut(KeyEquivalent("z"), modifiers: [.command])
         
            
            Button {
                engine.redoDrawing()
            } label: {
                Image(systemName: "arrow.uturn.forward.circle")
                    .imageScale(.large)
            }
            .disabled(engine.redoValidation())
            .keyboardShortcut(KeyEquivalent("z"), modifiers: [.shift,.command])
            .help(ImageEditorButtonsViewPlacholder.redo)
            
            Button {
                showConfirmation = true
            } label: {
                Image(systemName: "delete.backward")
                    .imageScale(.large)
            }
            .help(ImageEditorButtonsViewPlacholder.delete)
            .keyboardShortcut(KeyEquivalent("d"), modifiers: .command)
            .confirmationDialog(Text("Are you sure you want to delete everything?"), isPresented: $showConfirmation) {
                
                Button("Delete", role: .destructive) {
                    engine.removeAll()
                }
                
            }
        }
        .padding()
    }
}


#Preview {
    ImageEditorButtonsView(engine: DrawingEngine())
}
