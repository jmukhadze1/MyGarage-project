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
        view.backgroundColor = .systemBackground

        let swiftUIView = ProfileView()

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
        
        applyTheme()
        
        NotificationCenter.default.addObserver(
                  self,
                  selector: #selector(themeChanged),
                  name: .appThemeDidChange,
                  object: nil
              )
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: .appThemeDidChange, object: nil)
    }

    @objc private func themeChanged() {
        applyTheme()
    }

    private func applyTheme() {
        let theme = UserDefaults.standard.string(forKey: "appTheme") ?? "light"
        overrideUserInterfaceStyle = (theme == "dark") ? .dark : .light
    }
    private func logout() {
        try? Auth.auth().signOut()
    }
}
