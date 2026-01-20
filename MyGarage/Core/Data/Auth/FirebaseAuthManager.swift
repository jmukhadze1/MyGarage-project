//
//  FirebaseAuthManager.swift
//  MyGarage
//
//  Created by David on 13.01.26.
//

import FirebaseAuth

final class FirebaseAuthManager {

    static let shared = FirebaseAuthManager()

    private init() {}

    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    func login(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func register(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func logout() throws {
        try Auth.auth().signOut()
    }
}
