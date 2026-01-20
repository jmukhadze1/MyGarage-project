//
//  ProfileView.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import SwiftUI

struct ProfileView: View {

    let onLogout: () -> Void

    var body: some View {
        VStack {
            Spacer()

            PrimaryButton(title: "Logout") {
                onLogout()
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}
