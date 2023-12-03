//
//  ChartInfoBubbleDataRowViewModel.swift
//  MoodToday
//

import Foundation

/// Data row VM protocol
protocol ChartInfoBubbleDataRowViewModelProtocol {
    var colorAsset: DataColor { get set }
    var value: String { get set }
}

/// Data row VM
final class ChartInfoBubbleDataRowViewModel: ChartInfoBubbleDataRowViewModelProtocol {
    var colorAsset: DataColor
    var value: String

    init(
        colorAsset: DataColor,
        value: String
    ) {
        self.colorAsset = colorAsset
        self.value = value
    }
}
