//
//  CoinListViewCell.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewCell: UITableViewCell {
    static let identifier = #fileID

    private let symbolLabel =  UILabel()
    private let currentPriceLabel = UILabel()
    private let changedRateLabel = UILabel()
    private let tradedPriceLabel = UILabel()

    private let containerStackView = UIStackView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpContents()
        isAccessibilityElement = true
    }

    override func layoutMarginsDidChange() {
        layoutContents()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutContents()
    }
}

// MARK: - Outer interface
extension CoinListViewCell {
    func configure(with coin: HTTPCoin) {
        guard let closingPrice = coin.closingPrice,
              let dailyChangedRate = coin.dailyChangedRate,
              let dailyTradedPriceText = coin.dailyTradedPrice,
              let dailyTradedPrice = Double(dailyTradedPriceText) else {
                  symbolLabel.text = "확인 중"
                  currentPriceLabel.text = "확인 중"
                  changedRateLabel.text = "확인 중"
                  return
              }

        let filteredDailyTradedPrice = Int(dailyTradedPrice / 1000000.0).description + "백만"
        symbolLabel.text = coin.symbol
        currentPriceLabel.text = closingPrice
        changedRateLabel.text = dailyChangedRate
        tradedPriceLabel.text = filteredDailyTradedPrice

        accessibilityLabel = coin.symbol
        accessibilityValue = """
현재가: \(closingPrice.description),
변동률: \(dailyChangedRate.description),
거래가: \(filteredDailyTradedPrice)"
"""
    }
}

// MARK: - private methods for layout contents
private extension CoinListViewCell {
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
            label.font = .preferredFont(forTextStyle: .footnote)
            label.textAlignment = .justified
            label.adjustsFontSizeToFitWidth = true
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.isAccessibilityElement = false
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
            layer.borderWidth = 1
        } else {
            containerStackView.axis = .horizontal
            layer.borderWidth = .zero
        }
    }
}
