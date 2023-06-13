//  SwipePoint.swift
//  keyboard Watch App
//
//  Created on 10/2/23
//  
//

import Foundation

struct SwipePoint {
    let location: CGPoint
    let timestamp: TimeInterval
    
    init(location: CGPoint, time: Date) {
        self.location = location
        self.timestamp = time.timeIntervalSinceReferenceDate
    }
}
