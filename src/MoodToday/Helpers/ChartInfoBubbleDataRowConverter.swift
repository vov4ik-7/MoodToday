//
//  ChartInfoBubbleDataRowConverter.swift
//  MoodToday
//

import Foundation

/// Constants
private enum Constants {
    static var currencySymbol: String { " $" }
    static var percentageSymbol: String { " %" }
}

/// Converts original dataset to info bubble representation
struct ChartInfoBubbleDataRowConverter {
    func convert(dataSetVMs: [ChartDataSetVM], position: Int) -> [ChartInfoBubbleDataRowViewModel] {
        return dataSetVMs.map {
            let color = $0.colorAsset
            guard position <= $0.chartDataEntries.count else { return .init(colorAsset: color, value: "") }
            let dataEntry = $0.chartDataEntries[position - 1].y
            let dataEntryFormatted = ((dataEntry * 100) * 100).rounded() / 100
            let formattedValue = String(dataEntryFormatted) + Constants.percentageSymbol
            return ChartInfoBubbleDataRowViewModel(colorAsset: color, value: formattedValue)
        }
    }
}
