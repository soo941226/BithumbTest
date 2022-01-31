//
//  LinearChartView.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/30.
//

import UIKit

final class LinearChartView<Number: BinaryFloatingPoint>: UIImageView {
    private var asset: [CGFloat] = []
    private var min: Number = .zero
    private var max: Number = .zero

    private func clear() {
        asset = []
        min = .zero
        max = .zero
    }

    private func getContext() -> CGContext? {
        UIGraphicsBeginImageContext(layer.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        return context
    }

    private func drawPath(from prev: CGPoint, to next: CGPoint, with context: CGContext) {
        context.move(to: prev)
        context.addLine(to: next)
        context.strokePath()
    }

    private func setImage(with context: CGContext) {
        context.closePath()
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}

// MARK: - Facade
extension LinearChartView {
    func setUp(with asset: [Number]) {
        self.min = asset.reduce(asset[0]) { partialResult, number in
            partialResult < number ? partialResult : number
        }
        self.max = asset.reduce(asset[0]) { partialResult, number in
            partialResult > number ? partialResult : number
        }

        let distance = max - min

        self.asset = asset.map { number in
            CGFloat( (number - min) / distance )
        }
    }

    func drawChart() throws {
        defer { clear() }

        guard let context = getContext() else {
            throw ChartError.canNotCreateContext
        }

        guard asset.count >= 1 else {
            throw ChartError.dataIsNotSetUp
        }

        let xBasis = bounds.width / CGFloat(asset.count)
        let startPoint = CGPoint(x: .zero, y: bounds.height * asset[0])

        var prevPoint = startPoint

        for (order, depth) in asset.enumerated() {
            let nextPoint = CGPoint(
                x: xBasis * CGFloat(order),
                y: depth * bounds.height
            )

            if nextPoint.y < startPoint.y {
                context.setStrokeColor(UIColor.redIncreased.cgColor)
            } else {
                context.setStrokeColor(UIColor.blueDecreased.cgColor)
            }

            drawPath(from: prevPoint, to: nextPoint, with: context)

            prevPoint = nextPoint
        }
        
        setImage(with: context)
    }

    enum ChartError: Error {
        case canNotCreateContext
        case dataIsNotSetUp
    }
}
