//
//  CaptureView.swift

import SwiftUI


struct CaptureView: View {
    @ObservedObject var cameraManager: CameraManager
    
    var body: some View {
        ZStack {
            CameraPreview(session: cameraManager.captureSession!)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                CircleButton() {
                    // Define action for photo capture/starting video recording
                }
                .padding(.bottom, 65)
                .onTapGesture {
                    cameraManager.capturePhoto()
                }
                .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                    if isPressing {
                        cameraManager.startRecording()
                    } else {
                        cameraManager.stopRecording()
                    }
                }, perform: {})
            }
        }
        .onAppear {
            cameraManager.checkCameraPermissions { granted in
                if granted {
                    cameraManager.setupCamera()
                    cameraManager.startSession()
                }
            }
        }
    }
}
