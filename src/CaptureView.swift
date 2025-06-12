//
//  CaptureView.swift

import SwiftUI

struct CaptureView: View {
    @ObservedObject var cameraManager: CameraManager
    @State private var flashOpacity: Double = 0.0

    var body: some View {
        ZStack {
            if let capturedImage = cameraManager.capturedImage {
                Image(uiImage: capturedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
            } else {
                CameraPreview(session: cameraManager.captureSession!)
                    .edgesIgnoringSafeArea(.all)
            }

            VStack {
                Spacer()
                CircleButton(action: {
                    print("CircleButton tapped")
                  //  cameraManager.capturePhoto()
                    triggerFlash()
                }, longPressAction: {
                    print("Start recording")
                  //  cameraManager.startRecording()
                }, releaseAction: {
                    print("Stop recording")
                   // cameraManager.stopRecording()
                })
                .padding(.bottom, 40)
            }
            
            // Flash overlay
            Color.white
                .opacity(flashOpacity)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            print("CaptureView appeared")
            cameraManager.checkCameraPermissions { granted in
                print("Camera permissions granted: \(granted)")
                if granted {
                    cameraManager.setupCamera()
                    cameraManager.startSession()
                }
            }
        }
    }

    private func triggerFlash() {
        print("Triggering flash")
        withAnimation(.easeInOut(duration: 0.1)) {
            flashOpacity = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.1)) {
                flashOpacity = 0.0
            }
        }
    }
}




