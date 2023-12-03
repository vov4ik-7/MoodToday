//
//  StaticDatabase.swift
//  MoodToday
//

import Foundation

class StaticDatabase {
    static var EmotionsPredictions : [EmotionPrediction] = randomEmotionsPredictions(numberOfDaysToRandom: 7)
}

class EmotionPrediction {
    var identifier: String
    var confidence: Double
    var date: Date
    
    init(identifier: String, confidence: Double, date: Date) {
        self.identifier = identifier
        self.confidence = confidence
        self.date = date
    }
}

private extension StaticDatabase {
    static func randomEmotionsPredictions(numberOfDaysToRandom: Int) -> [EmotionPrediction] {
        let identifiers = ["Happy", "Sad", "Angry", "Disgust", "Fear", "Neutral", "Surprise"]
        var emotionPredictions: [EmotionPrediction] = []
        
        let toDate = Calendar.current.date(byAdding: .day, value: -1, to: Date.now)!
        let fromDate = Calendar.current.date(byAdding: .day, value: -numberOfDaysToRandom, to: Date.now)!
        
        var day = fromDate
        while lessOrEqualDate(date1: day, date2: toDate) {
            var prediction = 1.0;
            for i in identifiers {
                let p = Double.random(in: 0.0..<prediction)
                prediction -= p
                emotionPredictions.append(EmotionPrediction(identifier: i, confidence: p, date: day))
            }
            
            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
        }
        
        return emotionPredictions
    }
    
    static func midnightDate(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let midnightDate = calendar.date(from: components)!
        return midnightDate
    }
    
    static func lessOrEqualDate(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let date1Components = calendar.dateComponents([.year, .month, .day], from: date1)
        let date2Components = calendar.dateComponents([.year, .month, .day], from: date2)
        let d1 = calendar.date(from: date1Components)!
        let d2 = calendar.date(from: date2Components)!
        let res = d1 <= d2
        
        return res
    }
}
