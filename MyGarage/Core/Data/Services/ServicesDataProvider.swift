//
//  ServicesDataProvider.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import Foundation

protocol ServicesDataProvider {
    func observeRecentServices(
        userId: String,
        limit: Int,
        onChange: @escaping (Result<[Service], Error>) -> Void
    ) -> AnyCancellableToken
    
    func observeRecentServices(
           userId: String,
           vehicleName: String,
           limit: Int,
           onChange: @escaping (Result<[Service], Error>) -> Void
       ) -> AnyCancellableToken

    
    func createService(userId: String, service: Service) async throws
    func updateService(userId: String, service: Service) async throws
    func deleteService(userId: String, serviceId: String) async throws
    
    
}
