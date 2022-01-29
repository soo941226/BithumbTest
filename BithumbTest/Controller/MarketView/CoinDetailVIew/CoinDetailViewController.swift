//
//  CoinDetailViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class CoinDetailViewController: UIViewController {
    weak var coordinator: MarketCoordinator?

    private let headerView = CoinDetailHeader()
    private let transactionTableView = UITableView()
    private let orderbookViewController = OrderbookViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubviews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.pop()
    }
}

// MARK: - Facade
extension CoinDetailViewController {
    func configure(with coin: HTTPCoin?) {
        headerView.headline = coin?.symbol
        headerView.changedRate = coin?.dailyChangedRate
        headerView.changedPrice = coin?.dailyChangedPrice

        orderbookViewController.configure(with: coin?.symbol)
    }
}

// MARK: - basic set up
private extension CoinDetailViewController {
    func addSubViews() {
        view.addSubview(headerView)
        addChild(orderbookViewController)
        view.addSubview(orderbookViewController.view)
    }

    func layoutSubviews() {
        let safeArea = view.safeAreaLayoutGuide
        headerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor)
        ])

        if let targetView = orderbookViewController.view {
            targetView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                targetView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                targetView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                targetView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                targetView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
            ])
        }
    }
}
