//
//  TapGestureRepresentable.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 20/06/2024.
//

import Foundation
import SwiftUI

import SwiftUI

#if canImport(UIKit)
import UIKit

struct TapGestureWrapper: UIViewRepresentable {
    var onTapGesture: (CGPoint) -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: context.coordinator,
                                                 action: #selector(Coordinator.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No-op
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onTapGesture: onTapGesture)
    }

    class Coordinator: NSObject {
        var onTapGesture: (CGPoint) -> Void

        init(onTapGesture: @escaping (CGPoint) -> Void) {
            self.onTapGesture = onTapGesture
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            let location = gesture.location(in: gesture.view)
            onTapGesture(location)
        }
    }
}
#elseif canImport(AppKit)
import AppKit

struct TapGestureWrapper: NSViewRepresentable {
    var onTapGesture: (CGPoint) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        let tapGesture = NSClickGestureRecognizer(target: context.coordinator,
                                                   action: #selector(Coordinator.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.wantsLayer = true
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        // No-op
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(onTapGesture: onTapGesture)
    }

    class Coordinator: NSObject {
        var onTapGesture: (CGPoint) -> Void

        init(onTapGesture: @escaping (CGPoint) -> Void) {
            self.onTapGesture = onTapGesture
        }

        @objc func handleTap(_ gesture: NSClickGestureRecognizer) {
            let location = gesture.location(in: gesture.view)
            onTapGesture(location)
        }
    }
}
#endif
