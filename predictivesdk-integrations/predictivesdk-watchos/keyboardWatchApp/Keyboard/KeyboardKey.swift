//  KeyboardKey.swift
//  keyboard Watch App
//
//  Created on 7/2/23
//  
//

import SwiftUI

struct KeyboardKey: View {
    enum GestureType {
        case tap(location: CGPoint)
        case doubleTap
        case longPress
    }
    
    @EnvironmentObject var keyboardMode: KeyboardMode
    @Environment(\.colorScheme) var colorScheme
    
    let key: KeyboardLayout.Key
    let coordinateSpaceName: String
    
    let action: (KeyboardLayout.Key.Action, GestureType) -> Void
    
    init(key: KeyboardLayout.Key, coordinateSpaceName: String = .emptyString, action: @escaping (KeyboardLayout.Key.Action, GestureType) -> Void) {
        self.key = key
        self.coordinateSpaceName = coordinateSpaceName
        self.action = action
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.randomBackgroundColor(for: colorScheme)
            switch key.pictogram(mode: keyboardMode) {
            case .systemImage(named: let imageName):
                Image(systemName: imageName)
            case .text(let text):
                Text(text)
                    .scaledToFill()
            }
        }
        .cornerRadius(4)
        .padding(.all, 2)
        .contentShape(Rectangle())
        .frame(width: key.width)
        .padding(EdgeInsets(top: 0, leading: key.leftPadding, bottom: 0, trailing: key.rightPadding))
        .onTapGesture(coordinateSpace: .named(coordinateSpaceName)) { location in
            action(key.tapAction, .tap(location: location))
        }
        .if(key.doubleTapAction != nil) { view in
            view.simultaneousGesture(TapGesture(count: 2).onEnded {
                action(key.doubleTapAction!, .doubleTap)
            })
        }
        .if(key.longPressAction != nil) { view in
            view.onLongPressGesture(maximumDistance: 2) {
                action(key.longPressAction!, .longPress)
            }
        }
    }
}

struct KeyboardKey_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            KeyboardKey(key: .characterKey("Q"), action: { _, _ in })
            KeyboardKey(key: .characterKey("W"), action: { _, _ in })
            KeyboardKey(key: .characterKey("E"), action: { _, _ in })
            KeyboardKey(key: .characterKey("R"), action: { _, _ in })
            KeyboardKey(key: .characterKey("T"), action: { _, _ in })
            KeyboardKey(key: .characterKey("Y"), action: { _, _ in })
            KeyboardKey(key: KeyboardLayout.Key(tapAction: .return), action: { _, _ in })
        }
        .environmentObject(KeyboardMode(shift: .uppercase))
    }
}
