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
        case .lightmode: // Light Mode
            content
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 17, style: .continuous)
                        .fill(.white)
                        .frame(width: .infinity)
                        .frame(minHeight: minHeight)
                    // TODO: - GSGray2로 변경 예정
                        .shadow(color: Color(uiColor: UIColor.systemGray5), radius: 6, x: 0, y: 2)
                )
            
        case .darkmode: // Dark Mode
            content
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 17, style: .continuous)
                    // TODO: - GSGray3(darkmode)로 변경 예정
                        .fill(Color(uiColor: UIColor.systemGray))
                        .frame(width: .infinity)
                        .frame(minHeight: minHeight)
                    // TODO: - GSGray2로 변경 예정
                        .shadow(color: Color(uiColor: UIColor.systemGray5), radius: 6, x: 0, y: 2)
                )
        }
    }
    
    
    init(style: GSCanvas.GSCanvasStyle) {
        self.style = style
    }
}

