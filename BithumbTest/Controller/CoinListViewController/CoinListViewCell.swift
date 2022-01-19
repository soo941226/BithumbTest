//
//  CoinListViewCell.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewCell: UITableViewCell {
    static let identifier = #fileID
    
    var symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(symbolLabel)
        layoutSymbolLabel()
    }
}

private extension CoinListViewCell {
    func layoutSymbolLabel() {
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            symbolLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            symbolLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
