//
//  LinearChartView.swift
//  BithumbTest
//
//  Created by kjs on 2022/01/30.
//

import UIKit

final class LinearChartView<Data: BinaryFloatingPoint>: UIImageView {
    private var asset: [CGFloat] = []
    private var min: Data = 0
    private var max: Data = 0

    func setUpWith(_ asset: [Data]) {
        self.min = asset.reduce(asset[0]) { partialResult, data in
            partialResult < data ? partialResult : data
        }
        self.max = asset.reduce(asset[0]) { partialResult, data in
            partialResult > data ? partialResult : data
        }

        let distance = max - min
        self.asset = asset.map { data in
            CGFloat( (data - min ) / distance )
        }

        self.asset.shuffle()
    }

    func redraw() throws {
        UIGraphicsBeginImageContext(layer.bounds.size)

        guard let context = UIGraphicsGetCurrentContext() else {
            throw ChartError.canNotCreateContext
        }

        guard asset.count >= 1 else {
            throw ChartError.dataIsNotSetUp
        }

        let startPoint = CGPoint(x: .zero, y: bounds.height * asset[0])
        var prevPoint = CGPoint(x: .zero, y: bounds.height * asset[0])

        context.beginPath()
        for (index, basicY) in asset.enumerated() {
            let nextPoint = CGPoint(
                x: bounds.width / CGFloat(asset.count) * CGFloat(index),
                y: basicY * bounds.height
            )

            if nextPoint.y > startPoint.y {
                context.setStrokeColor(UIColor.blue.cgColor)
            } else {
                context.setStrokeColor(UIColor.red.cgColor)
            }

            context.move(to: prevPoint)
            context.addLine(to: nextPoint)
            context.strokePath()

            prevPoint = nextPoint
        }
        context.closePath()
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    enum ChartError: Error {
        case canNotCreateContext
        case dataIsNotSetUp
    }
}
