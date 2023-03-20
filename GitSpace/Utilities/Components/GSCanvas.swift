//
//  GSCanvas.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/02/03.
//

import Foundation
import SwiftUI


struct GSCanvas {
    public enum GSCanvasStyle {
        case primary
        /* 카드 스타일은 나중에 더 추가될 가능성 있음 (예: 프로필 뷰에서 자기소개 카드) */
    }
    
    struct CustomCanvasView<Content: View>: View {
        
        public let style: GSCanvasStyle
        public let content: Content
        
        var body: some View {
            
            content
                .modifier(GSCanvasModifier(style: .primary))
        }
        
        init(style: GSCanvasStyle, @ViewBuilder content: () -> Content) {
            self.style = style
            self.content = content()
        }
        
    }
}
