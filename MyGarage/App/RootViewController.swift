//
//  RootViewController.swift
//  MyGarage
//
//  Created by David on 13.01.26.
//

import UIKit
import FirebaseAuth

final class RootViewController: UIViewController {
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self else { return }
            self.switchFlow(isLoggedIn: user != nil)
        }
    }

    deinit {
        if let authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
    
    private func switchFlow(isLoggedIn: Bool) {
           let vc: UIViewController = isLoggedIn
               ? MainTabBarController()
               : UINavigationController(rootViewController: LoginViewController())

           children.forEach { child in
               child.willMove(toParent: nil)
               child.view.removeFromSuperview()
               child.removeFromParent()
           }

           addChild(vc)
           vc.view.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(vc.view)

           NSLayoutConstraint.activate([
               vc.view.topAnchor.constraint(equalTo: view.topAnchor),
               vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
           ])

           vc.didMove(toParent: self)
       }
}
