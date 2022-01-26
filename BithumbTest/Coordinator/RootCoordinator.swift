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

    private let rootViewController = UITabBarController()

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController

        setUpNavigationController()
    }

    func start() {
        let marketCoordinator = MarketCoordinator(navigationController: navigationController)
        childCoordinators.append(marketCoordinator)
        setUpMarketViewController(with: marketCoordinator)
    }

    private func setUpNavigationController() {
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(rootViewController, animated: true)
    }

    private func setUpMarketViewController(with marketCoordinator: MarketCoordinator) {
        let marketViewController = marketCoordinator.marketViewController
        marketViewController.tabBarItem = .init(
            title: "List",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.indent")
        )

        rootViewController.viewControllers = [marketViewController]
        rootViewController.setViewControllers(rootViewController.viewControllers, animated: false)
    }
}
