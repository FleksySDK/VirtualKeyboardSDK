//  KeyboardSwipeViewModel.swift
//  keyboard Watch App
//
//  Created on 10/2/23
//  
//

import Foundation

extension KeyboardSwipe {
    
    @MainActor
    class ViewModel: ObservableObject {
        
        @Published var swipePoints: [SwipePoint] = []
        let textProxy: TypedTextProxy
        
        init(textProxy: TypedTextProxy) {
            self.textProxy = textProxy
        }
        
        func onSwipeGestureChanged(location: CGPoint, time: Date, startLocation: CGPoint) {
            if swipePoints.isEmpty {
                onSwipeGesture(location: startLocation, time: Date(timeInterval: -0.2, since: time))
            }
            onSwipeGesture(location: location, time: time)
        }
        
        func onSwipeGestureEnded(location: CGPoint, time: Date) {
            onSwipeGesture(location: location, time: time)
            textProxy.onFinishSwipe(swipePoints)
            swipePoints.removeAll()
        }
        
        private func onSwipeGesture(location: CGPoint, time: Date) {
            let swipePoint = SwipePoint(location: location, time: time)
            swipePoints.append(swipePoint)
        }
    }
}
