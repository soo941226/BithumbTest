//
//  MarketViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/17.
//

import UIKit

final class MarketViewController: UINavigationController, AlertRepresentable {
    private let rootViewController = CoinListViewController()

    private var sourceOfTruth = [HTTPCoin]()
    private var paymentCurrency = Symbol.KRW

    weak var coordinator: MarketCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBasicSettings()
        requestCoins()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startObservingToUpdateState()
        startObservingToSortData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObserving()
    }
}

// MARK: - Facade
extension MarketViewController {
    func showDetailViewController(with coin: HTTPCoin) {
        coordinator?.show(with: coin)
    }
}

// MARK: - basic set up
private extension MarketViewController {
    func setUpBasicSettings() {
        rootViewController.controlContainer = self
        rootViewController.setUpDataManagerDelegate(self)
        pushViewController(rootViewController, animated: false)
    }
}

// MARK: - Observe notifications
private extension MarketViewController {
    func startObservingToUpdateState() {
        let notificationIdentifier = Notification.Name(CoinListViewCell.identifier)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onReceiveToUpdateState),
            name: notificationIdentifier,
            object: nil
        )
    }

    func startObservingToSortData() {
        let notificationIdentifier = Notification.Name(CoinListViewHeader.identifier)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onReceiveToSort),
            name: notificationIdentifier,
            object: nil
        )
    }

    func stopObserving() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func onReceiveToUpdateState(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let symbol = userInfo[CDCoin.symbol] as? String,
              let isFavorite = userInfo[CDCoin.isFavorite] as? Bool else {
                  return
              }

        sourceOfTruth
            .filter { $0.symbol == symbol }
            .first?
            .updateFavoirte(with: isFavorite)

        CDCoin.updateFavoriteCoin(symbol: symbol, isFavorite: isFavorite)
        rootViewController.updateRow(with: symbol)
    }

    @objc func onReceiveToSort(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let key = userInfo[CoinListViewHeader.key] as? Int,
              let sortingKey = CoinSortingKey(rawValue: key),
              let directionRawValue = userInfo[CoinListViewHeader.direction] as? Int,
              let direction = SortDirection(rawValue: directionRawValue) else {
                  return
              }

        stopManaging()
        sortBy(key: sortingKey, arrow: direction)
        restartManaging()
    }
}

// MARK: - DataManager Delegate
extension MarketViewController: DataManager {
    func showDetail(with indexPath: IndexPath) {
        let coin = sourceOfTruth[indexPath.row]
        coordinator?.show(with: coin)
    }

    func stopManaging() {
        WSTickerAPI.cancel()
    }

    func restartManaging() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            guard let cells = self.rootViewController.visibleData else { return }
            let symbols: [Symbol] = cells.compactMap {
                guard let symbol = $0.symbol else { return nil }

                return symbol
            }

            self.requestCoinsContinuoussly(with: symbols)
        }
    }
}

// MARK: - ControlContainer delegate
extension MarketViewController: ControlContainer {
    func setUp(with views: [UIView]) {
        guard let views = views as? [UILabel],
              views.count == 3 else {
                  return
              }
        views.forEach { $0.isUserInteractionEnabled = true }

        let krwButton = views[0],
            btcButton = views[1],
            favoriteButton = views[2]

        let krwButtonTapGesture = UITapGesture(
            target: self,
            action: #selector(touchUpKrwButton)
        )
        krwButtonTapGesture.userInfo = ["views": views]
        krwButton.addGestureRecognizer(krwButtonTapGesture)

        let btcButtonTapGesture = UITapGesture(
            target: self,
            action: #selector(touchUpBtcButton)
        )
        btcButtonTapGesture.userInfo = ["views": views]
        btcButton.addGestureRecognizer(btcButtonTapGesture)

        let favoriteButtonTapGesture = UITapGesture(
            target: self,
            action: #selector(touchUpFavoriteButton)
        )
        favoriteButtonTapGesture.userInfo = ["views": views]
        favoriteButton.addGestureRecognizer(favoriteButtonTapGesture)

        addHighlight(on: krwButton)
    }

    @objc private func touchUpBtcButton(sender: UITapGesture) {
        touchUpButton(with: sender)
        paymentCurrency = .BTC
        requestCoins()
    }

    @objc private func touchUpKrwButton(sender: UITapGesture) {
        touchUpButton(with: sender)
        paymentCurrency = .KRW
        requestCoins()
    }

    @objc private func touchUpFavoriteButton(sender: UITapGesture) {
        touchUpButton(with: sender)
    }

    private func touchUpButton(with sender: UITapGesture) {
        guard let labels = sender.userInfo["views"] as? [UILabel],
              let view = sender.view as? UILabel else {
                  return
              }

        deleteHighlight(on: labels)
        addHighlight(on: view)
    }

    private func addHighlight(on label: UILabel) {
        label.textColor = .themeColor
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.themeColor.cgColor
    }

    private func deleteHighlight(on labels: [UILabel]) {
        labels.forEach { label in
            label.textColor = .label
            label.layer.borderWidth = 0
        }
    }
}

// MARK: - API
private extension MarketViewController {
    func requestCoinsContinuoussly(with symbols: [Symbol]) {
        WSTickerAPI(symbols: symbols, tickTypes: [TickType.MID]).excute { [weak self] result in
            guard let `self` = self else {return }

            switch result {
            case .success(let coin):
                DispatchQueue.main.async {
                    self.sourceOfTruth
                        .filter { $0.symbol == coin.symbol }
                        .first?
                        .updateBy(coin)

                    self.rootViewController.updateRow(with: coin.symbol)
                }
            case .failure:
                return // nothing to do
            }
        }
    }

    func requestCoins() {
        HTTPTickerAllAPI(with: paymentCurrency).excute { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .success(let response):
                var coins = [HTTPCoin]()
                
                for key in response.dictionary.keys {
                    guard let value = response.dictionary[key] else { continue }
                    guard case .coin(let coin) = value else { continue }
                    coins.append(coin)
                }

                self.sourceOfTruth = coins
                self.sourceOfTruth = self.sortByCurrentTradedVolumne(arrow: .descending)
                self.sortBy(key: .tradedVolume, arrow: .none)
            case .failure(let error):
                guard let error = error as? APIError else {
                    return
                }

                self.showAlert(with: error)
            }
        }
    }
}

// MARK: - sorting data
private extension MarketViewController {
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

        rootViewController.configure(items: coins)
        stopManaging()
        restartManaging()
    }

    func sortBySymbol(arrow: SortDirection) -> [HTTPCoin] {
        sourceOfTruth.sorted {
            guard let prevSymbol = $0.symbol,
                  let nextSymbol = $1.symbol else {
                      return false
                  }
            if case .ascending = arrow {
                return prevSymbol < nextSymbol
            } else {
                return prevSymbol > nextSymbol
            }
        }
    }

    func sortByChangedRate(arrow: SortDirection) -> [HTTPCoin] {
        sourceOfTruth.sorted {
            guard let prevRate = $0.dailyChangedRate?.description.flatMap({ Double($0) }),
                  let nextRate = $1.dailyChangedRate?.description.flatMap({ Double($0) }) else {
                      return false
                  }
            if case .ascending = arrow {
                return prevRate < nextRate
            } else {
                return prevRate > nextRate
            }
        }
    }

    func sortByCurrentTradedVolumne(arrow: SortDirection) -> [HTTPCoin] {
        sourceOfTruth.sorted {
            guard let prevVolume = $0.currentTradedPrice.flatMap({ Double($0) }),
                  let nextVolume = $1.currentTradedPrice.flatMap({ Double($0) }) else {
                      return false
                  }
            if case .ascending = arrow {
                return prevVolume < nextVolume
            } else {
                return prevVolume > nextVolume
            }
        }
    }

    func sortByCurrentPrice(arrow: SortDirection) -> [HTTPCoin] {
        sourceOfTruth.sorted {
            guard let prevPrice = $0.closePrice.flatMap({ Double($0) }),
                  let nextPrice = $1.closePrice.flatMap({ Double($0) }) else {
                      return false
                  }
            if case .ascending = arrow {
                return prevPrice < nextPrice
            } else {
                return prevPrice > nextPrice
            }
        }
    }

    enum CoinSortingKey: Int {
        case symbol
        case currentPrice
        case changedRate
        case tradedVolume
    }
}
