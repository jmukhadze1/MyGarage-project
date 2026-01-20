//
//  LoginView.swift
//  MyGarage
//
//  Created by David on 13.01.26.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    let onLogin: (String, String) -> Void
    let onCreateAccount: (String, String) -> Void
    let onForgotPassword: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {

            Spacer().frame(height: 90)

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .padding(.bottom, 16)

            Text("MyGarage")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 28)

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
                    textContentType: .password
                )

                PrimaryButton(
                    title: "Login",
                    isDisabled: !isFormValid
                ) {
                    onLogin(email, password)
                }
                .padding(.top, 10)

                Button("Create account") {
                    print("Create account tapped ")

                    onCreateAccount(email, password)
                }
                .font(.system(size: 15, weight: .medium))
                .padding(.top, 12)

                Button("Forgot password?") {
                    onForgotPassword(email)
                }
                .font(.system(size: 15, weight: .medium))
                .padding(.top, 6)
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }

    private var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
