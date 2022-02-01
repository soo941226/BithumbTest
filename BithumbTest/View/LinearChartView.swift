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

    private func isExist(
        _ point: CGPoint,
        between prevPoint: CGPoint,
        and nextPoint: CGPoint
    ) -> CGPoint? {
        let prevY = prevPoint.y < nextPoint.y ? prevPoint.y : nextPoint.y
        let nextY = prevPoint.y > nextPoint.y ? prevPoint.y : nextPoint.y

        if prevY...nextY ~= point.y {
            let slope = (nextPoint.y - prevPoint.y) / (nextPoint.x - prevPoint.x)
            let intercept = prevPoint.y - (slope * prevPoint.x)
            return CGPoint(x: (point.y - intercept) / slope, y: point.y)
        } else {
            return nil
        }
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

        if asset[0] <= asset[1] {
            context.setStrokeColor(UIColor.redIncreased.cgColor)
        } else {
            context.setStrokeColor(UIColor.blueDecreased.cgColor)
        }

        var prevPoint = startPoint

        for (order, depth) in asset.enumerated() {
            let nextPoint = CGPoint(
                x: xBasis * CGFloat(order),
                y: depth * bounds.height
            )

            if let point = isExist(startPoint, between: prevPoint, and: nextPoint) {
                drawPath(from: prevPoint, to: point, with: context)

                if prevPoint.y < nextPoint.y {
                    context.setStrokeColor(UIColor.blueDecreased.cgColor)
                } else {
                    context.setStrokeColor(UIColor.redIncreased.cgColor)
                }

                drawPath(from: point, to: nextPoint, with: context)
            } else {
                drawPath(from: prevPoint, to: nextPoint, with: context)
            }

            prevPoint = nextPoint
        }
        
        setImage(with: context)
    }

    enum ChartError: Error {
        case canNotCreateContext
        case dataIsNotSetUp
    }
}
