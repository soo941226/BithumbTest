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
    private var sourceOfTruth = [WSOrderbook]()

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestOrderbooks()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        WSOrderbookAPI.cancel()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
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
        tableView.register(OrderbookViewCell.self, forCellReuseIdentifier: OrderbookViewCell.identifier)

        tableView.delegate = delegate
        tableView.dataSource = dataSource
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
}

// MARK: - managing datas
extension OrderbookViewController {
    func sendToDataSource(_ data: HTTPOrderbook) {
        let asks = data.asks
            .sorted { $0.price > $1.price }
            .map { stuff in
                WSOrderbook(symbol: symbol, orderType: .ask, stuff: stuff, total: nil)
            }
        let bids = data.bids
            .sorted { $0.price > $1.price }
            .map { stuff in
                WSOrderbook(symbol: symbol, orderType: .bid, stuff: stuff, total: nil)
            }

        sourceOfTruth = asks + bids
        dataSource.configure(with: sourceOfTruth)
        tableView.reloadData()
    }

    func updateDataSource(with orderbooks: [WSOrderbook]) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            for orderbook in orderbooks {
                self.updateSourceOfTruth(with: orderbook)
            }

            self.dataSource.configure(with: self.sourceOfTruth)
            self.tableView.reloadData()
        }
    }

    func updateSourceOfTruth(with orderbook: WSOrderbook) {
        guard let stuff = orderbook.stuff,
              let orderType = orderbook.orderType else {
                  return
              }

        let (index, isInterupt) = findNearestIndex(
            with: orderbook,
            from: .zero,
            to: sourceOfTruth.count,
            within: sourceOfTruth
        )

        guard index >= 0 else { return }

        if isInterupt {
            self.sourceOfTruth.insert(orderbook, at: index)
            if case .ask = orderbook.orderType {
                sourceOfTruth.removeFirst()
            } else {
                sourceOfTruth.removeLast()
            }
        } else {
            sourceOfTruth[index].update(with: orderType, and: stuff)

            /*
             TODO: - 도메인 이해 부족... 사후처리를 어떻게 할 것인지...
                case 1. 최저 매도가보다 더 높은 가격이 더 많이 매수를 시도했다면?
                case 2. 최대 매수가보다 더 낮은 가격에 더 많이 매도를 시도했다면?
                정말로 그 가격에 사고 팔리는 것인지...
                아니라면 위와 같은 경우 중간에 어정쩡하게 range에 속하는 애들은 최저가부터 차근차근 사라지는 것인지...
             */
        }
    }

    func findNearestIndex(
        with target: WSOrderbook,
        from startIndex: Int,
        to endIndex: Int,
        within array: [WSOrderbook]
    ) -> (index: Int, isInterupt: Bool) {
        guard startIndex < array.count, endIndex >= .zero else {
            return (-1, false)
        }

        let midIndex = (startIndex + endIndex) / 2

        guard let stuff = target.stuff,
              let compareTarget = array[midIndex].stuff else {
                  return (-1, false)
              }

        if  startIndex > endIndex,
            let prevStuff = array[startIndex].stuff,
            let nextStuff = array[endIndex].stuff {
            let prev = abs(stuff.price - prevStuff.price)
            let next = abs(stuff.price - nextStuff.price)

            if prev > next {
                return (startIndex, true)
            } else {
                return (endIndex, true)
            }
        }

        if stuff.price == compareTarget.price {
            return (midIndex, false)
        } else if stuff.price < compareTarget.price {
            return findNearestIndex(
                with: target,
                from: midIndex + 1,
                to: endIndex,
                within: array
            )
        } else {
            return findNearestIndex(
                with: target,
                from: startIndex,
                to: midIndex - 1,
                within: array
            )
        }
    }

}
