//
//  ForgotPasswordViewController.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import UIKit
import SwiftUI
import FirebaseAuth

final class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let swiftUIView = ForgotPasswordView(
            onSend: { [weak self] email in
                self?.sendReset(email: email)
            },
            onGoToLogin: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )

        let host = UIHostingController(rootView: swiftUIView)
        addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(host.view)

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        host.didMove(toParent: self)
    }

    private func sendReset(email: String) {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanEmail.isEmpty else {
            showError("Please enter your email first.")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: cleanEmail) { [weak self] error in
            guard let self else { return }

            if let error {
                self.showError(error.localizedDescription)
                return
            }

            let alert = UIAlertController(
                title: "Success",
                message: "Password reset link sent",
                preferredStyle: .alert
            )

            self.present(alert, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                alert.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
