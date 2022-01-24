//
//  RootViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import UIKit

class MyVC2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
}

final class RootViewController: UITabBarController {
    private let coinListViewController = CoinListViewController()
    private let vc2 = MyVC2()
    private var paymentCurrency = PaymentCurrency.KRW

    private var sourceOfTruth = [HTTPCoin]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViewControllers()
        requestCoins()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let notificationIdentifier = Notification.Name(CoinListViewHeader.identifier)

        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(onReceiveNotification),
                name: notificationIdentifier,
                object: nil
            )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension RootViewController: DataManager {
    func stopManaging() {
        WSTickerAPI.cancel()
    }

    func restartManaging() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            guard let cells = self.coinListViewController.visibleCells else { return }
            let symbols: [Symbol] = cells.compactMap {
                guard let symbol = $0.symbol else { return nil }

                return Symbol(orderCurrency: symbol, paymentCurrency: self.paymentCurrency)
            }

            WSTickerAPI(symbols: symbols, tickTypes: [TickType.oneHour]).excute { result in
                switch result {
                case .success(let coin):
                    print(coin)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - API
private extension RootViewController {
    func requestCoins() {
        HTTPTickerAllAPI(with: paymentCurrency).excute { [weak self] result in
            switch result {
            case .success(let response):
                var coins = [HTTPCoin]()

                for key in response.data.keys {
                    guard let value = response.data[key] else { continue }
                    guard case .coin(let coin) = value else { continue }

                    coin.updateSymbol(with: key)
                    coins.append(coin)
                }

                self?.sourceOfTruth = coins
                self?.sourceOfTruth = self?.sortByCurrentTradedVolumne(arrow: .descending) ?? coins
                self?.sortBy(key: .tradedVolume, arrow: .none)
            case .failure:
                print("HTTPTickerAllAPI X")
            }
        }
    }
}

// MARK: - Set up layout and display
private extension RootViewController {
    func setUpSubViewControllers() {
        coinListViewController.tabBarItem = .init(
            title: "List",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.indent")
        )
        coinListViewController.setUpDataManagerDelegate(self)

        vc2.tabBarItem = .init(tabBarSystemItem: .bookmarks, tag: 1)
        viewControllers = [coinListViewController, vc2]
        setViewControllers(viewControllers, animated: true)
    }
}

// MARK: - sorting data
private extension RootViewController {
    @objc private func onReceiveNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let sortingKey = userInfo["key"] as? Int,
              let directionRawValue = userInfo["direction"] as? Int,
              let direction = SortDirection(rawValue: directionRawValue) else {
                  return
              }

        switch sortingKey {
        case 0:
            sortBy(key: .symbol, arrow: direction)
        case 1:
            sortBy(key: .currentPrice, arrow: direction)
        case 2:
            sortBy(key: .changedRate, arrow: direction)
        default:
            sortBy(key: .tradedVolume, arrow: direction)
        }
    }

    private func sortBy(key: CoinSortingKey, arrow: SortDirection) {
        let coins: [HTTPCoin]

        if arrow == .none {
            coins = sourceOfTruth
        } else {
            switch key {
            case .symbol:
                coins = sortBySymbol(arrow: arrow)
            case .changedRate:
                coins = sortByChangedRate(arrow: arrow)
            case .tradedVolume:
                coins = sortByCurrentTradedVolumne(arrow: arrow)
            default:
                coins = sortByCurrentPrice(arrow: arrow)
            }
        }

        coinListViewController.configure(items: coins)
        stopManaging()
        restartManaging()
    }

    func sortBySymbol(arrow: SortDirection) -> [HTTPCoin] {
        sourceOfTruth.sorted {
            guard let prevSymbol = $0.symbol,
                  let nextSymbol = $1.symbol else {
                      return false
                  }
            if case .descending = arrow {
                return prevSymbol > nextSymbol
            } else {
                return prevSymbol < nextSymbol
            }
        }
    }

    func sortByChangedRate(arrow: SortDirection) -> [HTTPCoin] {
        sourceOfTruth.sorted {
            guard let prevRate = $0.dailyChangedRate.flatMap({ Double($0) }),
                  let nextRate = $1.dailyChangedRate.flatMap({ Double($0) }) else {
                      return false
                  }
            if case .descending = arrow {
                return prevRate > nextRate
            } else {
                return prevRate < nextRate
            }
        }
    }

    func sortByCurrentTradedVolumne(arrow: SortDirection) -> [HTTPCoin] {
        sourceOfTruth.sorted {
            guard let prevVolume = $0.currentTradedPrice.flatMap({ Double($0) }),
                  let nextVolume = $1.currentTradedPrice.flatMap({ Double($0) }) else {
                      return false
                  }
            if case .descending = arrow {
                return prevVolume > nextVolume
            } else {
                return prevVolume < nextVolume
            }
        }
    }

    func sortByCurrentPrice(arrow: SortDirection) -> [HTTPCoin] {
        sourceOfTruth.sorted {
            guard let prevPrice = $0.closingPrice.flatMap({ Double($0) }),
                  let nextPrice = $1.closingPrice.flatMap({ Double($0) }) else {
                      return false
                  }
            if case .descending = arrow {
                return prevPrice > nextPrice
            } else {
                return prevPrice < nextPrice
            }
        }
    }
}
