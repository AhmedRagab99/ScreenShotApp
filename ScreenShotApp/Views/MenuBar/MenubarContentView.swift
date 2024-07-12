//
//  MenubarContentView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 06/07/2024.
//

import SwiftUI
import ScreenCapture
import MacOSHelpers

struct MenubarContentView: View {
    @ObservedObject var manger: ScreenCaptureManger
    private let width: CGFloat = (NSScreen.main?.frame.width ?? 0) - 200
    private let height: CGFloat = 700
    var body: some View {
        VStack {
            
            if let lastImage  = manger.lastImage {
                Image(nsImage: lastImage.image)
                    .resizable()
                    .scaledToFit()
                    .onTapGesture {
                        openNewWindow(with: ImageEditorView(image: lastImage), id: "imageEditor",title: "Image Editor",width: width , height: height)
                    }
                
            }
            
            ButtonsCaptureActionView(manger: manger)
            
        }
    }
}

#Preview {
    MenubarContentView(manger: ScreenCaptureManger())
}
