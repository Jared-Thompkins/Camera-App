//
//  CameraViewModel.swift

import Foundation
import AVFoundation

class CameraViewModel: ObservableObject {
    @Published var isCameraAuthorized: Bool = false
    var cameraManager = CameraManager()

    init() {
        checkCameraPermissions()
    }
    
    func checkCameraPermissions() {
        cameraManager.checkCameraPermissions { [weak self] granted in
            DispatchQueue.main.async {
                self?.isCameraAuthorized = granted
                if granted {
                    // Setup or configure the camera here if needed
                }
            }
        }
    }
}
