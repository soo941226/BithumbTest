//
//  CDChartDatum.swift
//  BithumbTest
//
//  Created by kjs on 2022/02/01.
//

import CoreData

extension CDChartDatum {
    static func retrieveWith(date: String, symbol: Symbol, chartType: ChartType) -> [CDChartDatum]? {
        let filter = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "symbol == %@", symbol),
            NSPredicate(format: "chartDate == %@", date),
            NSPredicate(format: "chartType == %@", chartType.rawValue)
        ])

        return CDManager.shared.retrieve(with: filter)
    }

    static func deleteWith(symbol: Symbol, chartType: ChartType) {
        let filter = NSCompoundPredicate(type: .and, subpredicates: [
            NSPredicate(format: "symbol == %@", symbol),
            NSPredicate(format: "chartType == %@", chartType.rawValue)
        ])

        CDManager.shared.deleteAll(model: CDChartDatum.self, filter: filter)
    }

    static func saveChartData(
        _ chartData: [ChartDatum]?,
        withDate date: String,
        symbol: Symbol,
        andChartType chartType: ChartType
    ) {
        guard let chartData = chartData else { return }

        CDManager.shared.insertModels(CDChartDatum.self, amount: chartData.count) { data in
            data.enumerated().forEach { (index, model) in
                model.setValue(date, forKey: "chartDate")
                model.setValue(symbol, forKey: "symbol")
                model.setValue(chartType.rawValue, forKey: "chartType")
                model.setValue(index, forKey: "timestamp")
                model.setValue(chartData[index].marketPrice, forKey: "marketPrice")
                model.setValue(chartData[index].closedPrice, forKey: "closedPrice")
                model.setValue(chartData[index].maxPrice, forKey: "maxPrice")
                model.setValue(chartData[index].minPrice, forKey: "minPrice")
                model.setValue(chartData[index].tradedVolume, forKey: "tradedVolume")
            }
        }
    }
}
