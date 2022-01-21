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
    let coinListViewController = CoinListViewController()
    let vc2 = MyVC2()

    private var sourceOfTruth = [HTTPCoin]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViewControllers()
        requestCoins()
    }
}

// MARK: - Facade
extension RootViewController {
    func sortBy(key: CoinSortingKey, arrow: SortDirection) {
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
    }
}

// MARK: - API
private extension RootViewController {
    func requestCoins() {
        HTTPTickerAllAPI(paymentCurrency: .KRW).excute { [weak self] result in
            switch result {
            case .success(let response):
                var coins = [HTTPCoin]()

                for key in response.data.keys {
                    guard let value = response.data[key] else { continue }
                    guard case .coin(var coin) = value else { continue }

                    coin.updateSymbol(with: key)
                    coins.append(coin)
                }

                self?.sourceOfTruth = coins
                self?.sortBy(key: .tradedVolume, arrow: .descending)
                self?.coinListViewController.configure(items: coins)
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
        vc2.tabBarItem = .init(tabBarSystemItem: .bookmarks, tag: 1)
        viewControllers = [coinListViewController, vc2]
        setViewControllers(viewControllers, animated: true)
    }
}

// MARK: - sorting data
private extension RootViewController {
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
            guard let prevVolume = $0.currentTradedVolume.flatMap({ Double($0) }),
                  let nextVolume = $1.currentTradedVolume.flatMap({ Double($0) }) else {
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
