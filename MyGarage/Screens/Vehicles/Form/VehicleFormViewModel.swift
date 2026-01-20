//
//  VehicleFormViewModel.swift
//  MyGarage
//
//  Created by David on 20.01.26.
//

import Foundation
import FirebaseAuth

@MainActor
final class VehicleFormViewModel {
    enum Mode {
        case add
        case edit(Vehicle)
    }

    private let provider: VehiclesDataProvider
    let mode: Mode

    init(provider: VehiclesDataProvider, mode: Mode) {
        self.provider = provider
        self.mode = mode
    }

    var screenTitle: String {
        switch mode {
        case .add: return "Add Vehicle"
        case .edit: return "Edit Vehicle"
        }
    }

    func initialValues() -> (make: String, model: String, year: String, mileage: String, imageURL: String?) {
        switch mode {
        case .add:
            return ("", "", "", "", nil)
        case .edit(let vehicle):
            return (vehicle.make, vehicle.model, "\(vehicle.year)", "\(vehicle.mileage)", vehicle.imageURL)
        }
    }

    func save(make: String, model: String, yearText: String, mileageText: String, imageURL: String?) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }

        let trimmedMake = make.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedModel = model.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedMake.isEmpty, !trimmedModel.isEmpty else {
            throw NSError(domain: "Form", code: 1, userInfo: [NSLocalizedDescriptionKey: "Make and model are required"])
        }

        guard let year = Int(yearText), year > 1900 else {
            throw NSError(domain: "Form", code: 2, userInfo: [NSLocalizedDescriptionKey: "Year is not valid"])
        }

        guard let mileage = Int(mileageText), mileage >= 0 else {
            throw NSError(domain: "Form", code: 3, userInfo: [NSLocalizedDescriptionKey: "Mileage is not valid"])
        }

        switch mode {
        case .add:
            let newVehicle = Vehicle(
                id: UUID().uuidString,
                make: trimmedMake,
                model: trimmedModel,
                year: year,
                mileage: mileage,
                imageURL: imageURL,
                createdAt: Date()
            )
            try await provider.createVehicle(userId: uid, vehicle: newVehicle)

        case .edit(let oldVehicle):
            let updated = Vehicle(
                id: oldVehicle.id,
                make: trimmedMake,
                model: trimmedModel,
                year: year,
                mileage: mileage,
                imageURL: imageURL,
                createdAt: oldVehicle.createdAt
            )
            try await provider.updateVehicle(userId: uid, vehicle: updated)
        }
    }
}
