//
//  CoinListViewDelegate.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewDelegate: NSObject, UITableViewDelegate {
    weak var dataManager: DataManager?

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CoinListViewHeader.identifier
        )
        guard let headerView = headerView as? CoinListViewHeader else {
            return UIView()
        }

        return headerView
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dataManager?.stopManaging()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dataManager?.restartManaging()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        NotificationCenter.default.removeObserver(self)
        dataManager?.stopManaging()
        dataManager?.restartManaging()
    }
}
