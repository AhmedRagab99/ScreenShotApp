//
//  SettingsView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 06/07/2024.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            KeyboardShortcutSettingsView()
                .tabItem { Label("Keyboard", systemImage: "keyboard") }            
        }
        .frame(minWidth: 400, minHeight: 300)
    }
}

#Preview {
    SettingsView()
}
