//
//  SettingsView.swift
//  RatenDate
//
//  Created by Shivam Patel on 1/5/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sessionManager: UserSessionManager
    var body: some View {
        Text(sessionManager.userEmail!)
            .font(.largeTitle)
    }
}


#Preview {
    SettingsView()
}
