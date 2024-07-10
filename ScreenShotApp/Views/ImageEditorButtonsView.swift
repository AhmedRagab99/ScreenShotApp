//
//  ImageEditorButtonsView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 20/06/2024.
//

import SwiftUI

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
            
            Button {
                engine.setDrawingType(with: .rectangle)
            } label: {
                Image(systemName: "rectangle")
                    .imageScale(.large)
            }
            Button {
                engine.setDrawingType(with: .circle)
            } label: {
                Image(systemName: "circle")
                    .imageScale(.large)
            }
            
            
            Button {
                engine.setDrawingType(with: .ellipse)
            } label: {
                Image(systemName: "oval")
                    .imageScale(.large)
            }
            
            Button {
                engine.setDrawingType(with: .arrow)
            } label: {
                Image(systemName: "arrow.down.left")
                    .imageScale(.large)
            }
            
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
            
            Button {
                showConfirmation = true
            } label: {
                Image(systemName: "delete.backward")
                    .imageScale(.large)
            }
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
