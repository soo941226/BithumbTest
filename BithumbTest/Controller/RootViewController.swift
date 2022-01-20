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

    override func viewDidLoad() {
        super.viewDidLoad()
        coinListViewController.tabBarItem = .init(
            title: "List",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.indent")
        )

        vc2.tabBarItem = .init(tabBarSystemItem: .bookmarks, tag: 1)
        viewControllers = [coinListViewController, vc2]
        setViewControllers(viewControllers, animated: true)
        selectedIndex = 0

        HTTPTickerAllAPI(paymentCurrency: .KRW).excute { [weak self] result in
            switch result {
            case .success(let response):
                var arr = [HTTPCoin]()

                for key in response.data.keys {
                    guard let value = response.data[key] else { continue }
                    guard case .coin(var coin) = value else { continue }

                    coin.updateSymbol(with: key)
                    arr.append(coin)
                }

                arr.sort { prev, next in
                    guard let prevValue = prev.closingPrice,
                          let nextValue = next.closingPrice,
                          let prevPrice = Double(prevValue),
                          let nextPrice = Double(nextValue) else {
                              return false
                          }

                    return prevPrice > nextPrice
                }

                self?.coinListViewController.configure(items: arr)
            case .failure:
                print("HTTPTickerAllAPI X")
            }
        }
    }
}
