//
//  CameraManager.swift
//  Camera-App
//
//  Created by Jared Thompkins on 11/22/23.
//
//  CameraManager.swift is expected to handle the core functionality related to accessing and managing the camera. It should include methods for setting up the camera session, handling permissions, capturing photos, and recording videos. To meet requirements, it needs to support both photo capture with a single tap and video recording with a long press.
//


import AVFoundation
import UIKit

class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureFileOutputRecordingDelegate {
    var captureSession: AVCaptureSession?
    var currentCameraPosition: AVCaptureDevice.Position?
    var photoOutput: AVCapturePhotoOutput?
    var videoOutput: AVCaptureMovieFileOutput?
    var frontCamera: AVCaptureDevice?
    var rearCamera: AVCaptureDevice?
    
    override init() {
        super.init()
        self.captureSession = AVCaptureSession()
        setupCamera()
    }
    
    func setupCamera() {
        // Initialize the capture session
        guard let captureSession = captureSession else { return }
        captureSession.beginConfiguration()
        
        configureInputDevices()
        
        configureOutputs()
        
        captureSession.commitConfiguration()
        startSession()
    }
    
    private func configureInputDevices() {
        // Attempt to get front & rear cameras
        if let rear = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            self.rearCamera = rear
            if let input = try? AVCaptureDeviceInput(device: rear), captureSession?.canAddInput(input) == true {
                captureSession?.addInput(input)
                currentCameraPosition = .back
            }
        }
        
        if let front = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front){
            self.frontCamera = front
        }
    }
    
    private func configureOutputs() {
        // Photo Output
        let photoOutput = AVCapturePhotoOutput()
        if captureSession?.canAddOutput(photoOutput) == true {
            captureSession?.addOutput(photoOutput)
            self.photoOutput = photoOutput
        }
        
        // Video Output
        let videoOutput = AVCaptureMovieFileOutput()
        if captureSession?.canAddOutput(videoOutput) == true {
            captureSession?.addOutput(videoOutput)
            self.videoOutput = videoOutput
        }
    }
    
    func capturePhoto() {
        guard let photoOutput = self.photoOutput else { return }
        
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func startRecording() {
        guard let videoOutput = self.videoOutput,
              !videoOutput.isRecording,
           //   let connection = videoOutput.connection(with: .video),
              let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let outputPath = documentsPath.appendingPathComponent("\(UUID().uuidString).mov")
        videoOutput.startRecording(to: outputPath, recordingDelegate: self)
    }
    
    func photoOutput(_ output:AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        // Handle captured photo, e.g., save it or update UI
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            print("Could not get image data.")
            return
        }
        
        let image = UIImage(data: imageData)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        // Handle finished recording, e.g., save video URL or update UI
    }
    
    func startSession() {
        if captureSession?.isRunning == false {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession?.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession?.isRunning == true {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession?.stopRunning()
            }
        }
    }
    
    func switchCamera() {
        // Ensure session exists to configure
        guard let captureSession = captureSession, let currentCameraPosition = currentCameraPosition else { return }
        
        captureSession.beginConfiguration()
        
        // Remove all current inputs
        captureSession.inputs.forEach { input in
            captureSession.removeInput(input)
        }
        
        // Switch camera
        switch currentCameraPosition {
        case .back:
            if let frontCamera = self.frontCamera, let input = try? AVCaptureDeviceInput(device: frontCamera), captureSession.canAddInput(input) {
                captureSession.addInput(input)
                self.currentCameraPosition = .front
            }
        case .front:
            if let rearCamera = self.rearCamera, let input = try? AVCaptureDeviceInput(device: rearCamera), captureSession.canAddInput(input) {
                captureSession.addInput(input)
                self.currentCameraPosition = .back
            }
        default:
            break
        }
        
        captureSession.commitConfiguration() // Commit changes
    }
}

extension CameraManager {
    // Check & request camera permissions
    func checkCameraPermissions(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        default:
            completion(false)
        }
    }
}
