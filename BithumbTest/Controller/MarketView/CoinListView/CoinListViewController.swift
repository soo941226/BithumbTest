//
//  CoinListViewController.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewController: UIViewController {
    private let containerOfLabels = UIStackView()
    private let labels = [MyLabel(), MyLabel(), MyLabel()]
    private let tableView = UITableView()
    private let coinListDataSource = CoinListViewDataSource()
    private let coinListDelegate = CoinListViewDelegate()

    weak var controlContainer: ControlContainer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpButtons()
        setUpTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutButtons()
        layoutTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
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

// MARK: - basic set up
private extension CoinListViewController {
    @objc func touchUpLabel() {
        print("!")
    }

    func setUpButtons() {
        labels.forEach { label in
            label.textColor = .label
            label.backgroundColor = .systemBackground
            label.font = .preferredFont(forTextStyle: .body)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
            label.adjustsFontForContentSizeCategory = true
            label.accessibilityLabel = "Request button: "

            containerOfLabels.addArrangedSubview(label)
        }
        
        labels[0].text = "KRW"
        labels[1].text = "BTC"
        labels[2].text = "관심"
        labels[0].accessibilityValue = "KRW"
        labels[1].accessibilityValue = "BTC"
        labels[2].accessibilityValue = "관심"

        containerOfLabels.axis = .horizontal
        containerOfLabels.alignment = .leading
        containerOfLabels.distribution = .fillProportionally
        containerOfLabels.spacing = Spacing.basicHorizontalInset
        containerOfLabels.backgroundColor = .secondarySystemBackground

        view.addSubview(containerOfLabels)

        controlContainer?.setUp(with: labels)
    }

    func setUpTableView() {
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

        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerOfLabels.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }

    func layoutButtons() {
        let safeArea = view.safeAreaLayoutGuide

        containerOfLabels.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerOfLabels.topAnchor.constraint(equalTo: safeArea.topAnchor),
            containerOfLabels.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            containerOfLabels.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor)
        ])
    }
}
