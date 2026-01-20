//
//  FirestoreVehiclesManager.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import Foundation
import FirebaseFirestore

final class FirestoreVehiclesManager: VehiclesDataProvider {
    private let db = Firestore.firestore()

    private func vehiclesCollection(userId: String) -> CollectionReference {
        db.collection("users").document(userId).collection("vehicles")
    }

    func observeVehicles(
        userId: String,
        onChange: @escaping (Result<[Vehicle], Error>) -> Void
    ) -> AnyCancellableToken {

        let query = vehiclesCollection(userId: userId)
            .order(by: "createdAt", descending: true)

        let registration = query.addSnapshotListener { snapshot, error in
            if let error {
                onChange(.failure(error))
                return
            }
            guard let snapshot else {
                onChange(.success([]))
                return
            }

            let vehicles: [Vehicle] = snapshot.documents.compactMap { doc in
                let data = doc.data()

                guard
                    let make = data["make"] as? String,
                    let model = data["model"] as? String
                else { return nil }

                let year = (data["year"] as? Int) ?? (data["year"] as? NSNumber)?.intValue
                let mileage = (data["mileage"] as? Int) ?? (data["mileage"] as? NSNumber)?.intValue
                guard let year, let mileage else { return nil }

                let imageURL = data["imageURL"] as? String

                let createdAt: Date
                if let ts = data["createdAt"] as? Timestamp {
                    createdAt = ts.dateValue()
                } else {
                    createdAt = Date()
                }

                return Vehicle(
                    id: doc.documentID,
                    make: make,
                    model: model,
                    year: year,
                    mileage: mileage,
                    imageURL: imageURL,
                    createdAt: createdAt
                )
            }

            onChange(.success(vehicles))
        }

        return ListenerToken(registration: registration)
    }
    func createVehicle(userId: String, vehicle: Vehicle) async throws {
           let data: [String: Any] = [
               "make": vehicle.make,
               "model": vehicle.model,
               "year": vehicle.year,
               "mileage": vehicle.mileage,
               "imageURL": vehicle.imageURL as Any,
               "createdAt": Timestamp(date: vehicle.createdAt)
           ]

           try await vehiclesCollection(userId: userId)
               .document(vehicle.id)
               .setData(data, merge: false)
       }

       func updateVehicle(userId: String, vehicle: Vehicle) async throws {
           let data: [String: Any] = [
               "make": vehicle.make,
               "model": vehicle.model,
               "year": vehicle.year,
               "mileage": vehicle.mileage,
               "imageURL": vehicle.imageURL as Any
           ]

           try await vehiclesCollection(userId: userId)
               .document(vehicle.id)
               .setData(data, merge: true)
       }

    func deleteVehicle(userId: String, vehicleId: String) async throws {
        try await vehiclesCollection(userId: userId)
            .document(vehicleId)
            .delete()
    }
}

private final class ListenerToken: AnyCancellableToken {
    private var registration: ListenerRegistration?
    init(registration: ListenerRegistration) { self.registration = registration }
    func cancel() { registration?.remove(); registration = nil }
    deinit { cancel() }
}
