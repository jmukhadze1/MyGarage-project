//
//  ServicesContainerViewController.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import UIKit
import SwiftUI
import FirebaseAuth

final class ServicesContainerViewController: UIViewController {

    private let viewModel: ServicesViewModel
    private let provider: ServicesDataProvider
    private let vehiclesProvider: VehiclesDataProvider
    private var vehiclesToken: AnyCancellableToken?
    private var vehicles: [Vehicle] = []
    private var hostingController: UIHostingController<ServicesListView>?

    init(provider: ServicesDataProvider, vehiclesProvider: VehiclesDataProvider) {
        self.provider = provider
        self.vehiclesProvider = vehiclesProvider
        self.viewModel = ServicesViewModel(provider: provider)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        observeVehicles()

        let listView = ServicesListView(
            viewModel: self.viewModel,
            provider: provider,
            vehicles: vehicles
        )

        let hosting = UIHostingController(rootView: listView)
        self.hostingController = hosting

        addChild(hosting)
        view.addSubview(hosting.view)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        hosting.didMove(toParent: self)

    }
    
    private func observeVehicles() {
         guard let userId = Auth.auth().currentUser?.uid else { return }

         vehiclesToken?.cancel()
         vehiclesToken = vehiclesProvider.observeVehicles(userId: userId) { [weak self] result in
             guard let self else { return }
             switch result {
             case .success(let items):
                 self.vehicles = items
                 self.refreshServicesRootView()

             case .failure:
                 self.vehicles = []
                 self.refreshServicesRootView()

             }
         }
     }
    private func refreshServicesRootView() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            self.hostingController?.rootView = ServicesListView(
                viewModel: self.viewModel,
                provider: self.provider,
                vehicles: self.vehicles
            )
        }
    }

     deinit {
         vehiclesToken?.cancel()
     }
}
