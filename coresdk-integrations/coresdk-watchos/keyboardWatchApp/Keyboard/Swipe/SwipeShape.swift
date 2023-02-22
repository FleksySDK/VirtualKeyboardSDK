//  SwipeShape.swift
//  keyboard Watch App
//
//  Created on 10/2/23
//  
//

import SwiftUI

struct SwipeShape: Shape {
    
    let swipePoints: [SwipePoint]
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            var remainingPoints = swipePoints.reversed().map{ $0.location }
            if let firstPoint = remainingPoints.popLast() {
                path.move(to: firstPoint)
            }
            
            while let nextPoint = remainingPoints.popLast() {
                path.addLine(to: nextPoint)
            }
        }
    }
    
}
