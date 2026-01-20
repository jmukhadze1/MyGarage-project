//
//  CreateAccountView.swift
//  MyGarage
//
//  Created by David on 13.01.26.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    let onCreateAccount: (String, String, String) -> Void
    let onGoToLogin: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            Spacer().frame(height: 90)

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .padding(.bottom, 24)

            VStack(spacing: 12) {

                AppTextField(
                    placeholder: "Email",
                    text: $email,
                    isSecure: false,
                    keyboard: .emailAddress,
                    textContentType: .emailAddress
                )

                AppTextField(
                    placeholder: "Password",
                    text: $password,
                    isSecure: true,
                    keyboard: .default,
                    textContentType: .newPassword
                )

                AppTextField(
                    placeholder: "Confirm Password",
                    text: $confirmPassword,
                    isSecure: true,
                    keyboard: .default,
                    textContentType: .newPassword
                )

                PrimaryButton(
                    title: "Create Account",
                    isDisabled: !isFormValid
                ) {
                    onCreateAccount(email, password, confirmPassword)
                }
                .padding(.top, 10)

                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    Button("Login") {
                        onGoToLogin()
                    }
                    .font(.system(size: 13, weight: .semibold))
                }
                .padding(.top, 16)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }

    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
