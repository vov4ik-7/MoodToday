//
//  ChartViewModel.swift
//  MoodToday
//

import Foundation
import Charts

/// View model protocol
protocol ChartViewModelProtocol {
    var chartDataSetVMs: [ChartDataSetVM] { get set }
    var legendEntries: [LegendEntry] { get set }
}

/// View model
final class ChartViewModel: ChartViewModelProtocol {
    public var chartDataSetVMs: [ChartDataSetVM]
    public var legendEntries: [LegendEntry]

    init(chartDataSetVMs: [ChartDataSetVM], legendEntries: [LegendEntry]) {
        self.chartDataSetVMs = chartDataSetVMs
        self.legendEntries = legendEntries
    }
}
