//
//  LinearChartViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/31.
//

import UIKit

final class LinearChartViewController: UIViewController {
    private var symbol: Symbol?
    private var chartType = ChartType.day

    override func loadView() {
        view = LinearChartView<Double>()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestChartData()
    }
}

// MARK: - Facade
extension LinearChartViewController {
    func configure(with symbol: Symbol?) {
        self.symbol = symbol
    }
}

// MARK: - API
private extension LinearChartViewController {
    func requestChartData() {
        guard let symbol = symbol,
              let orderCurrency = symbol.orderCurrency,
              let paymentCurrency = symbol.paymentCurrency else {
                  return
              }

        HTTPChartAPI(
            orderCurrency: orderCurrency,
            paymentCurrnecy: paymentCurrency,
            type: chartType
        ).excute { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let response):
                let asset = response.chartData?
                    .sorted(by: { prev, next in
                        prev.timestamp < next.timestamp
                    })
                    .compactMap({ chartDatum in
                        Double(chartDatum.marketPrice)
                    })

                self.drawChart(with: asset ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - basic set up
private extension LinearChartViewController {
    func drawChart(with asset: [Double]) {
        DispatchQueue.main.async { [weak self] in
            guard let view = self?.view as? LinearChartView<Double> else { return }

            view.setUp(with: asset)

            do {
                try view.drawChart()
            } catch {
                print(error)
            }
        }
    }
}
