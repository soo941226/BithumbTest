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
        stackView.distribution = . fillEqually
        stackView.spacing = .zero
        stackView.alignment = .center
        return stackView
    }()
    private let arrows = (up: UIImageView(), down: UIImageView())
    private let images = (
        highlightUp : UIImage(systemName: "arrowtriangle.up.fill")?
            .withTintColor(.bithumbMainColor, renderingMode: .alwaysOriginal),
        defaultUp : UIImage(systemName: "arrowtriangle.up.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal),
        highlightDown : UIImage(systemName: "arrowtriangle.down.fill")?
            .withTintColor(.bithumbMainColor, renderingMode: .alwaysOriginal),
        defaultDown : UIImage(systemName: "arrowtriangle.down.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    )
    private var storedState = State.none

    required init?(coder: NSCoder) {
        fatalError("Do not use init(coder:), This project avoid Interface builder")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpSubviews()
    }

    enum State: Int {
        case none
        case up
        case down

        mutating func next() {
            let rawValue = self.rawValue + 1
            guard let next = State(rawValue: rawValue) else {
                self = .none
                return
            }

            self = next
        }
    }
}

// MARK: - outer interface
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

    var currentState: State {
        get { storedState }
        set {
            storedState = newValue
            setColor(with: newValue)
        }
    }
}

// MARK: - layout contents
private extension CoinListViewSortButton {
    func setUpSubviews() {
        setColor(with: .none)
        imageContainer.addArrangedSubview(arrows.up)
        imageContainer.addArrangedSubview(arrows.down)

        let stackView = UIStackView(arrangedSubviews: [label, imageContainer])

        stackView.distribution = .fill
        stackView.spacing = .zero
        stackView.axis = .horizontal
        stackView.alignment = .center

        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - managing status
private extension CoinListViewSortButton {
    func setColor(with state: State) {
        switch state {
        case .none:
            arrows.up.image = images.defaultUp
            arrows.down.image = images.defaultDown
        case .up:
            arrows.up.image = images.highlightUp
            arrows.down.image = images.defaultDown
        case .down:
            arrows.up.image = images.defaultUp
            arrows.down.image = images.highlightDown
        }
    }
}
