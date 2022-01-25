//
//  CoinListViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewController: UIViewController {
    private let tableView = UITableView()
    private let coinListDataSource = CoinListViewDataSource()
    private let coinListDelegate = CoinListViewDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        layoutTableView()
        
        coinListDelegate.dataManager?.restartManaging()
    }
}

// MARK: - Facade
extension CoinListViewController {
    func configure(items: [HTTPCoin]) {
        DispatchQueue.main.async { [weak self] in
            self?.coinListDataSource.configure(items: items)
            self?.tableView.reloadData()
            self?.tableView.setContentOffset(.zero, animated: false)
        }
    }

    func setUpDataManagerDelegate<Controller: DataManager>(_ delegete: Controller) {
        self.coinListDelegate.dataManager = delegete
    }

    func updateRow(with symbol: Symbol?) {
        let indexPaths: [IndexPath]? = tableView
            .indexPathsForVisibleRows?
            .compactMap { indexPath in
                if coinListDataSource[indexPath].symbol == symbol {
                    return indexPath
                } else {
                    return nil
                }
            }

        tableView.reloadRows(at: indexPaths ?? [], with: .none)
    }

    var visibleData: [HTTPCoin]? {
        tableView.indexPathsForVisibleRows.flatMap { indexPaths in
            indexPaths.compactMap { indexPath in
                coinListDataSource[indexPath]
            }
        }
    }
}

// MARK: - Setting TableView
private extension CoinListViewController {
    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            CoinListViewCell.self,
            forCellReuseIdentifier: CoinListViewCell.identifier
        )

        tableView.register(
            CoinListViewHeader.self,
            forHeaderFooterViewReuseIdentifier: CoinListViewHeader.identifier
        )
        tableView.dataSource = coinListDataSource
        tableView.delegate = coinListDelegate
        view.addSubview(tableView)
    }

    func layoutTableView() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
