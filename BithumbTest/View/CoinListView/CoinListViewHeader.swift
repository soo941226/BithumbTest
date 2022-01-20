//
//  CoinListViewHeader.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

class CoinListViewHeader: UITableViewHeaderFooterView {
    static let identifier = #fileID

    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.text = "가상자산명"
        return label
    }()
    private let currentPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "현재가"
        return label
    }()
    private let changedRateLabel: UILabel = {
        let label = UILabel()
        label.text = "변동률"
        return label
    }()
    private let tradedPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "거래금액"
        return label
    }()

    private let containerStackView = UIStackView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setUpContents()
    }

    override func layoutMarginsDidChange() {
        layoutContents()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutContents()
    }
}

// MARK: - private methods for layout contents
private extension CoinListViewHeader {
    func setUp(stackViews: UIStackView...) {
        for stackView in stackViews {
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            stackView.spacing = .zero
        }
    }

    func setUp(labels: UILabel...) {
        for label in labels {
            label.textColor = .black
            label.font = .preferredFont(forTextStyle: .body)
            label.textAlignment = .justified
            label.adjustsFontSizeToFitWidth = true
            label.layer.borderColor = UIColor.lightGray.cgColor

            if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
                label.layer.borderWidth = 1
            } else {
                label.layer.borderWidth = 0
            }
        }
    }

    func setUpContents() {
        setUp(stackViews: containerStackView, firstStackView, secondStackView)
        setUp(labels: symbolLabel, currentPriceLabel, changedRateLabel, tradedPriceLabel)

        firstStackView.addArrangedSubview(symbolLabel)
        firstStackView.addArrangedSubview(currentPriceLabel)

        secondStackView.addArrangedSubview(changedRateLabel)
        secondStackView.addArrangedSubview(tradedPriceLabel)

        containerStackView.addArrangedSubview(firstStackView)
        containerStackView.addArrangedSubview(secondStackView)
        contentView.addSubview(containerStackView)

        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func layoutContents() {
        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
            containerStackView.axis = .vertical
        } else {
            containerStackView.axis = .horizontal
        }
    }
}
