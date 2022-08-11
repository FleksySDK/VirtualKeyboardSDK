//
//  FleksyCoreSample.swift
//  FleksyCoreSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import SwiftUI

@main
struct FleksyCoreSample: App {
    
    init() {
        LanguagesManager.shared.load()
    }
    
    var body: some Scene {
        WindowGroup {
            FleksylibTestView(viewModel: FleksylibTestViewModel())
        }
    }
}
