//
//  GSTabBarCanvas.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/03.
//

import SwiftUI

struct GSTabBarBackGround {
    
    /**
     커스텀 탭바의 배경이 Rectangle인지 RoundedRectangle인지 선택할 수 있습니다.
     */
    public enum GSTabBarCanvasStyle {
        case rectangle
        case roundedRectangle()
    }
    
    struct CustomTabBarBackgroundView: View {
        public let style: GSTabBarCanvasStyle
        public let action: () -> Void
     
        var body: some View {
            
            switch style {
                
            case .rectangle:
                HStack {
                    
                }
            case .roundedRectangle:
                HStack {
                    
                }
            }
        }
    }
    
}


