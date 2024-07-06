//
//  KeyboardShortcutSettingsView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 06/07/2024.
//

import SwiftUI
import KeyboardShortcuts

struct KeyboardShortcutSettingsView: View {
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Screenshot Area:",
                                       name: .screenShotCapture)
            KeyboardShortcuts.Recorder("Screenshot Window:",
                                       name: .screenShotCaptureWindow)
            KeyboardShortcuts.Recorder("Screenshot Full Screen:",
                                       name: .screenShotCaptureFull)
        }
        .padding()
    }
}

#Preview {
    KeyboardShortcutSettingsView()
}
