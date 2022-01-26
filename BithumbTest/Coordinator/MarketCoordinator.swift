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

    lazy var marketViewController: UINavigationController = {
        let marketViewController = MarketViewController()
        marketViewController.navigationBar.isHidden = true
        marketViewController.coordinator = self
        return marketViewController
    }()

    func show(with coin: HTTPCoin?) {
        let coinDetailViewController = CoinDetailViewController()
        coinDetailViewController.coordinator = self
        marketViewController.navigationBar.isHidden = false
        marketViewController.pushViewController(coinDetailViewController, animated: true)
        coinDetailViewController.configure(with: coin)
    }

    func pop() {
        marketViewController.navigationBar.isHidden = true
    }
}
