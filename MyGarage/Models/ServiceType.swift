//
//  ServiceType.swift
//  MyGarage
//
//  Created by David on 24.01.26.
//

import Foundation

enum ServiceType: String, CaseIterable, Identifiable, Equatable {
    case oilChange, tireRotation, brakeService, batteryCheck, airFilter, other
    var id: String { rawValue }

    var title: String {
        switch self {
        case .oilChange: return "Oil Change"
        case .tireRotation: return "Tire Rotation"
        case .brakeService: return "Brake Service"
        case .batteryCheck: return "Battery Check"
        case .airFilter: return "Air Filter"
        case .other: return "Other"
        }
    }

    var iconName: String {
        switch self {
        case .oilChange: return "drop.fill"
        case .tireRotation: return "circle.grid.cross.fill"
        case .brakeService: return "exclamationmark.triangle.fill"
        case .batteryCheck: return "battery.100"
        case .airFilter: return "wind"
        case .other: return "wrench.and.screwdriver"
        }
    }
}
