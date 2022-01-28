//
//  OrderbookViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class OrderbookViewController: UIViewController {
    private let tableView = UITableView()
    private let dataSource = OrderbookDataSource()
    private let delegate = OrderbookDelegate()
    private var symbol: Symbol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestOrderbooks()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setUpDataSource()
    }
}

// MARK: - Facade
extension OrderbookViewController {
    func configure(with symbol: Symbol?) {
        self.symbol = symbol
    }
}

// MARK: - basic set up
private extension OrderbookViewController {
    func setUpTableView() {
        tableView.delegate = delegate
        tableView.dataSource = dataSource

        view.addSubview(tableView)

        tableView.register(OrderbookViewCell.self, forCellReuseIdentifier: OrderbookViewCell.identifier)

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func setUpDataSource() {
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            dataSource.setTitles()
        } else {
            dataSource.desetTitles()
        }
    }
}

// MARK: - API
private extension OrderbookViewController {
    func requestOrderbooksContinuoussly() {
        guard let symbol = symbol else { return }
        WSOrderbookAPI(symbols: [symbol]).excute { result in
            switch result {
            case .success(let orderBooks):
                print(orderBooks[0].symbol, orderBooks[0].orderType, orderBooks[0].stuff)
//                DispatchQueue.main.async {
////                    dataSource.
//                }
            case .failure:
                return
            }
        }
    }

    func requestOrderbooks() {
        guard let orderCurrency = symbol?.orderCurrency,
              let paymentCurrency = symbol?.paymentCurrency else {
                  return
              }

        HTTPOrderbookAPI(with: orderCurrency, and: paymentCurrency).excute { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                guard let data = response.data else { return }
                let asks = data.asks.sorted { $0.price > $1.price }
                let bids = data.bids.sorted { $0.price > $1.price }
                self.dataSource.configure(with: [asks, bids])
                self.requestOrderbooksContinuoussly()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(
                        at: IndexPath(row: .zero, section: 1),
                        at: .middle,
                        animated: false
                    )
                }
            case .failure:
                // TODO: Show alert
                return
            }
        }
    }
}
