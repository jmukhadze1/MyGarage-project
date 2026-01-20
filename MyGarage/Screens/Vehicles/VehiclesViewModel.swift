//
//  VehiclesViewModel.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class VehiclesViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case empty
        case error(String)
    }

    @Published private(set) var vehicles: [Vehicle] = []
    @Published private(set) var state: State = .idle

    private let provider: VehiclesDataProvider
    private var token: AnyCancellableToken?

    init(provider: VehiclesDataProvider) {
        self.provider = provider
    }

    func start() {
        guard let uid = Auth.auth().currentUser?.uid else {
            state = .error("User not logged in")
            return
        }

        state = .loading

        token?.cancel()
        token = provider.observeVehicles(userId: uid) { [weak self] result in
            guard let self else { return }
            Task { @MainActor in
                switch result {
                case .success(let items):
                    self.vehicles = items
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

    func delete(vehicleId: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            try await provider.deleteVehicle(userId: uid, vehicleId: vehicleId)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
