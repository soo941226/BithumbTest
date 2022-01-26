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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataManager?.showDetail(with: indexPath)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dataManager?.stopManaging()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dataManager?.restartManaging()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        dataManager?.stopManaging()
        dataManager?.restartManaging()
    }
}
