//
//  CrossValidation.swift
//  TenFoldCrossValidation
//

import Foundation
import CreateML

let dataDir = "/Users/user/Desktop/data"
let fileManager = FileManager.default
let emotions = ["Angry", "Disgust", "Fear", "Happy", "Neutral", "Sad", "Surprise"]

func getResultsFilePath(setName: String) -> String {
    return "\(dataDir)/results-\(setName).txt"
}

func getProcessingDir(setName: String, type: String) -> String {
    return URL(filePath: dataDir).appendingPathComponent("processing").appendingPathComponent(setName).appendingPathComponent(type).path()
}

func getProcessingDir(setName: String, type: String, emotion: String) -> String {
    return URL(filePath: dataDir).appendingPathComponent("processing").appendingPathComponent(setName).appendingPathComponent(type).appendingPathComponent(emotion).path()
}

func getDataDir(setName: String, emotion: String) -> String {
    return URL(filePath: dataDir).appendingPathComponent(setName).appendingPathComponent(emotion).path()
}

func getCleanDirectory(path: String) {
    if fileManager.fileExists(atPath: path) {
        try? fileManager.removeItem(atPath: path)
    }
    
    try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
}

func copyFiles(from: String, to: String, contents: [String]) {
    for file in contents {
        let sourcePath = (from as NSString).appendingPathComponent(file)
        let destinationPath = (to as NSString).appendingPathComponent(file)
        
        try! fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
    }
}

func appendLineToFile(line: String, filePath: String) {
    // Відкриття файлу
    print(line)
    if let fileHandle = FileHandle(forWritingAtPath: filePath) {
        defer {
            fileHandle.closeFile()
        }

        // Перенесення вказівника в кінець файлу
        fileHandle.seekToEndOfFile()

        // Запис даних у файл
        if let data = line.data(using: .utf8) {
            fileHandle.write(data)
            fileHandle.write(Data("\n".utf8))
        }
    } else {
        print("Error opening the file for appending.")
    }
}

func getCurrentDate() -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let formattedDate = dateFormatter.string(from: currentDate)
    
    return formattedDate
}

func validate(setName: String, k: Int = 10) {
    let resultsFile = getResultsFilePath(setName: setName)
    let now = getCurrentDate()
    appendLineToFile(line: "\n-----------------\nRunning app at \(now), Set: \(setName)", filePath: resultsFile)
    
    let processingTrainDir = getProcessingDir(setName: setName, type: "train")
    let processingTestDir = getProcessingDir(setName: setName, type: "test")
    
    // k-кратна перехресна перевірка (де k = 10)
    for i in 0..<k {
        // Проходження по всіх класах емоцій
        for emotion in emotions {
            let emotionDir = getDataDir(setName: setName, emotion: emotion)
            var contents = try! fileManager.contentsOfDirectory(atPath: emotionDir)
            
            let processingTrainEmotionDir = getProcessingDir(setName: setName, type: "train", emotion: emotion)
            let processingTestEmotionDir = getProcessingDir(setName: setName, type: "test", emotion: emotion)
            getCleanDirectory(path: processingTrainEmotionDir)
            getCleanDirectory(path: processingTestEmotionDir)
            
            // Розбиття кожного класу на тренувальну і тестувальну вибірки
            let contentSize = contents.count
            let partSize = contentSize / k
            let startIndex = i * partSize
            let endIndex = (i + 1) * partSize
            
            let testPart = Array(contents[startIndex..<min(endIndex, contentSize)])
            contents.removeSubrange(startIndex..<min(endIndex, contentSize))
            
            copyFiles(from: emotionDir, to: processingTestEmotionDir, contents: testPart)
            copyFiles(from: emotionDir, to: processingTrainEmotionDir, contents: contents)
        }
        
        let parameters = MLImageClassifier.ModelParameters(
            featureExtractor: .scenePrint(revision: 2),
            validationData: nil,
            maxIterations: 500,
            augmentationOptions: []
        )

        let trainDirectory = URL(filePath: processingTrainDir)
        let testDirectory = URL(filePath: processingTestDir)

        // Тренування моделі
        let model = try! MLImageClassifier(trainingData: .labeledDirectories(at: trainDirectory), parameters: parameters)
        
        // Оцінка моделі
        let evaluation = model.evaluation(on: .labeledDirectories(at: testDirectory))
        let accuracy = 1 - evaluation.classificationError
        
        appendLineToFile(line: "\nSet: \(setName), Iteration: \(i + 1)", filePath: resultsFile)
        appendLineToFile(line: "Accuracy: \(accuracy)", filePath: resultsFile)
        appendLineToFile(line: "ConfusionDataFrame:\n\(evaluation.confusionDataFrame)", filePath: resultsFile)
        appendLineToFile(line: "PrecisionRecallDataFrame:\n\(evaluation.precisionRecallDataFrame)", filePath: resultsFile)
    }
}
