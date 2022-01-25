//
//  RootCoordinator.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class RootCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
        navigationController.navigationBar.isHidden = true
    }

    func start() {
        let marketCoordinator = MarketCoordinator(navigationController: navigationController)
        childCoordinators.append(marketCoordinator)
        marketCoordinator.start()
    }
}
