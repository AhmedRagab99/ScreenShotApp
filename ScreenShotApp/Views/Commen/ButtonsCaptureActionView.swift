//
//  ButtonsCaptureActionView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 06/07/2024.
//

import SwiftUI
import ScreenCapture


struct ButtonsCaptureActionView: View {
    @ObservedObject  var manger: ScreenCaptureManger

    var body: some View {
        HStack {
            
            Button(action: {manger.takeScreenShot(from: .full)}, label: {
                Label("Full Screen", systemImage: "macbook.gen2")
            })
            
            Button(action: {manger.takeScreenShot(from: .area)}, label: {
                Label("Area", systemImage: "rectangle.center.inset.filled.badge.plus")
            })
            
            Button(action: {manger.takeScreenShot(from: .window)}, label: {
                Label("Window", systemImage: "macwindow")
            })
        }
    }
}

#Preview {
    ButtonsCaptureActionView(manger: ScreenCaptureManger())
}
