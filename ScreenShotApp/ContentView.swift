//
//  ContentView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 07/06/2024.
//

import SwiftUI
import ScreenCapture

struct ContentView: View {
    @ObservedObject  var manger: ScreenCaptureManger
    @State private var overlayWindow: NSWindow?
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 500))], content: {
                        ForEach(manger.images,id:\.id){ imageContent in
                            VStack {
                                ZStack(alignment: .topTrailing) {
                                    Image(nsImage: imageContent.image)
                                        .resizable()
                                        .scaledToFit()
                                    
                                    NavigationLink("Edit") {
                                        ImageEditorView(image: imageContent)
                                    }
                                    .background {
                                        Color.gray
                                    }
                                    .padding([.top,.trailing],2)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                                }
                            }
                        }
                    })
                }
                .frame(maxWidth: manger.images.count == 0 ? .zero : .infinity)
                .frame(maxHeight: manger.images.count == 0 ? .zero : .infinity)
                ContentUnavailableView("No snippets", systemImage: "swift", description: Text("You don't have any saved snippets yet."))
                    .frame(maxWidth: manger.images.count != 0 ? .zero : .infinity)
                    .frame(maxHeight: manger.images.count != 0 ? .zero : .infinity)


                ButtonsCaptureActionView(manger: manger)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView(manger: ScreenCaptureManger())
}
