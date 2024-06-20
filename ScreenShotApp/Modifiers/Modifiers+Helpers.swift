//
//  Modifiers+Helpers.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 20/06/2024.
//

import Foundation
import SwiftUI

struct TapGestureModifier: ViewModifier {
    var onTapGesture: (CGPoint) -> Void

    func body(content: Content) -> some View {
        content
            .overlay(
                TapGestureWrapper(onTapGesture: onTapGesture)
                    .frame(width: 0, height: 0) // Make it invisible, just to capture taps
            )
    }
}

extension View {
    func onTapGesture(tapAction: @escaping (CGPoint) -> Void) -> some View {
        self.modifier(TapGestureModifier(onTapGesture: tapAction))
    }
}
