//
//  OrderbookDataSource.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class OrderbookDataSource: NSObject, UITableViewDataSource {
    private var asks = [WSOrderbook]()
    private var bids = [WSOrderbook]()
    private var titles: [String]?

    func numberOfSections(in tableView: UITableView) -> Int {
        return OrderType.allCases.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titles?[section] ?? nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == OrderType.ask.section {
            return asks.count
        } else {
            return bids.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderbookViewCell.identifier, for: indexPath)

        guard let cell = cell as? OrderbookViewCell else {
            return OrderbookViewCell()
        }

        if indexPath.section == OrderType.ask.section {
            cell.configure(with: asks[indexPath.row].stuff)
        } else {
            cell.configure(with: bids[indexPath.row].stuff)
        }

        return cell
    }
}

// MARK: - Facade
extension OrderbookDataSource {
    func configure(with items: [WSOrderbook]) {
        var asks = [WSOrderbook]()
        var bids = [WSOrderbook]()
        items.forEach {
            if $0.orderType == .ask {
                asks.append($0)
            } else if $0.orderType == .bid {
                bids.append($0)
            }
        }
        self.asks = asks
        self.bids = bids
    }
}
