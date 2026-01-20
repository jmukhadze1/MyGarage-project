//
//  AuthDataProvider.swift
//  MyGarage
//
//  Created by David on 13.01.26.
//

import Foundation

final class AuthDataProvider {

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        FirebaseAuthManager.shared.login(
            email: email,
            password: password,
            completion: completion
        )
    }

    func register(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        FirebaseAuthManager.shared.register(
            email: email,
            password: password,
            completion: completion
        )
    }

    func logout() throws {
        try FirebaseAuthManager.shared.logout()
    }

    var isLoggedIn: Bool {
        FirebaseAuthManager.shared.currentUserId != nil
    }
}
