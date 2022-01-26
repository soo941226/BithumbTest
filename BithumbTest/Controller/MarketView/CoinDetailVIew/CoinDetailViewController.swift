//
//  CoinDetailViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class CoinDetailViewController: UIViewController {
    weak var coordinator: MarketCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.pop()
    }
}
