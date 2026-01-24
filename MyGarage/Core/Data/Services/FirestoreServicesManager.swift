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

    private func servicesCollection(userId: String) -> CollectionReference {
        db.collection("users").document(userId).collection("services")
    }

    // MARK: services

    func observeRecentServices(
        userId: String,
        limit: Int = 50,
        onChange: @escaping (Result<[Service], Error>) -> Void
    ) -> AnyCancellableToken {

        let query = db.collectionGroup("services")
            .whereField("userId", isEqualTo: userId)
            .order(by: "serviceDate", descending: true)
            .limit(to: limit)

        return listen(query: query, onChange: onChange)
    }

    // MARK: Services for specific vehicle
    func observeRecentServices(
        userId: String,
        vehicleName: String,
        limit: Int = 10,
        onChange: @escaping (Result<[Service], Error>) -> Void
    ) -> AnyCancellableToken {

        let query = db.collectionGroup("services")
            .whereField("userId", isEqualTo: userId)
            .whereField("vehicleName", isEqualTo: vehicleName)
            .order(by: "serviceDate", descending: true)
            .limit(to: limit)

        return listen(query: query, onChange: onChange)
    }

    // MARK: Shared listener

    private func listen(
        query: Query,
        onChange: @escaping (Result<[Service], Error>) -> Void
    ) -> AnyCancellableToken {

        let registration = query.addSnapshotListener { snapshot, error in
            if let error {
                onChange(.failure(error))
                return
            }

            guard let snapshot else {
                onChange(.success([]))
                return
            }

            let services: [Service] = snapshot.documents.compactMap { doc in
                let data = doc.data()

                guard
                    let title = data["title"] as? String,
                    let vehicleName = data["vehicleName"] as? String
                else { return nil }

                let cost = (data["cost"] as? NSNumber)?.doubleValue
                let mileage = (data["mileage"] as? NSNumber)?.intValue
                guard let cost, let mileage else { return nil }

                let serviceDate = (data["serviceDate"] as? Timestamp)?.dateValue() ?? Date()
                let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                let iconName = data["iconName"] as? String

                return Service(
                    id: doc.documentID,
                    documentPath: doc.reference.path,
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


    func createService(userId: String, service: Service) async throws {
        let data: [String: Any] = [
            "userId": userId,
            "title": service.title,
            "vehicleName": service.vehicleName,
            "cost": service.cost,
            "mileage": service.mileage,
            "serviceDate": Timestamp(date: service.serviceDate),
            "iconName": service.iconName as Any,
            "createdAt": Timestamp(date: service.createdAt)
        ]

        try await servicesCollection(userId: userId)
            .document(service.id)
            .setData(data, merge: false)
    }

    func updateService(userId: String, service: Service) async throws {
        let data: [String: Any] = [
            "userId": userId,
            "title": service.title,
            "vehicleName": service.vehicleName,
            "cost": service.cost,
            "mileage": service.mileage,
            "serviceDate": Timestamp(date: service.serviceDate),
            "iconName": service.iconName as Any
        ]

        try await servicesCollection(userId: userId)
            .document(service.id)
            .setData(data, merge: true)
    }

    func deleteService(userId: String, serviceId: String) async throws {
        try await servicesCollection(userId: userId)
            .document(serviceId)
            .delete()
    }
}

// MARK: Listener token

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
