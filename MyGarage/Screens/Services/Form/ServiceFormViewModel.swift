//
//  ServiceFormViewModel.swift
//  MyGarage
//
//  Created by David on 24.01.26.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class ServiceFormViewModel: ObservableObject {

    enum Mode: Equatable {
        case add
        case edit(Service)
    }

    // MARK: Form Fields
    @Published var vehicleName: String = ""
    @Published var selectedType: ServiceType? = nil
    @Published var serviceDate: Date = Date()
    @Published var costText: String = ""
    @Published var mileageText: String = ""

    // MARK: UI State
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil

    let mode: Mode
    private let provider: ServicesDataProvider

    init(mode: Mode, provider: ServicesDataProvider) {
        self.mode = mode
        self.provider = provider
        preloadIfNeeded()
    }

    var navTitle: String {
        switch mode {
        case .add: return "New Service"
        case .edit: return "Edit Service"
        }
    }

    // MARK: Parsing
    private var parsedCost: Double? {
        let normalizedCostText = costText.replacingOccurrences(of: ",", with: ".")
        guard let costValue = Double(normalizedCostText), costValue >= 0 else { return nil }
        return costValue
    }

    private var parsedMileage: Int? {
        guard let mileageValue = Int(mileageText), mileageValue >= 0 else { return nil }
        return mileageValue
    }

    // MARK: Validation
    var canSave: Bool {
        let trimmedVehicleName = vehicleName.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasVehicle = !trimmedVehicleName.isEmpty
        let hasType = selectedType != nil
        let hasValidCost = parsedCost != nil
        let hasValidMileage = parsedMileage != nil

        return hasVehicle && hasType && hasValidCost && hasValidMileage && !isSaving
    }

    // MARK: Prefill (Edit Mode)
    private func preloadIfNeeded() {
        guard case let .edit(existingService) = mode else { return }

        vehicleName = existingService.vehicleName
        serviceDate = existingService.serviceDate
        costText = String(format: "%.2f", existingService.cost)
        mileageText = "\(existingService.mileage)"

        selectedType = ServiceType.allCases.first(where: { serviceType in
            serviceType.iconName == existingService.iconName
        })
    }

    // MARK: Save
    func save() async -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "User not logged in"
            return false
        }

        let trimmedVehicleName = vehicleName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedVehicleName.isEmpty else {
            errorMessage = "Vehicle is required"
            return false
        }

        guard let serviceType = selectedType else {
            errorMessage = "Service type is required"
            return false
        }

        guard let costValue = parsedCost else {
            errorMessage = "Cost is not valid"
            return false
        }

        guard let mileageValue = parsedMileage else {
            errorMessage = "Mileage is not valid"
            return false
        }

        isSaving = true
        defer { isSaving = false }

        do {
            switch mode {
            case .add:
                let newService = Service(
                    id: UUID().uuidString,
                    title: serviceType.title,
                    vehicleName: trimmedVehicleName,
                    cost: costValue,
                    mileage: mileageValue,
                    serviceDate: serviceDate,
                    iconName: serviceType.iconName,
                    createdAt: Date()
                )
                try await provider.createService(userId: userId, service: newService)

            case .edit(let existingService):
                let updatedService = Service(
                    id: existingService.id,
                    title: serviceType.title,
                    vehicleName: trimmedVehicleName,
                    cost: costValue,
                    mileage: mileageValue,
                    serviceDate: serviceDate,
                    iconName: serviceType.iconName,
                    createdAt: existingService.createdAt
                )
                try await provider.updateService(userId: userId, service: updatedService)
            }

            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
