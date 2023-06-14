//
//  ForEach.swift
//  PredictiveSDKSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import Foundation
import SwiftUI

extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}
