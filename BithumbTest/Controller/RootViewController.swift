//
//  RootViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import UIKit

class MyVC1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
}

class MyVC2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
    }
}

class RootViewController: UITabBarController {
    let vc1 = MyVC1()
    let vc2 = MyVC2()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = false
        vc1.tabBarItem = .init(tabBarSystemItem: .favorites, tag: 0)
        vc2.tabBarItem = .init(tabBarSystemItem: .bookmarks, tag: 1)
        viewControllers = [vc1, vc2]
        setViewControllers(viewControllers, animated: true)

        view.backgroundColor = .white

        WSTransactionRequester(symbols: [
            Symbol(orderCurrency: .BTC, paymentCurrency: .KRW),
            Symbol(orderCurrency: .ETH, paymentCurrency: .KRW)
        ]).excute { result in
            switch result {
            case .success(let s):
                print(s)
            case .failure(let e):
                print(e)
            }
        }
    }
}
