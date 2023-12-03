//
//  ImageResultViewController.swift
//  MoodToday
//

import UIKit
import Charts
import Vision
import VideoToolbox

class ImageResultViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    var image: UIImage!
    
    @IBOutlet weak var noFaceFoundLabel: UILabel!
    private let model = try! VNCoreMLModel(for: CNNEmotions().model)
    //private let emotionClassifier = try! VNCoreMLModel(for: EmotionClassifier5gb25iter().model)
    //private let model = try! VNCoreMLModel(for: ec_5_25_uei_v1().model)
    
    private let emotionsTranslate = [
        "Happy": "Радість",
        "Sad": "Сум",
        "Angry": "Злість",
        "Disgust": "Огида",
        "Fear": "Страх",
        "Neutral": "Нейтральний стан",
        "Surprise": "Здивованість"
    ]
    
    private let emotionsColors = [
        "Happy": DataColor.happy.color,
        "Sad": DataColor.sad.color,
        "Angry": DataColor.angry.color,
        "Disgust": DataColor.disgust.color,
        "Fear": DataColor.fear.color,
        "Neutral": DataColor.neutral.color,
        "Surprise": DataColor.surprise.color
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageToDetectFace = UIImage(pixelBuffer: buffer(from: image)!)
        let face = detectFaceAndCrop(image: imageToDetectFace!)
        if face == nil {
            noFaceFoundLabel.isHidden = false
            return
        }
        
        noFaceFoundLabel.isHidden = true
        UIImageWriteToSavedPhotosAlbum(face!, nil, nil, nil);
        let cvPixelBuffer = buffer(from: face!)

        // Do any additional setup after loading the view.
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = (request.results as? [VNClassificationObservation]) else { return }
            
            let emotionPredictions = result.map { r in EmotionPrediction(identifier: r.identifier, confidence: Double(r.confidence), date: Date.now) }
            
            StaticDatabase.EmotionsPredictions.append(contentsOf: emotionPredictions)
            
            let acceptableResults = emotionPredictions.filter { r in (r.confidence * 100) > 1 }
            let emotions = acceptableResults.map{ r in r.identifier }
            let confidences = acceptableResults.map{ r in r.confidence * 100 }
            
            self.customizeChart(dataPoints: emotions, values: confidences)
            
            //DispatchQueue.main.async {
                //let conf = firstResult.confidence
            //}
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: cvPixelBuffer!, orientation: .up, options: [:]).perform([request])
        
        
        //let players = ["Радість", "Подив", "Нейтральний", "Сум", "Злість" ]
        //let goals = [10, 4, 49, 12, 25]
        //customizeChart(dataPoints: players, values: goals.map{ Double($0) })
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      
        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let emotion = emotionsTranslate[dataPoints[i]]
            let dataEntry = PieChartDataEntry(value: values[i], label: emotion, data: emotion as AnyObject)
            dataEntries.append(dataEntry)
        }

        // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = colorsOfCharts(dataPoints: dataPoints)
        

        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .percent
        format.maximumFractionDigits = 1
        format.multiplier = 1
        format.percentSymbol = " %"
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
      
        // 4. Assign it to the chart's data
        pieChartView.data = pieChartData
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.legend.enabled = true
        pieChartView.legend.orientation = .horizontal
        pieChartView.legend.horizontalAlignment = .center
        //pieChartView.legend.font = UIFont.systemFont(ofSize: 14.0)
        //pieChartView.legend.textColor = .black
        pieChartView.legend.font = UIFont(name: "Montserrat", size: 14)!
        pieChartView.legend.textColor = UIColor(hex: "595959")
        pieChartView.legend.form = .circle
        
        //pieChartView.highlightValues(nil)
        pieChartView.notifyDataSetChanged()
        
        //pieChartView.legend.horizontalAlignment = .right
        //pieChartView.legend.verticalAlignment = .center
        //pieChartView.entryLabelFont = UIFont.systemFont(ofSize: 18.0)
        
    }
    
    private func colorsOfCharts(dataPoints: [String]) -> [UIColor] {
        var colors: [UIColor] = []
        /*for _ in 0..<numbersOfColor {
        let red = Double(arc4random_uniform(256))
        let green = Double(arc4random_uniform(256))
        let blue = Double(arc4random_uniform(256))
        let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
        colors.append(color)
        }*/
        
        for emotionIdentifier in dataPoints {
            colors.append(emotionsColors[emotionIdentifier]!)
        }
        
        /*let color1 = UIColor(red: 243/255.0, green: 195/255.0, blue: 60/255.0, alpha: 1.0)
        let color2 = UIColor(red: CGFloat(86/255.0), green: CGFloat(121/255.0), blue: CGFloat(69/255.0), alpha: 1.0)
        let color3 = UIColor(red: CGFloat(130/255.0), green: CGFloat(180/255.0), blue: CGFloat(187/255.0), alpha: 1.0)
        let color4 = UIColor(red: CGFloat(37/255.0), green: CGFloat(94/255.0), blue: CGFloat(121/255.0), alpha: 1.0)
        let color5 = UIColor(red: CGFloat(223/255.0), green: CGFloat(71/255.0), blue: CGFloat(60/255.0), alpha: 1.0)
        
        colors.append(color1)
        colors.append(color2)
        colors.append(color3)
        colors.append(color4)
        colors.append(color5)*/
        
      return colors
    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: image.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
      image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
    }
    
    func detectFaceAndCrop(image: UIImage) -> UIImage? {
        var result: UIImage? = nil
        
        guard let ciImage = CIImage(image: image) else { return nil }

        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, error) in
            if let error = error {
                print("Error detecting face: \(error.localizedDescription)")
                return
            }

            guard let results = request.results as? [VNFaceObservation], let firstResult = results.first else {
                print("No face detected")
                return
            }

            let faceBoundingBox = firstResult.boundingBox
            result = self.cropFace(image: image, boundingBox: faceBoundingBox)
        }

        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([detectFaceRequest])
            return result
        } catch {
            print("Error performing face detection: \(error.localizedDescription)")
            return nil
        }
    }

        func cropFace(image: UIImage, boundingBox: CGRect) -> UIImage? {
            let rect=boundingBox
            let x1=rect.origin.x*image.size.width
            let w1=rect.width*image.size.width
            let h1=rect.height*image.size.height
            let y1=image.size.height*(1-rect.origin.y)-h1
            let conv_rect=CGRect(x: x1, y: y1, width: w1, height: h1)
            
            //let res = VNImageRectForNormalizedRect(boundingBox, Int(image.size.width), Int(image.size.height))

            if let cgImage = image.cgImage?.cropping(to: conv_rect) {
                let croppedImage = UIImage(cgImage: cgImage)
                
                return croppedImage
            }
            
            return nil
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

        guard let cgImage = cgImage else {
            return nil
        }

        self.init(cgImage: cgImage)
    }
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
        }
    }
}

