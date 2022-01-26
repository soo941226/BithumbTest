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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
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
}

// MARK: - API
private extension OrderbookViewController {
    func request() {
        guard let orderCurrency = symbol?.orderCurrency,
              let paymentCurrency = symbol?.paymentCurrency else {
                  return
              }

        HTTPOrderbookAPI(with: orderCurrency, and: paymentCurrency).excute { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                guard let data = response.data else { return }
                self.dataSource.configure(with: [data.bids, data.asks])

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case . failure(let error):
                print(error)
            }
        }
    }
}
