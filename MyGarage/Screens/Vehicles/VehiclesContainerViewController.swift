//
//  VehiclesContainerViewController.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import UIKit
import SwiftUI

final class VehiclesContainerViewController: UIViewController {
    private let viewModel: VehiclesViewModel
    private let provider: VehiclesDataProvider

    init(provider: VehiclesDataProvider) {
        self.provider = provider
        self.viewModel = VehiclesViewModel(provider: provider)
        super.init(nibName: nil, bundle: nil)
        title = "Garage"
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let listView = VehiclesListView(
            viewModel: self.viewModel,
            onAddTapped: { [weak self] in
                guard let self else { return }

                let formViewModel = VehicleFormViewModel(
                    provider: self.provider,
                    mode: .add
                )

                let addVehicleVC = VehicleFormViewController(viewModel: formViewModel)
                let navController = UINavigationController(rootViewController: addVehicleVC)
                self.present(navController, animated: true)
            },

            onEditTapped: { [weak self] vehicle in
                   guard let self else { return }
                   self.presentEditVehicle(vehicle)
               }
        )


        let hosting = UIHostingController(rootView: listView)
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

    private func presentAddVehicle() {
          let vm = VehicleFormViewModel(provider: provider, mode: .add)
          let vc = VehicleFormViewController(viewModel: vm)
          vc.onFinish = { [weak self] in self?.viewModel.start() }
          present(UINavigationController(rootViewController: vc), animated: true)
      }

      private func presentEditVehicle(_ vehicle: Vehicle) {
          let vm = VehicleFormViewModel(provider: provider, mode: .edit(vehicle))
          let vc = VehicleFormViewController(viewModel: vm)
          vc.onFinish = { [weak self] in self?.viewModel.start() }
          present(UINavigationController(rootViewController: vc), animated: true)
      }
}
