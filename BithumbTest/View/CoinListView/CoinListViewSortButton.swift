//
//  CoinListViewSortButton.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/20.
//

import UIKit

final class CoinListViewSortButton: UIView {
    private let label = UILabel()
    private let imageContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = .zero
        stackView.alignment = .center
        return stackView
    }()
    private let arrows = (up: UIImageView(), down: UIImageView())
    private let images = (
        highlightUp : UIImage(systemName: "arrowtriangle.up.fill")?
            .withTintColor(.themeColor, renderingMode: .alwaysOriginal),
        defaultUp : UIImage(systemName: "arrowtriangle.up.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal),
        highlightDown : UIImage(systemName: "arrowtriangle.down.fill")?
            .withTintColor(.themeColor, renderingMode: .alwaysOriginal),
        defaultDown : UIImage(systemName: "arrowtriangle.down.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    )
    private var storedState = SortDirection.none
    private var actions = [() -> Void]()

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setColor(with: .none)
        setUpArrowIcons()
        setUpSubviews()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(excute))
        addGestureRecognizer(tapRecognizer)
    }
}

// MARK: - Facade
extension CoinListViewSortButton {
    var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }

    var textColor: UIColor {
        get { label.textColor }
        set { label.textColor = newValue }
    }
    
    var textAlignment: NSTextAlignment {
        get { label.textAlignment }
        set { label.textAlignment = newValue }
    }

    var adjustsFontSizeToFitWidth: Bool {
        get { label.adjustsFontSizeToFitWidth }
        set { label.adjustsFontSizeToFitWidth = newValue }
    }

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var currentState: SortDirection {
        get { storedState }
        set {
            storedState = newValue
            setColor(with: newValue)
        }
    }

    func setUp(tapAction: @escaping () -> Void) {
        actions.append(tapAction)
    }

    @objc private func excute() {
        actions.forEach({ clsoure in
            clsoure()
        })
    }
}

// MARK: - layout contents
private extension CoinListViewSortButton {
    func setUpArrowIcons() {
        imageContainer.addArrangedSubview(arrows.up)
        imageContainer.addArrangedSubview(arrows.down)

        arrows.up.translatesAutoresizingMaskIntoConstraints = false
        arrows.down.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrows.up.widthAnchor.constraint(
                lessThanOrEqualToConstant: Width.iconMaximumWidth
            ),
            arrows.up.heightAnchor.constraint(
                lessThanOrEqualToConstant: Height.iconMaximumHeight
            ),
            arrows.down.widthAnchor.constraint(
                lessThanOrEqualToConstant: Width.iconMaximumWidth
            ),
            arrows.down.heightAnchor.constraint(
                lessThanOrEqualToConstant: Height.iconMaximumHeight
            )
        ])
    }

    func setUpSubviews() {
        let stackView = UIStackView(arrangedSubviews: [label, imageContainer])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering

        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Spacing.basicHorizontalInset
            ),
            stackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Spacing.basicHorizontalInset
            )
        ])
    }
}

// MARK: - managing status
private extension CoinListViewSortButton {
    func setColor(with state: SortDirection) {
        switch state {
        case .none:
            arrows.up.image = images.defaultUp
            arrows.down.image = images.defaultDown
        case .ascending:
            arrows.up.image = images.highlightUp
            arrows.down.image = images.defaultDown
        case .descending:
            arrows.up.image = images.defaultUp
            arrows.down.image = images.highlightDown
        }
    }
}
