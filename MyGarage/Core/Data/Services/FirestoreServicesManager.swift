//
//  FirestoreServicesManager.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import Foundation
import FirebaseFirestore

final class FirestoreServicesManager: ServicesDataProvider {

    private let db = Firestore.firestore()

    func observeRecentServices(
        userId: String,
        limit: Int = 50,
        onChange: @escaping (Result<[Service], Error>) -> Void
    ) -> AnyCancellableToken {

        let query = db.collectionGroup("services")
            .whereField("userId", isEqualTo: userId)
            .order(by: "serviceDate", descending: true)
            .limit(to: limit)

        let registration = query.addSnapshotListener { snapshot, error in
            if let error {
                onChange(.failure(error))
                return
            }

            guard let snapshot else {
                onChange(.success([]))
                return
            }

            let services: [Service] = snapshot.documents.compactMap { document in
                let data = document.data()

                guard
                    let title = data["title"] as? String,
                    let vehicleName = data["vehicleName"] as? String
                else { return nil }

                // MARK: Cost 
                let cost: Double? = {
                    if let doubleCost = data["cost"] as? Double { return doubleCost }
                    if let intCost = data["cost"] as? Int { return Double(intCost) }
                    if let numberCost = data["cost"] as? NSNumber { return numberCost.doubleValue }

                    if let doublePrice = data["price"] as? Double { return doublePrice }
                    if let intPrice = data["price"] as? Int { return Double(intPrice) }
                    if let numberPrice = data["price"] as? NSNumber { return numberPrice.doubleValue }

                    return nil
                }()

                // MARK: Mileage
                let mileage: Int? = {
                    if let intMileage = data["mileage"] as? Int { return intMileage }
                    if let doubleMileage = data["mileage"] as? Double { return Int(doubleMileage) }
                    if let numberMileage = data["mileage"] as? NSNumber { return numberMileage.intValue }
                    return nil
                }()

                guard let cost, let mileage else { return nil }

                // MARK: Dates
                let serviceDate: Date = {
                    if let timestamp = data["serviceDate"] as? Timestamp {
                        return timestamp.dateValue()
                    }
                    return Date()
                }()

                let createdAt: Date = {
                    if let timestamp = data["createdAt"] as? Timestamp {
                        return timestamp.dateValue()
                    }
                    return Date()
                }()

                let iconName = data["iconName"] as? String

                return Service(
                    id: document.documentID,
                    title: title,
                    vehicleName: vehicleName,
                    cost: cost,
                    mileage: mileage,
                    serviceDate: serviceDate,
                    iconName: iconName,
                    createdAt: createdAt
                )
            }

            onChange(.success(services))
        }

        return ServicesListenerToken(registration: registration)
    }
}

private final class ServicesListenerToken: AnyCancellableToken {
    private var registration: ListenerRegistration?

    init(registration: ListenerRegistration) {
        self.registration = registration
    }

    func cancel() {
        registration?.remove()
        registration = nil
    }

    deinit { cancel() }
}
