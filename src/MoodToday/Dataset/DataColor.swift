//
//  DataColor.swift
//  MoodToday
//

import UIKit

/// Abstraction above UIColor
enum DataColor {
    case first
    case second
    case third
    case happy
    case angry
    case sad
    case neutral
    case surprise
    case disgust
    case fear

    var color: UIColor {
        switch self {
        case .first: return UIColor(red: 56/255, green: 58/255, blue: 209/255, alpha: 1)
        case .second: return UIColor(red: 235/255, green: 113/255, blue: 52/255, alpha: 1)
        case .third: return UIColor(red: 52/255, green: 235/255, blue: 143/255, alpha: 1)
        case .happy: return UIColor(hex: "F3C33C")
        case .angry: return UIColor(hex: "DF473C")
        case .sad: return UIColor(hex: "4E6C70")
        case .neutral: return UIColor(hex: "82B4BB")
        case .surprise: return UIColor(hex: "FFED4E")
        case .disgust: return UIColor(hex: "567945")
        case .fear: return UIColor(hex: "595959")
        }
    }
}
