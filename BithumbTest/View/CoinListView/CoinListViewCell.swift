//
//  CoinListViewCell.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/19.
//

import UIKit

final class CoinListViewCell: UITableViewCell {
    static let identifier = #fileID

    private var isBookmarked = false

    private let bookmarkButton = UIButton()
    private let symbolLabel =  UILabel()
    private let currentPriceLabel = UILabel()
    private let changedRateLabel = UILabel()
    private let tradedPriceLabel = UILabel()

    private let containerStackView = UIStackView()
    private let firstStackView = UIStackView()
    private let secondStackView = UIStackView()

    private let star = (
        fill: UIImage(systemName: "star.fill")?.withTintColor(UIColor.themeColor, renderingMode: .alwaysOriginal),
        empty: UIImage(systemName: "star")?.withTintColor(UIColor.themeColor, renderingMode: .alwaysOriginal)
    )

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        isAccessibilityElement = true

        setUp(stackViews: containerStackView, firstStackView, secondStackView)
        setUp(labels: symbolLabel, currentPriceLabel, changedRateLabel, tradedPriceLabel)
        setUpBookmarkButton()
        setUpSubviews()
    }

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
        layoutContents()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layoutContents()
    }

    @objc private func onTap() {
        isBookmarked.toggle()

        NotificationCenter.default
            .post(name: .init(Self.identifier), object: nil, userInfo: [
                "isBookmarked": isBookmarked,
                "symbol": symbol ?? ""
            ])
    }
}

// MARK: - Facade
extension CoinListViewCell {
    var symbol: String? {
        return symbolLabel.text
    }

    func configure(with coin: HTTPCoin) {
        guard let closingPrice = coin.closePrice,
              let dailyChangedRate = coin.dailyChangedRate,
              let currentTradedPriceText = coin.currentTradedPrice,
              let currentTradedPrice = Double(currentTradedPriceText) else {
                  symbolLabel.text = "확인 중"
                  currentPriceLabel.text = "확인 중"
                  changedRateLabel.text = "확인 중"
                  return
              }

        let filteredDailyTradedPrice = Int(currentTradedPrice / 1000000.0).description + "백만"
        symbolLabel.text = coin.symbol
        currentPriceLabel.text = closingPrice
        changedRateLabel.text = dailyChangedRate
        tradedPriceLabel.text = filteredDailyTradedPrice

        if coin.isFavorite == true {
            isBookmarked = true
            bookmarkButton.setImage(star.fill, for: .normal)
        } else {
            isBookmarked = false
            bookmarkButton.setImage(star.empty, for: .normal)
        }

        accessibilityLabel = coin.symbol
        accessibilityValue = """
현재가: \(closingPrice.description),
변동률: \(dailyChangedRate.description),
거래량: \(filteredDailyTradedPrice)"
"""
    }
}

// MARK: - for layout contents
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
            label.adjustsFontForContentSizeCategory = true
            label.layer.borderColor = UIColor.lightGray.cgColor
            label.isAccessibilityElement = false
        }
    }

    func setUpBookmarkButton() {
        bookmarkButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        bookmarkButton.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }

    func setUpSubviews() {
        let stackView = UIStackView(arrangedSubviews: [bookmarkButton, symbolLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        firstStackView.addArrangedSubview(stackView)
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
