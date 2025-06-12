//
//  CircleButton.swift

import SwiftUI

struct CircleButton: View {
    var action: () -> Void
    var longPressAction: (() -> Void)?
    var releaseAction: (() -> Void)?

    @GestureState private var isDetectingLongPress = false
    @State private var isLongPressing = false

    var body: some View {
        ZStack {
            Image(systemName: "circle")
                .font(.system(size: 90))
                .foregroundColor(.white)
                .padding(3.5)
                .background(Color.clear)
                .clipShape(Circle())
                .gesture(
                    TapGesture()
                        .onEnded {
                            if !isLongPressing {
                                print("Button action triggered")
                                self.action()   // Quick tap
                            }
                        }
                )
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                            gestureState = true
                        }
                        .onChanged { _ in
                            if !isLongPressing {
                                isLongPressing = true
                                print("Long press started")
                                self.longPressAction?()
                            }
                        }
                        .onEnded { _ in
                            if isLongPressing {
                                isLongPressing = false
                                print("Long press ended")
                                self.releaseAction?()
                            }
                        }
                )
        }
    }
}
