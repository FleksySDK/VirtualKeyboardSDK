//  KeyboardLayout.swift
//  keyboard Watch App
//
//  Created on 7/2/23
//  
//

import Foundation


struct KeyboardLayout {
    
    class Key: Identifiable {
        enum WidthMode {
            /// The width of these keys is calculated in such a way that all keys with `WidthMode.default` have the same width in all the rows.
            case `default`
            
            /// The keys with this `WidthMode` fill the remaing horizontal space equally. These keys will have, at least, the same width as those keys with `WidthMode.default`.
            case fillEqually
            
            /// The width of the key is proportional to the available width by `scale`.
            case proportional(_ scale: CGFloat)
        }
        
        enum Action {
            case insertCharacter(Character)
            case `return`
            case deleteBack
            case deleteAll
            case shift
            case shiftUppercaseLock
            case numbers
            case emoji
        }
        
        enum KeyPictogram {
            case text(String)
            case systemImage(named: String)
        }
        
        let widthMode: WidthMode
        let tapAction: Action
        let doubleTapAction: Action?
        let longPressAction: Action?
        let id = UUID()
        
        fileprivate(set) var width: CGFloat = 40
        fileprivate(set) var leftPadding: CGFloat = 0
        fileprivate(set) var rightPadding: CGFloat = 0
        
        static func characterKey(_ character: Character) -> Key {
            Key(tapAction: .insertCharacter(character))
        }
        
        init(widthMode: WidthMode = .default, tapAction: Action, longPressAction: Action? = nil, doubleTapAction: Action? = nil) {
            self.tapAction = tapAction
            self.doubleTapAction = doubleTapAction
            self.longPressAction = longPressAction
            self.widthMode = widthMode
        }
        
        func pictogram(mode: KeyboardMode) -> KeyPictogram {
            switch tapAction {
            case .insertCharacter(let character):
                if character == " " {
                    return .text("space")
                } else {
                    return .text(mode.applyShift(to: character))
                }
            case .`return`:
                return .systemImage(named: "return")
            case .deleteBack, .deleteAll:
                return .systemImage(named: "delete.left")
            case .shift, .shiftUppercaseLock:
                switch mode.shift {
                case .lowercase:
                    return .systemImage(named: "shift")
                case .uppercase:
                    return .systemImage(named: "shift.fill")
                case .uppercaseLocked:
                    return .systemImage(named: "capslock.fill")
                }
            case .numbers:
                return .systemImage(named: "textformat.123")
            case .emoji:
                return .systemImage(named: "face.smiling.inverse")
            }
        }
    }
    class KeysRow: Identifiable {
        let id = UUID()
        let keys: [Key]
        fileprivate(set) var height: CGFloat = 60
        
        init(keys: [Key]) {
            self.keys = keys
        }
        
        func calculateDefaultWidth(availableWidth: CGFloat) -> CGFloat {
            var remainingWidth = availableWidth
            var defaultWidthKeysCount = 0
            
            keys.forEach {
                switch $0.widthMode {
                case .default, .fillEqually:
                    defaultWidthKeysCount += 1
                case .proportional(let scale):
                    let keyWidth = availableWidth * scale
                    remainingWidth -= keyWidth
                }
            }
            
            guard defaultWidthKeysCount > 0 else {
                return .infinity
            }
            return remainingWidth / CGFloat(defaultWidthKeysCount)
        }
        
        func distributeKeys(availableWidth: CGFloat, defaultWidth: CGFloat) {
            var remainingWidth = availableWidth
            var defaultWidthKeys: [Key] = []
            var fillEquallyWidthKeys: [Key] = []
            
            keys.forEach {
                switch $0.widthMode {
                case .default:
                    defaultWidthKeys.append($0)
                case .fillEqually:
                    fillEquallyWidthKeys.append($0)
                case .proportional(let scale):
                    let keyWidth = availableWidth * scale
                    remainingWidth -= keyWidth
                    $0.width = keyWidth
                }
            }
            
            defaultWidthKeys.forEach {
                remainingWidth -= defaultWidth
                $0.width = defaultWidth
            }
            
            let fillWidthCount = fillEquallyWidthKeys.count
            if fillWidthCount > 0 {
                let fillWidth = remainingWidth / CGFloat(fillWidthCount)
                fillEquallyWidthKeys.forEach {
                    $0.width = fillWidth
                }
            } else {
                let horizontalPadding = remainingWidth / 2
                keys.first?.leftPadding = horizontalPadding
                keys.last?.rightPadding = horizontalPadding
            }
        }
    }
    
    let rows: [KeysRow]
    
    init(rows: [KeysRow]) {
        self.rows = rows
    }
    
    func distributeKeys(availableSize: CGSize) {
        guard !rows.isEmpty else { return }
        
        let rowHeight = availableSize.height / CGFloat(rows.count)
        var minDefaultKeysWidth: CGFloat = .infinity
        rows.forEach {
            $0.height = rowHeight
            let widthForDefaultWidthKeys = $0.calculateDefaultWidth(availableWidth: availableSize.width)
            minDefaultKeysWidth = min(minDefaultKeysWidth, widthForDefaultWidthKeys)
        }
        
        rows.forEach {
            $0.distributeKeys(availableWidth: availableSize.width, defaultWidth: minDefaultKeysWidth)
        }
    }
    
    static let enUS: KeyboardLayout = {
        KeyboardLayout(rows: [
            KeysRow(keys: "QWERTYUIOP".map {
                KeyboardLayout.Key.characterKey($0)
            }),
            KeysRow(keys: "ASDFGHJKL".map {
                KeyboardLayout.Key.characterKey($0)
            }),
            KeysRow(keys:
                        [Key(widthMode: .fillEqually, tapAction: .shift, doubleTapAction: .shiftUppercaseLock)]
                    +
                    "ZXCVBNM".map {
                        KeyboardLayout.Key.characterKey($0)
                    }
                    +
                    [Key(widthMode: .fillEqually, tapAction: .deleteBack, longPressAction: .deleteAll)]),
            KeysRow(keys: [Key(widthMode: .fillEqually, tapAction: .insertCharacter(String.spaceCharacter))])
        ])
    }()
}


