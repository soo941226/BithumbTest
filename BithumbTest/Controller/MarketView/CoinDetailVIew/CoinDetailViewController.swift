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
    private let lienarChartView = LinearChartView<Double>()
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
        
        if let rate = coin?.dailyChangedRate, let rateValue = Double(rate) {
            if rateValue > 0 {
                headerView.textColor = .redIncreased
            } else {
                headerView.textColor = .blueDecreased
            }
        }
        
        orderbookViewController.configure(with: coin?.symbol)
    }
}

// MARK: - basic set up
private extension CoinDetailViewController {
    func addSubViews() {
        view.addSubview(headerView)
        view.addSubview(lienarChartView)
        
        addChild(orderbookViewController)
        view.addSubview(orderbookViewController.view)
    }
    
    func layoutSubviews() {
        guard let orderBookView = orderbookViewController.view else { return }
        
        let safeArea = view.safeAreaLayoutGuide
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            headerView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.5)
        ])
        
        lienarChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lienarChartView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            lienarChartView.leadingAnchor.constraint(equalTo: headerView.trailingAnchor),
            lienarChartView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            lienarChartView.heightAnchor.constraint(equalTo: headerView.heightAnchor)
        ])
        
        orderBookView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            orderBookView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            orderBookView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            orderBookView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            orderBookView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
