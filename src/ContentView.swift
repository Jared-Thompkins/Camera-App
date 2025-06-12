//
//  ContentView.swift

import SwiftUI

struct ContentView: View {
    @StateObject private var cameraViewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            if cameraViewModel.isCameraAuthorized {
                CaptureView(cameraManager: cameraViewModel.cameraManager)
                    .padding(.bottom, 65)
            } else {
                Text("Camera access is required.")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone X"))
    }
}
