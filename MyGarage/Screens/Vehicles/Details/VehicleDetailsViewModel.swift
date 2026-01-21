//
//  VehicleDetailsViewModel.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import Foundation
import Combine

@MainActor
final class VehicleDetailsViewModel: ObservableObject {

    @Published private(set) var vehicle: Vehicle

    init(vehicle: Vehicle) {
        self.vehicle = vehicle
    }

    var title: String { "\(vehicle.make) \(vehicle.model)" }

    var yearText: String { "\(vehicle.year)" }

    var mileageText: String { "\(formatNumber(vehicle.mileage)) miles" }

    var lastServiceText: String { "—" }

    var imageURLString: String? { vehicle.imageURL }

    private func formatNumber(_ value: Int) -> String {
        let numformat = NumberFormatter()
        numformat.numberStyle = .decimal
        return numformat.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
