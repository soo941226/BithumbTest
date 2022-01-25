//
//  MarketCoordinator.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class MarketCoordinator: Coordinator {
    var childCoordinators =  [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let marketViewController = RootViewController()
        navigationController.pushViewController(marketViewController, animated: false)
        marketViewController.coordinator = self
    }

    func show(with symbol: Symbol) {

    }
}
