//
//  ViewControllerCamera.swift
//  MoodToday
//

import UIKit
import AVFoundation
import Vision
import Photos



class ViewControllerCamera: UIViewController, AVCapturePhotoCaptureDelegate{

    var captureSession: AVCaptureSession?
    var previewLayer = AVCaptureVideoPreviewLayer()
    var useFrontCamera = false
    var faceDetectionRequest = VNDetectFaceRectanglesRequest()
    var photoOutput: AVCapturePhotoOutput!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        captureSession = AVCaptureSession()

        // Set up the capture session
        captureSession?.sessionPreset = .photo
        
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: useFrontCamera ? .front : .back) else {
            fatalError("Unable to access camera")
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession?.addInput(input)

            photoOutput = AVCapturePhotoOutput()
            captureSession?.addOutput(photoOutput)
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
            captureSession?.addOutput(videoOutput)

            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer.frame = view.layer.bounds
            view.layer.addSublayer(previewLayer)

            captureSession?.startRunning()
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // Add a button to take a photo
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 58/255.0, green: 102/255.0, blue: 77/255.0, alpha: 1.0)
        button.layer.cornerRadius = 50.0
        button.clipsToBounds = true
        button.setTitle("", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func takePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
  
    func returnToMainWindow() {
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                    return
                }
                
                // Replace "MainViewController" with the class name of your main view controller
                let mainViewController = ViewController(nibName: "View", bundle: nil)
                
                // Set the main view controller as the root view controller
                sceneDelegate.window?.rootViewController = mainViewController
            }
        }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let imageData = photo.fileDataRepresentation() else {
            print("Error taking photo: \(error!.localizedDescription)")
            return
        }
        
        // Convert the photo data to a UIImage
        guard let image = UIImage(data: imageData) else {
            print("Unable to create image from photo data")
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if let error = error {
                print("Error saving photo: \(error.localizedDescription)")
            } else {
                print("Photo saved successfully!")
            }
            
            //self.captureSession?.stopRunning()
            //self.performSegue(withIdentifier: "", sender: self)
            
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "res") as! ImageResultViewController
                vc.image = image
                self.present(vc, animated: true)
            }
        }
        //returnToMainWindow()
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "res")
        //self.present(vc, animated: true)
        //self.navigationController?.show(vc, sender: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        captureSession?.stopRunning()
    }

    @objc func handleTap() {
        useFrontCamera = !useFrontCamera

        captureSession?.stopRunning()
        previewLayer.removeFromSuperlayer()
        //previewLayer = nil
        captureSession = nil

        viewWillAppear(false)
    }
}

extension ViewControllerCamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Process the video frames using Vision.
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([faceDetectionRequest])
        
        DispatchQueue.main.async {
            if let results = faceDetectionRequest.results {
                self.previewLayer.sublayers?.removeSubrange(1...)
                
                for result in results {
                    let x = result.boundingBox.origin.x * self.previewLayer.frame.width
                    let y = result.boundingBox.origin.y * self.previewLayer.frame.height
                    let width = result.boundingBox.width * self.previewLayer.frame.width
                    let height = result.boundingBox.height * self.previewLayer.frame.height
                    
                    let layer = CALayer()
                    layer.frame = CGRect(x: x, y: y, width: width, height: height)
                    layer.borderWidth = 2
                    layer.borderColor = UIColor.red.cgColor
                    self.previewLayer.addSublayer(layer)
                }
            }
        }
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
