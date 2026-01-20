//
//  ProfileViewController.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import UIKit
import SwiftUI
import FirebaseAuth

final class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground

        let swiftUIView = ProfileView(
            onLogout: { [weak self] in
                self?.logout()
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

    private func logout() {
        try? Auth.auth().signOut()
    }
}
