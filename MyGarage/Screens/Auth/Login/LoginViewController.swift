//
//  LoginViewController.swift
//  MyGarage
//
//  Created by David on 13.01.26.
//

import UIKit
import SwiftUI
import FirebaseAuth

final class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let loginView = LoginView(
            onLogin: { [weak self] email, password in
                self?.login(email: email, password: password)
            },
            onCreateAccount: { [weak self] _, _ in
                self?.goToCreateAccount()
            },
            onForgotPassword: { [weak self] _ in
                self?.goToForgotPassword()
            }
        )

        let host = UIHostingController(rootView: loginView)
        addChild(host)

        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.isUserInteractionEnabled = true   
        view.addSubview(host.view)

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        host.didMove(toParent: self)

    }

    private func login(email: String, password: String) {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = password.trimmingCharacters(in: .whitespacesAndNewlines)

        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] _, error in
            if let error = error as NSError? {
                let code = AuthErrorCode(rawValue: error.code)
                print(" FirebaseAuth error:", error.code, code?.errorMessage ?? "-", error.localizedDescription)
                self?.showError(error.localizedDescription)
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }



    private func goToForgotPassword() {
        let vc = ForgotPasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func goToCreateAccount() {
        let vc = CreateAccountViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}
private extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .invalidEmail: return "invalidEmail"
        case .userNotFound: return "userNotFound"
        case .wrongPassword: return "wrongPassword"
        case .networkError: return "networkError"
        case .invalidCredential: return "invalidCredential"
        default: return "other"
        }
    }
}
