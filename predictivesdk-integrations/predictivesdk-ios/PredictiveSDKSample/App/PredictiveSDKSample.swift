//
//  PredictiveSDKSample.swift
//  PredictiveSDKSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import SwiftUI

@main
struct PredictiveSDKSample: App {
    
    init() {
        LanguagesManager.shared.load()
    }
    
    var body: some Scene {
        WindowGroup {
            PredictiveServiceTestView(viewModel: PredictiveServiceTestViewModel())
        }
    }
}
