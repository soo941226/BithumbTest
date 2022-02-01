//
//  CoinListViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewController: UIViewController {
    private let stackView = UIStackView()
    private let buttons = [UIButton(), UIButton(), UIButton(), UIButton()]
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

    override func viewWillDisappear(_ animated: Bool) {
        coinListDelegate.dataManager?.stopManaging()
    }
}

// MARK: - Facade
extension CoinListViewController {
    func configure(items: [HTTPCoin]) {
        DispatchQueue.main.async { [weak self] in
            self?.coinListDataSource.configure(items: items)
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(
                at: IndexPath(row: .zero, section: .zero),
                at: .top,
                animated: false
            )
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
        buttons.forEach { button in
            button.setTitle("HIHI", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
            stackView.addArrangedSubview(button)
        }
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

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
        view.addSubview(stackView)
        view.addSubview(tableView)
    }

    func layoutTableView() {
        let safeArea = view.safeAreaLayoutGuide

        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}
