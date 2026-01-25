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

        applyTheme()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeChanged),
            name: .appThemeDidChange,
            object: nil
        )
        
        let vehiclesProvider = FirestoreVehiclesManager()
        let garageVC = VehiclesContainerViewController(provider: vehiclesProvider)
        let garageNav = UINavigationController(rootViewController: garageVC)
        garageNav.tabBarItem = UITabBarItem(
            title: "Garage",
            image: UIImage(systemName: "car"),
            tag: 0
        )

        let servicesProvider = FirestoreServicesManager()
        let serviceVC = ServicesContainerViewController(
            provider: servicesProvider,
            vehiclesProvider: vehiclesProvider
        )

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
    
    deinit {
          NotificationCenter.default.removeObserver(self, name: .appThemeDidChange, object: nil)
      }

      @objc private func themeChanged() {
          applyTheme()
      }

    private func applyTheme() {
        let theme = UserDefaults.standard.string(forKey: "appTheme") ?? "light"
        let style: UIUserInterfaceStyle = (theme == "dark") ? .dark : .light

        overrideUserInterfaceStyle = style

        view.window?.overrideUserInterfaceStyle = style
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyTheme()
    }

}


