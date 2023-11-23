//
//  ContentView.swift
//  Camera-App
//
//  Created by Jared Thompkins on 11/22/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            CaptureView()
                .padding(.bottom, 65)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
