//
//  ScreenShotAppApp.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 07/06/2024.
//

import SwiftUI
import ScreenCapture



@main
struct ScreenShotAppApp: App {
    @StateObject var screenshotManger = ScreenCaptureManger()
    @AppStorage("menuBarExtraIsInserted") var menuBarExtraIsInserted = true
    
    var body: some Scene {
        WindowGroup {
            ContentView(manger: screenshotManger)
        }
        .commands {
            ActionsCommands(screenshotManger: screenshotManger)
        }
        MenuBarExtra("Screenshots",
                     systemImage: "photo.badge.plus",
                     isInserted: $menuBarExtraIsInserted) {
            MenubarContentView(manger: screenshotManger)
        }
                     .menuBarExtraStyle(.window)
        
        Settings {
            SettingsView()
        }
    }
}
