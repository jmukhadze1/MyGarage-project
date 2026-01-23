//
//  Vehicle.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import Foundation

struct Vehicle: Identifiable {
    let id: String
    var make: String
    var model: String
    var year: Int
    var mileage: Int
    var imageURL: String?
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        make: String,
        model: String,
        year: Int,
        mileage: Int,
        imageURL: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.make = make
        self.model = model
        self.year = year
        self.mileage = mileage
        self.imageURL = imageURL
        self.createdAt = createdAt
    }
}
