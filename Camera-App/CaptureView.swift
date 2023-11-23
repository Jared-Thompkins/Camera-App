//
//  CaptureView.swift

import SwiftUI


struct CaptureView: View {
    var body: some View {
        CircleButton(action: {
            // Handle photo capture
        }, longPressAction: {
            // Handle video capture start
        }, releaseAction: {
           // Handle video capture end
        })
    }
}
