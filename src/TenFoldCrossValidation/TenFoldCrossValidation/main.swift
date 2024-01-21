//
//  main.swift
//  TenFoldCrossValidation
//

import Foundation
import CreateML


//validate(setName: "set1")
//validate(setName: "set2")
//validate(setName: "set3")


func f1Score(precision: Double, recall: Double) -> Double {
    return (2 * precision * recall) / (precision + recall)
}

print("DataSet1")
print("Angry \(f1Score(precision: 0.426898, recall: 0.35589))")
print("Disgust \(f1Score(precision: 0.206667, recall: 0.016279))")
print("Fear \(f1Score(precision: 0.375742, recall: 0.278729))")
print("Happy \(f1Score(precision: 0.68843, recall: 0.798197))")
print("Neutral \(f1Score(precision: 0.490654, recall: 0.550403))")
print("Sad \(f1Score(precision: 0.427082, recall: 0.449275))")
print("Surprise \(f1Score(precision: 0.624276, recall: 0.645426))")

// DataSet2
print("\nDataSet2")
print("Angry \(f1Score(precision: 0.460571, recall: 0.476324))")
print("Disgust \(f1Score(precision: 0.431712, recall: 0.324696))")
print("Fear \(f1Score(precision: 0.484988, recall: 0.427129))")
print("Happy \(f1Score(precision: 0.900085, recall: 0.894444))")
print("Neutral \(f1Score(precision: 0.842716, recall: 0.879883))")
print("Sad \(f1Score(precision: 0.446963, recall: 0.50356))")
print("Surprise \(f1Score(precision: 0.526047, recall: 0.563275))")

// DataSet3
print("\nDataSet3")
print("Angry \(f1Score(precision: 0.380543, recall: 0.345055))")
print("Disgust \(f1Score(precision: 0.415202, recall: 0.42069))")
print("Fear \(f1Score(precision: 0.42942, recall: 0.412022))")
print("Happy \(f1Score(precision: 0.853852, recall: 0.863441))")
print("Neutral \(f1Score(precision: 0.784348, recall: 0.840957))")
print("Sad \(f1Score(precision: 0.374389, recall: 0.37967))")
print("Surprise \(f1Score(precision: 0.409372, recall: 0.412973))")

