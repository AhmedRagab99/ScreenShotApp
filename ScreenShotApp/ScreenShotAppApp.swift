//
//  ScreenShotAppApp.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 07/06/2024.
//

import SwiftUI

@main
struct ScreenShotAppApp: App {
    @ObservedObject var screenshotManger = ScreenCaptureManger()
    @AppStorage("menuBarExtraIsInserted") var menuBarExtraIsInserted = true
    
    var body: some Scene {
        WindowGroup {
            ContentView(manger: screenshotManger)
        }
        
        MenuBarExtra("Screenshots",
                     systemImage: "photo.badge.plus",
                     isInserted: $menuBarExtraIsInserted) {
            MenubarContentView(manger: screenshotManger)
        }
                     .menuBarExtraStyle(.menu)
        
        Settings {
            SettingsView()
        }
    }
}
