//  KeyboardSwipe.swift
//  keyboard Watch App
//
//  Created on 10/2/23
//  
//

import SwiftUI

struct KeyboardSwipe: View {
    
    @ObservedObject var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        SwipeShape(swipePoints: viewModel.swipePoints)
            .stroke(Color.primary, lineWidth: 2)
    }
}
