//
//  ForgotPassword.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""

    let onSend: (String) -> Void
    let onGoToLogin: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            Spacer().frame(height: 90)

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .padding(.bottom, 16)

            Text("Forgot Password")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 10)

            Text("Enter your email and we’ll send a reset link.")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)

            VStack(spacing: 12) {
                AppTextField(
                    placeholder: "Email",
                    text: $email,
                    isSecure: false,
                    keyboard: .emailAddress,
                    textContentType: .emailAddress
                )

                PrimaryButton(
                    title: "Send reset link",
                    isDisabled: !isFormValid
                ) {
                    onSend(email)
                }
                .padding(.top, 10)

                HStack(spacing: 4) {
                    Text("Remember your password?")
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
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
