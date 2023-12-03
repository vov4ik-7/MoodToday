//
//  ChartView.swift
//  MoodToday
//

import UIKit
import SnapKit
import Charts

/// Constants
private enum Constants {
    static var chartBottomInset: CGFloat { 40 }
    static var infoBubbleMargin: CGFloat { 12 }
}

/// Chart view
final class ChartView: UIView {
    private let chart = LineChartView()
    private let circleMarker = CircleMarker()
    private let infoBubble = ChartInfoBubbleView()

    var viewModel: ChartViewModelProtocol? {
        didSet {
            updateChartDatasets()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - ChartViewDelegate
extension ChartView: ChartViewDelegate {
    func chartValueSelected(
        _ chartView: ChartViewBase,
        entry: ChartDataEntry,
        highlight: Highlight
    ) {
        guard let viewModel = viewModel else { return }
        // Place info bubble in correct location
        let infoBubbleVmFactory = ChartInfoBubbleVmFactory(
            entry: entry,
            chartDatasetVMs: viewModel.chartDataSetVMs
        )
        infoBubble.viewModel = infoBubbleVmFactory.makeInfoBubbleVM()

        let markerPosition = CGPoint(x: highlight.xPx, y: highlight.yPx)
        let offsetProvider = InfoBubbleOffsetProvider()
        let fittingOffset = offsetProvider.getFittingOffset(
            forChild: infoBubble,
            inParent: chartView,
            withMarker: markerPosition,
            margin: Constants.infoBubbleMargin
        )

        infoBubble.snp.updateConstraints {
            $0.centerX.equalToSuperview().offset(fittingOffset.x)
            $0.centerY.equalToSuperview().offset(fittingOffset.y)
        }

        infoBubble.isHidden = false
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        infoBubble.isHidden = true
    }
}

// MARK: - Private methods
private extension ChartView {
    func commonInit() {
        setupChartView()
        setupInfoBubble()
    }

    func setupChartView() {
        addSubview(chart)
        chart.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(Constants.chartBottomInset).priority(.medium)
        }
        chart.isUserInteractionEnabled = true

        // disable coordinate grid
        chart.xAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.drawGridBackgroundEnabled = false
        // disable labels
        chart.xAxis.drawLabelsEnabled = false
        chart.leftAxis.drawLabelsEnabled = true
        let valueFormatter = NumberFormatter()
        valueFormatter.numberStyle = .percent
        chart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: valueFormatter)
        chart.rightAxis.drawLabelsEnabled = false
        // disable legend
        chart.legend.enabled = false
        // disable zoom
        chart.pinchZoomEnabled = false
        chart.doubleTapToZoomEnabled = false
        // remove artifacts around chart area
        chart.xAxis.enabled = false
        chart.leftAxis.enabled = true
        chart.leftAxis.labelTextColor = UIColor(hex: "595959")
        chart.leftAxis.labelFont = UIFont(name: "Montserrat", size: 9)!
        chart.rightAxis.enabled = false
        chart.drawBordersEnabled = false
        chart.minOffset = 0
        // delegate for touch handling
        chart.delegate = self
        
        // markers
        chart.drawMarkers = true
        circleMarker.chartView = chart
        chart.marker = circleMarker
    }

    func setupInfoBubble() {
        chart.addSubview(infoBubble)
        infoBubble.isHidden = true
        infoBubble.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func updateChartDatasets() {
        guard let viewModel = viewModel else { return }
        let dataSetFactory = ChartDatasetFactory()
        let datasets = viewModel.chartDataSetVMs.map {
            dataSetFactory.makeChartDataset(
                colorAsset: $0.colorAsset,
                entries: $0.chartDataEntries
            )
        }
        
        chart.legend.enabled = !viewModel.legendEntries.isEmpty
        if !viewModel.legendEntries.isEmpty {
            chart.legend.setCustom(entries: viewModel.legendEntries)
            chart.legend.orientation = .horizontal
            chart.legend.horizontalAlignment = .center
            //let a = UIFont.familyNames.sorted()
            chart.legend.font = UIFont(name: "Montserrat", size: 10)!//UIFont.systemFont(ofSize: 14.0)
            chart.legend.textColor = UIColor(hex: "595959")
        }
        
        let chartData = LineChartData(dataSets: datasets)
        chart.data = chartData
        
        //let a = chart.frame
        //chart.frame = CGRect(x: 0, y:0, width: 328, height: 300)
    }
}
