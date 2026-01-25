//
//  VehicleDetailsViewModel.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import Foundation
import FirebaseAuth
import Combine
@MainActor
final class VehicleDetailsViewModel: ObservableObject {

    @Published private(set) var vehicle: Vehicle
    @Published private(set) var recentServices: [Service] = []

    private let servicesProvider: ServicesDataProvider
    private var token: AnyCancellableToken?

    init(vehicle: Vehicle, servicesProvider: ServicesDataProvider) {
        self.vehicle = vehicle
        self.servicesProvider = servicesProvider
    }

    func start() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let expectedVehicleName = "\(vehicle.make) \(vehicle.model)"
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        token?.cancel()
        token = servicesProvider.observeRecentServices(userId: userId, limit: 50) { [weak self] result in
            guard let self else { return }
            Task { @MainActor in
                switch result {
                case .success(let allServices):
                    self.recentServices = allServices
                        .filter {
                            $0.vehicleName
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .lowercased() == expectedVehicleName
                        }
                        .prefix(10)
                        .map { $0 }

                case .failure:
                    self.recentServices = []
                }
            }
        }
    }


    func stop() {
        token?.cancel()
        token = nil
    }

    // MARK: - UI helpers

    var title: String { "\(vehicle.make) \(vehicle.model)" }
    var yearText: String { "\(vehicle.year)" }
    var mileageText: String { "\(vehicle.mileage) miles" }
    var lastServiceText: String {
        recentServices.first?.serviceDate.asShortDate() ?? "—"
    }
    var imageURLString: String? { vehicle.imageURL }
}

private extension Date {
    func asShortDate() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .none
        return dateFormat.string(from: self)
    }
}
