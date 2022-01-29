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
    private var stuffs = [Stuff]()

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
        WSOrderbookAPI(symbols: [symbol]).excute { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let orderBooks):
                self.updateDataSource(with: orderBooks)
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

                self.requestOrderbooksContinuoussly()

                DispatchQueue.main.async {
                    self.sendToDataSource(data)
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

    func sendToDataSource(_ data: HTTPOrderbook) {
        let asks = data.asks.sorted { $0.price > $1.price }
        let bids = data.bids.sorted { $0.price > $1.price }
        stuffs = asks + bids
        dataSource.configure(with: stuffs)
        tableView.reloadData()
    }

    func updateDataSource(with orderbooks: [WSOrderbook]) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            for orderbook in orderbooks {
                guard let stuff = orderbook.stuff,
                      let orderType = orderbook.orderType else {
                          continue
                      }
                let target = self.stuffs
                let index = self.findIndex(with: stuff, from: .zero, to: target.count, within: target)

                if index >= 0 {
                    self.stuffs[index].quantity += stuff.quantity
                }
            }
            self.dataSource.configure(with: self.stuffs)
            self.tableView.reloadData()
        }
    }

    func findIndex(
        with target: Stuff,
        from startIndex: Int,
        to endIndex: Int,
        within array: [Stuff]
    ) -> Int {
        guard startIndex < array.count,
              endIndex >= .zero,
              startIndex < endIndex else {
            return -1
        }

        if startIndex > endIndex {
            let prev = abs(array[startIndex].price - target.price)
            let next = abs(array[endIndex].price - target.price)

            if prev > next {
                return startIndex
            } else {
                return endIndex
            }
        }

        let midIndex = (startIndex + endIndex) / 2
        let middle = array[midIndex]

        if target.price == middle.price {
            return midIndex
        } else if target.price < middle.price {
            return findIndex(
                with: target,
                from: midIndex + 1,
                to: endIndex,
                within: array
            )
        } else {
            return findIndex(
                with: target,
                from: startIndex,
                to: midIndex - 1,
                within: array
            )
        }
    }
}
