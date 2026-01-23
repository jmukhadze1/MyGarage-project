//
//  Service.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import Foundation

struct Service: Identifiable, Equatable {
    let id: String

    var title: String
    var vehicleName: String
    var cost: Double
    var mileage: Int
    var serviceDate: Date
    var iconName: String?
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        title: String,
        vehicleName: String,
        cost: Double,
        mileage: Int,
        serviceDate: Date,
        iconName: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.vehicleName = vehicleName
        self.cost = cost
        self.mileage = mileage
        self.serviceDate = serviceDate
        self.iconName = iconName
        self.createdAt = createdAt
    }
}
