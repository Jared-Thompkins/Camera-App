//
//  CircleButton.swift

import SwiftUI

struct CircleButton: View {
    var action: () -> Void
    var longPressAction: (() -> Void)?
    var releaseAction: (() -> Void)?
    
    var body: some View {
        Button(action: {
            self.action()   // Quick tap
        }){
            Image(systemName: "circle.fill")
                .font(.system(size: 75))
                .foregroundColor(.white)
                .padding(3.5)
                .background(Color.black)
                .clipShape(Circle())
                .onLongPressGesture(
                    pressing: { isPressed in
                        if isPressed {
                            self.longPressAction?()
                        } else {
                            self.releaseAction?()
                        }
                    }, perform: {
                        // (Capture Video) Code to be executed when the long press gesture occurs.
                }
            )
        }
    }
}
