//
//  ViewControllerStatistics.swift
//  MoodToday
//

import UIKit
import Charts

/// Constants
private enum Constants {
    static var horizontalInset: CGFloat { 24 }
    static var chartHeight: CGFloat { 300 }
}

class ViewControllerStatistics: UIViewController {
    
    @IBOutlet weak var chart1Container: UIView!
    @IBOutlet weak var chart1: ChartView!
    
    @IBOutlet weak var chart2Container: UIView!
    @IBOutlet weak var chart2: ChartView!
    
    @IBOutlet weak var chart3Container: UIView!
    @IBOutlet weak var chart3: ChartView!
    
    @IBOutlet weak var angryChartContainer: UIView!
    @IBOutlet weak var angryChart: ChartView!
    
    @IBOutlet weak var disgustChartContainer: UIView!
    @IBOutlet weak var disgustChart: ChartView!
    
    @IBOutlet weak var fearChartContainer: UIView!
    @IBOutlet weak var fearChart: ChartView!
    
    @IBOutlet weak var neutralChartContainer: UIView!
    @IBOutlet weak var neutralChart: ChartView!
    
    @IBOutlet weak var surpriseChartContainer: UIView!
    @IBOutlet weak var surpriseChart: ChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        customizeAllEmotionsChart()
        customizeHappyChart()
        customizeSadChart()
        customizeAngryChart()
        customizeDisgustChart()
        customizeFearChart()
        customizeNeutralChart()
        customizeSurpriseChart()
    }
    
    func customizeSurpriseChart() {
        surpriseChartContainer.layer.cornerRadius = 20
        surpriseChart.backgroundColor = .clear
        
        let chartDataSetSurprise = ChartDataSetVM(
            colorAsset: .surprise,
            chartDataEntries: makeChartDataset(identifier: "Surprise")
        )

        let chartVM = ChartViewModel(
            chartDataSetVMs: [
                chartDataSetSurprise,
            ],
            legendEntries: []
        )
        
        surpriseChart.viewModel = chartVM
    }
    
    func customizeNeutralChart() {
        neutralChartContainer.layer.cornerRadius = 20
        neutralChart.backgroundColor = .clear
        
        let chartDataSetNeutral = ChartDataSetVM(
            colorAsset: .neutral,
            chartDataEntries: makeChartDataset(identifier: "Neutral")
        )

        let chartVM = ChartViewModel(
            chartDataSetVMs: [
                chartDataSetNeutral,
            ],
            legendEntries: []
        )
        
        neutralChart.viewModel = chartVM
    }
    
    func customizeFearChart() {
        fearChartContainer.layer.cornerRadius = 20
        fearChart.backgroundColor = .clear
        
        let chartDataSetFear = ChartDataSetVM(
            colorAsset: .fear,
            chartDataEntries: makeChartDataset(identifier: "Fear")
        )

        let chartVM = ChartViewModel(
            chartDataSetVMs: [
                chartDataSetFear,
            ],
            legendEntries: []
        )
        
        fearChart.viewModel = chartVM
    }
    
    func customizeDisgustChart() {
        disgustChartContainer.layer.cornerRadius = 20
        disgustChart.backgroundColor = .clear
        
        let chartDataSetDisgust = ChartDataSetVM(
            colorAsset: .disgust,
            chartDataEntries: makeChartDataset(identifier: "Disgust")
        )

        let chartVM = ChartViewModel(
            chartDataSetVMs: [
                chartDataSetDisgust,
            ],
            legendEntries: []
        )
        
        disgustChart.viewModel = chartVM
    }
    
    func customizeAngryChart() {
        angryChartContainer.layer.cornerRadius = 20
        angryChart.backgroundColor = .clear
        
        let chartDataSetAngry = ChartDataSetVM(
            colorAsset: .angry,
            chartDataEntries: makeChartDataset(identifier: "Angry")
        )

        let chartVM = ChartViewModel(
            chartDataSetVMs: [
                chartDataSetAngry,
            ],
            legendEntries: []
        )
        
        angryChart.viewModel = chartVM
    }
    
    func customizeSadChart() {
        chart3Container.layer.cornerRadius = 20
        chart3.backgroundColor = .clear
        
        let chartDataSetSad = ChartDataSetVM(
            colorAsset: .sad,
            chartDataEntries: makeChartDataset(identifier: "Sad")
        )

        let chartVM = ChartViewModel(
            chartDataSetVMs: [
                chartDataSetSad,
            ],
            legendEntries: []
        )
        
        chart3.viewModel = chartVM
    }
    
    func customizeHappyChart() {
        chart2Container.layer.cornerRadius = 20
        chart2.backgroundColor = .clear
        
        /*chart2.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            $0.height.equalTo(Constants.chartHeight)
        }*/

        let chartDataSetHappy = ChartDataSetVM(
            colorAsset: .happy,
            chartDataEntries: makeChartDataset(identifier: "Happy")
        )
        // uncomment below to try multiple charts in one area
        /*let chartDataSetTwo = ChartDataSetVM(
            colorAsset: .sad,
            chartDataEntries: makeChartDataset(identifier: "Sad")
        )*/
        let chartVM = ChartViewModel(
            chartDataSetVMs: [
                chartDataSetHappy,
                // uncomment below to try multiple charts in one area
                //chartDataSetTwo,
            ],
            legendEntries: []
        )
        
        chart2.viewModel = chartVM
    }
    
    func customizeAllEmotionsChart() {
        chart1Container.layer.cornerRadius = 20
        //chart1Container.backgroundColor = .yellow
        chart1.backgroundColor = .clear
        
        let happy = LegendEntry(label: "Радість")
        happy.form = .circle
        happy.formColor = DataColor.happy.color
        
        let sad = LegendEntry(label: "Сум")
        sad.form = .circle
        sad.formColor = DataColor.sad.color
        
        let angry = LegendEntry(label: "Злість")
        angry.form = .circle
        angry.formColor = DataColor.angry.color
        
        let disgust = LegendEntry(label: "Огида")
        disgust.form = .circle
        disgust.formColor = DataColor.disgust.color
        
        let fear = LegendEntry(label: "Страх")
        fear.form = .circle
        fear.formColor = DataColor.fear.color
        
        let neutral = LegendEntry(label: "Нейтральний стан")
        neutral.form = .circle
        neutral.formColor = DataColor.neutral.color
        
        let surprise = LegendEntry(label: "Здивованість")
        surprise.form = .circle
        surprise.formColor = DataColor.surprise.color
        
        var legendEntries = [happy, sad, angry, disgust, fear, neutral, surprise]
        
        let chartDataSetHappy = ChartDataSetVM(
            colorAsset: .happy,
            chartDataEntries: makeChartDataset(identifier: "Happy")
        )
        
        let chartDataSetSad = ChartDataSetVM(
            colorAsset: .sad,
            chartDataEntries: makeChartDataset(identifier: "Sad")
        )
        
        let chartDataSetAngry = ChartDataSetVM(
            colorAsset: .angry,
            chartDataEntries: makeChartDataset(identifier: "Angry")
        )
        
        let chartDataSetDisgust = ChartDataSetVM(
            colorAsset: .disgust,
            chartDataEntries: makeChartDataset(identifier: "Disgust")
        )
        
        let chartDataSetFear = ChartDataSetVM(
            colorAsset: .fear,
            chartDataEntries: makeChartDataset(identifier: "Fear")
        )
        
        let chartDataSetNeutral = ChartDataSetVM(
            colorAsset: .neutral,
            chartDataEntries: makeChartDataset(identifier: "Neutral")
        )
        
        let chartDataSetSurprise = ChartDataSetVM(
            colorAsset: .surprise,
            chartDataEntries: makeChartDataset(identifier: "Surprise")
        )
        
        let chartVM = ChartViewModel(
            chartDataSetVMs: [
                chartDataSetHappy,
                chartDataSetSad,
                chartDataSetAngry,
                chartDataSetDisgust,
                chartDataSetFear,
                chartDataSetNeutral,
                chartDataSetSurprise
            ],
            legendEntries: legendEntries
        )
        
        chart1.viewModel = chartVM
        
        /*chart1Container.layer.cornerRadius = 20
        
        let textColor = UIColor(hex:"595959", alpha: 1.0)
        
        let lineChartEntries = [
                ChartDataEntry(x: 1, y: 2),
                ChartDataEntry(x: 2, y: 4),
                ChartDataEntry(x: 3, y: 3),
        ]
        let dataSet = LineChartDataSet(entries: lineChartEntries)
        let data = LineChartData(dataSet: dataSet)
        chart1.data = data
        chart1.backgroundColor = .clear
        chart1.legend.textColor = textColor
        chart1.leftAxis.labelTextColor = textColor
        chart1.rightAxis.labelTextColor = textColor
        chart1.xAxis.labelTextColor = textColor
        chart1.lineData?.setValueTextColor(textColor)
        
        // disable grid
        chart1.xAxis.drawGridLinesEnabled = false
        chart1.leftAxis.drawGridLinesEnabled = false
        chart1.rightAxis.drawGridLinesEnabled = false
        chart1.drawGridBackgroundEnabled = false
        // disable axis annotations
        chart1.xAxis.drawLabelsEnabled = false
        chart1.leftAxis.drawLabelsEnabled = false
        chart1.rightAxis.drawLabelsEnabled = false
        // disable legend
        chart1.legend.enabled = false
        // disable zoom
        chart1.pinchZoomEnabled = false
        chart1.doubleTapToZoomEnabled = false
        // remove artifacts around chart area
        chart1.xAxis.enabled = false
        chart1.leftAxis.enabled = false
        chart1.rightAxis.enabled = false
        chart1.drawBordersEnabled = false
        chart1.minOffset = 0
        // setting up delegate needed for touches handling
        chart1.delegate = chart1 as? any ChartViewDelegate*/
    }
    
    ///  Random dataset
    func makeChartDataset(identifier: String) -> [ChartDataEntry] {
        /*var numbers = [Double]()
        for number in 1...10 {
            numbers.append(Double(number) + Double(number) / 100)
        }*/
        
        let emotionsPredictions  = StaticDatabase.EmotionsPredictions.filter { p in (p.identifier) == identifier }
        
        let calendar = Calendar.current
        
        let fromDate = emotionsPredictions.max(by: { $0.date.compare($1.date) == .orderedDescending })!.date
        let toDate = emotionsPredictions.min(by: { $0.date.compare($1.date) == .orderedDescending })!.date

        var entries = [ChartDataEntry]()
        
        var day = fromDate
        var counter = 1
        while day <= toDate {
            let currentDatePredictions = emotionsPredictions.filter { p in
                let currentDateComponents = calendar.dateComponents([.year, .month, .day], from: day)
                let predictionDateComponents = calendar.dateComponents([.year, .month, .day], from: p.date)
                return currentDateComponents == predictionDateComponents
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            if currentDatePredictions.isEmpty {
                let entry = ChartDataEntry(
                    x: Double(counter),
                    y: 0,
                    data: "\(dateFormatter.string(from: day))")
                entries.append(entry)
            } else {
                let sum = currentDatePredictions.reduce(0.0, { $0 + $1.confidence })
                let value = sum / Double(currentDatePredictions.count)
                let entry = ChartDataEntry(
                    x: Double(counter),
                    y: value,//((value * 100) * 100).rounded() / 100,
                    data: "\(dateFormatter.string(from: day))")
                entries.append(entry)
            }
            
            counter += 1
            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
        }

        /*for position in 1...20 {
            if let randomValue = numbers.randomElement() {
                let entry = ChartDataEntry(
                    x: Double(position),
                    y: randomValue,
                    data: "\(position) Jan 2022")
                entries.append(entry)
            }
        }*/

        return entries
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

