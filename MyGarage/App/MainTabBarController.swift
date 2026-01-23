//
//  MainTabBarController.swift
//  MyGarage
//
//  Created by David on 14.01.26.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let vehiclesProvider = FirestoreVehiclesManager()
        let garageVC = VehiclesContainerViewController(provider: vehiclesProvider)
        let garageNav = UINavigationController(rootViewController: garageVC)
        garageNav.tabBarItem = UITabBarItem(
            title: "Garage",
            image: UIImage(systemName: "car"),
            tag: 0
        )

        let servicesProvider = FirestoreServicesManager()
        let serviceVC = ServicesContainerViewController(provider: servicesProvider)
        let serviceNav = UINavigationController(rootViewController: serviceVC)
        serviceNav.tabBarItem = UITabBarItem(
            title: "Service",
            image: UIImage(systemName: "wrench"),
            tag: 1
        )

        let profileVC = ProfileViewController()
        let profileNav = UINavigationController(rootViewController: profileVC)
        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            tag: 2
        )

        viewControllers = [
            garageNav,
            serviceNav,
            profileNav
        ]
    }
}


