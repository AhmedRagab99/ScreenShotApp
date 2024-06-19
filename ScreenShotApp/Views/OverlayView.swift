//
//  OverlayView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 15/06/2024.
//

import SwiftUI
struct OverLayView:View {
    var body: some View {
        
        Text("test images ")
    }
    
}

#Preview {
    OverLayView()
}

struct OverlayItemView: View {
    var text: String
    var image:NSImage
    var id:String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
            
            Text(id)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)
            Image(nsImage: image)
                .resizable()
                .scaledToFit()
        }
    }
}

