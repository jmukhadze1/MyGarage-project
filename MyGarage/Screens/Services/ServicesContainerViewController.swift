//
//  ServicesContainerViewController.swift
//  MyGarage
//
//  Created by David on 21.01.26.
//

import UIKit
import SwiftUI

final class ServicesContainerViewController: UIViewController {

    private let viewModel: ServicesViewModel
    private let provider: ServicesDataProvider

    init(provider: ServicesDataProvider) {
        self.provider = provider
        self.viewModel = ServicesViewModel(provider: provider)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let listView = ServicesListView(
            viewModel: self.viewModel,
            onAddTapped: { [weak self] in
                guard let self else { return }

                let vc = UIViewController()
                vc.view.backgroundColor = .systemBackground
                vc.title = "New Service"

                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .formSheet
                self.present(nav, animated: true)


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
}
