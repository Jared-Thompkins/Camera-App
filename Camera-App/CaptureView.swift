//
//  CaptureView.swift

import SwiftUI


struct CaptureView: View {
    @ObservedObject var cameraManager = CameraManager()
    
    var body: some View {
        ZStack {
            // Camera preview layer here
            
            CircleButton(action: {
                // Handle photo capture
            })
            .onTapGesture {
                cameraManager.capturePhoto()
            }
            .simultaneousGesture(LongPressGesture(minimumDuration: 0.5).onEnded { _ in
                cameraManager.startRecording()
            }.onChanged { _ in
                cameraManager.startRecording()
            })
        }
    }
}
