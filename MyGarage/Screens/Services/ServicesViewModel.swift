//
//  ServicesViewModel.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import Foundation
import FirebaseAuth
import Combine
@MainActor
final class ServicesViewModel: ObservableObject {

    enum State: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    @Published private(set) var services: [Service] = []
    @Published private(set) var state: State = .idle

    private let provider: ServicesDataProvider
    private var token: AnyCancellableToken?

    init(provider: ServicesDataProvider) {
        self.provider = provider
    }

    func start(limit: Int = 50) {
        guard let uid = Auth.auth().currentUser?.uid else {
            state = .error("User not logged in")
            return
        }

        state = .loading
        token?.cancel()

        token = provider.observeRecentServices(userId: uid, limit: limit) { [weak self] result in
            guard let self else { return }
            Task { @MainActor in
                switch result {
                case .success(let items):
                    self.services = items
                    self.state = items.isEmpty ? .empty : .loaded
                case .failure(let error):
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }

    func stop() {
        token?.cancel()
        token = nil
    }
    
    var totalServices: Int {
        services.count
    }

    var totalSpent: Double {
        services.reduce(0) { $0 + $1.cost }
    }

}
