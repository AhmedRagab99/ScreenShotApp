//
//  ContentView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 07/06/2024.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var manger  = ScreenCaptureManger()
    @State  private var selection:ScreenShotTypes = .full
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200, maximum: 500))], content: {
                    ForEach(manger.images,id:\.self){ image in
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()
                            .draggable(image)
                    }
                })
            }
            
            
            HStack {
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

#Preview {
    ContentView()
}
