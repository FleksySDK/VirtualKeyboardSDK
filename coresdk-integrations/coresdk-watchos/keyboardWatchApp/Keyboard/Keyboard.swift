//  Keyboard.swift
//  keyboard Watch App
//
//  Created on 7/2/23
//  
//

import SwiftUI

struct Keyboard: View {
    @ObservedObject private var viewModel: ViewModel
    
    private static let keyboardAspectRatio: CGFloat = 16.0 / 9.0
    private static let coordinateSpaceName = "keyboard"
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            ZStack(alignment: .center) {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        ForEach(viewModel.buildRows(in: geometry)) { row in
                            HStack(spacing: 0) {
                                ForEach(row.keys) { key in
                                    KeyboardKey(key: key, coordinateSpaceName: Self.coordinateSpaceName) {
                                        viewModel.executeAction($0, $1)
                                    }
                                        .frame(height: row.height, alignment: .bottomTrailing)
                                }
                            }
                        }
                    }
                    .font(.system(size: 12))
                }
                KeyboardSwipe(viewModel: viewModel.swipeViewModel)
            }
        }
        .aspectRatio(Self.keyboardAspectRatio, contentMode: .fill)
        .coordinateSpace(name: Self.coordinateSpaceName)
        .gesture(DragGesture(minimumDistance: 2)
            .onChanged({ value in
                viewModel.swipeViewModel.onSwipeGestureChanged(location: value.location, time: value.time, startLocation: value.startLocation)
            })
            .onEnded({ value in
                viewModel.swipeViewModel.onSwipeGestureEnded(location: value.location, time: value.time)
            })
        )
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard(viewModel: Keyboard.ViewModel(layout: .enUS, textProxy: TypedTextProxy()))
    }
}
