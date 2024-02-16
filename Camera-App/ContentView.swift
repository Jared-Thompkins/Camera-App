//
//  ContentView.swift
//  Camera-App
//
//  Created by Jared Thompkins on 11/22/23.
//

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
    }
}
