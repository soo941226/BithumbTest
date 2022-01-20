//
//  CoinListViewDelegate.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CoinListViewHeader.identifier
        )
        guard let headerView = headerView as? CoinListViewHeader else {
            return UIView()
        }

        return headerView
    }
}
