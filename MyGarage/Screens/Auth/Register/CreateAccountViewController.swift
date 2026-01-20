//
//  CreateAccountViewController.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import UIKit
import SwiftUI
import FirebaseAuth

final class CreateAccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let swiftUIView = CreateAccountView(
            onCreateAccount: { [weak self] email, password, confirmPassword in
                self?.register(email: email, password: password, confirmPassword: confirmPassword)
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

    private func register(email: String, password: String, confirmPassword: String) {
        guard password == confirmPassword else {
            showError("Passwords do not match.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            guard let self else { return }

            if let error {
                self.showError(error.localizedDescription)
                return
            }

            let alert = UIAlertController(
                title: "Success",
                message: "Registration completed successfully",
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
