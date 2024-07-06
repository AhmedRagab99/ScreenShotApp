//
//  MenubarSettingsView.swift
//  ScreenShotApp
//
//  Created by Ahmed Ragab on 06/07/2024.
//

import SwiftUI

struct MenubarSettingsView: View {
    @AppStorage("menuBarExtraIsInserted") var menuBarExtraIsInserted = true
    
    var body: some View {
        Form {
            Toggle("show menu bar extra", isOn: $menuBarExtraIsInserted)
        }
    }
}

#Preview {
    MenubarSettingsView()
}
