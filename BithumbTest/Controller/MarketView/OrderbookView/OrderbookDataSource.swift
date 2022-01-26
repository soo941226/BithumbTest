//
//  OrderbookDataSource.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class OrderbookDataSource: NSObject, UITableViewDataSource {
    private var items = [[Stuff]]()

    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderbookViewCell.identifier, for: indexPath)

        guard let cell = cell as? OrderbookViewCell else {
            return OrderbookViewCell()
        }

        cell.configure(with: items[indexPath.section][indexPath.row])

        return cell
    }
}

// MARK: - Facade
extension OrderbookDataSource {
    func configure(with items: [[Stuff]]) {
        self.items = items
    }
}
