//
//  View+TextEditorBackgroundColor.swift
//  GitSpace
//
//  Created by Celan on 2023/07/06.
//

import SwiftUI

public extension View {
    func textEditorBackgroundClear() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
