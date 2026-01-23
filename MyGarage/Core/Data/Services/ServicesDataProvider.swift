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

}
