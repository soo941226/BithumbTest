//
//  OrderbookDelegate.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/26.
//

import UIKit

final class OrderbookDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? OrderbookViewCell else { return }

        if indexPath.section == .zero {
            cell.backgroundColor = .blueDecreased
            cell.fontColor = .light
        } else {
            cell.backgroundColor = .redIncreased
            cell.fontColor = .dark
        }
    }
}
