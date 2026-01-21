//
//  VehiclesDataProvider.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import Foundation

protocol VehiclesDataProvider {
    func observeVehicles(
            userId: String,
            onChange: @escaping (Result<[Vehicle], Error>) -> Void)-> AnyCancellableToken
    func deleteVehicle(userId: String, vehicleId: String) async throws
    func createVehicle(userId: String, vehicle: Vehicle) async throws
    func updateVehicle(userId: String, vehicle: Vehicle) async throws
    func fetchVehicle(userId: String, vehicleId: String) async throws -> Vehicle

}

protocol AnyCancellableToken {
    func cancel()
}

