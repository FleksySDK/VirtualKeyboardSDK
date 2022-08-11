//
//  UITextInput.swift
//  FleksyCoreSample
//
//  Copyright © 2022 Thingthing,Ltd. All rights reserved.
//

import UIKit

extension UITextInput {
    var selection: ClosedRange<UInt> {
        guard let selectedTextRange = self.selectedTextRange,
              let startRange = textRange(from: beginningOfDocument, to: selectedTextRange.start),
              let textToStart = text(in: startRange),
              let endRange = textRange(from: beginningOfDocument, to: selectedTextRange.end),
              let textToEnd = text(in: endRange) else {
            return 0...0
        }
        return UInt(textToStart.count)...UInt(textToEnd.count)
    }
}
