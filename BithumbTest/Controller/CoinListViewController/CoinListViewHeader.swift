//
//  CoinListViewHeader.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

class CoinListViewHeader: UITableViewHeaderFooterView {
    static let identifier = #fileID

    let stackView: UIStackView = {
        let label1 = UILabel()
        label1.text = "원화"
        label1.font = .preferredFont(forTextStyle: .footnote)

        let label2 = UILabel()
        label2.text = "BTC"
        label2.font = .preferredFont(forTextStyle: .footnote)

        let label3 = UILabel()
        label3.text = "보유"
        label3.font = .preferredFont(forTextStyle: .footnote)

        let label4 = UILabel()
        label4.text = "관심"
        label4.font = .preferredFont(forTextStyle: .footnote)

        let stackView = UIStackView(arrangedSubviews: [label1, label2, label3, label4])
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = .pi

        return stackView
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }
}
