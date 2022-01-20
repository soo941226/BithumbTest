//
//  CoinListViewDataSource.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewDataSource: NSObject, UITableViewDataSource {
    private(set) var items = [HTTPCoin]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinListViewCell.identifier,
            for: indexPath
        )
        guard let cell = cell as? CoinListViewCell else { return CoinListViewCell() }

        let coin = items[indexPath.row]
        cell.configure(with: coin)
        return cell
    }
}

// MARK: - outer interface
extension CoinListViewDataSource {
    func configure(items: [HTTPCoin]) {
        self.items = items
    }
}
