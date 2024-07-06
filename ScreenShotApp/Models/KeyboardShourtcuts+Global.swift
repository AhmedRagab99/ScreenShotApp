//
//  KeyboardShourtcuts+Global.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 06/07/2024.
//

import Foundation
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let screenShotCapture = Self("screenShotCapture", default: Shortcut(.three, modifiers: [.option, .command]))
    static let screenShotCaptureWindow = Self("screenShotCaptureWindow", default: Shortcut(.four, modifiers: [.option, .command]))
    static let screenShotCaptureFull = Self("screenShotCaptureFull", default: Shortcut(.five, modifiers: [.option, .command]))
}
