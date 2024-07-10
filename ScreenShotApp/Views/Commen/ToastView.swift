//
//  ToastView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 06/07/2024.
//

import SwiftUI

struct ToastView: View {
    let imageName: String
    let message: String
    let backgroundColor: Color
    let borderColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
            
            Text(message)
                .foregroundColor(.white)
                .font(.body)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(backgroundColor)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1)
                )
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(15)
        .padding(.horizontal, 30)
    }
}
