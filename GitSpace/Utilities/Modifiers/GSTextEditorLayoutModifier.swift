//
//  GSTextEditorLayoutModifier.swift
//  GitSpace
//
//  Created by 원태영 on 2023/04/25.
//

import SwiftUI

struct GSTextEditorLayoutModifier: ViewModifier {
    
    let font: Font
    let color: Color
    let lineSpace: CGFloat
    let maxHeight: CGFloat
    let horizontalInset: CGFloat
    let bottomInset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(lineSpace)
            .frame(maxHeight: maxHeight)
            .padding(.horizontal, horizontalInset)
            .padding(.bottom, bottomInset)
    }
}
