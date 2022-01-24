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

    var visibleCells: [CoinListViewCell]? {
        tableView.indexPathsForVisibleRows.flatMap { rows in
            rows.compactMap { row in
                tableView.cellForRow(at: row) as? CoinListViewCell
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
