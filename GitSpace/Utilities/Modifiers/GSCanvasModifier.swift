//
//  GSCanvasColorSchemeModifier.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/02/03.
//

import SwiftUI


public struct GSCanvasModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    let style: GSCanvas.GSCanvasStyle
    let minHeight: CGFloat? = 50
    
    
    public func body(content: Content) -> some View {
        switch style {
        case .primary: // default style
            content
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 17, style: .continuous)
                        .fill(colorScheme == .dark ? Color.gsGray3 : Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: minHeight)
                        .shadow(color: .gsGray2.opacity(colorScheme == .dark ? 0.0 : 0.3), radius: 6, x: 0, y: 2)
                )
        }
    }
    
    
    init(style: GSCanvas.GSCanvasStyle) {
        self.style = style
    }
}

