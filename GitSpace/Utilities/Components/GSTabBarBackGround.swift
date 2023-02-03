//
//  GSTabBarBackGround.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/03.
//

import SwiftUI

struct GSTabBarBackGround {
    
    /**
     커스텀 탭바의 배경이 Rectangle인지 RoundedRectangle인지 선택할 수 있습니다. 또한 연관값으로 배경색상과, RoundedRectangle의 경우 cornerRadius값을 입력해주시면 됩니다.
     */
    public enum GSTabBarBackGroundStyle {
        case rectangle(backGroundColor: Color)
        case roundedRectangle(backGroundColor: Color, cornerRadius: CGFloat)
    }
    
    /**
     탭바는 가로 고정이기 때문에 HStack으로 두었습니다.
     */
    struct CustomTabBarBackgroundView<Content: View>: View {
        
        public let style: GSTabBarBackGroundStyle
        public let content: Content
     
        var body: some View {
            
            switch style {
                
            case .rectangle(let backGroundColor):
                HStack {
                    content
                }
                .edgesIgnoringSafeArea(.bottom)
                .tabBarBackGroundModifier(style: .rectangle(backGroundColor: backGroundColor))
                
            case .roundedRectangle(let backGroundColor, let cornerRadius):
                HStack {
                    content
                }
                .edgesIgnoringSafeArea(.bottom)
                .tabBarBackGroundModifier(style: .roundedRectangle(backGroundColor: backGroundColor, cornerRadius: cornerRadius))
            }
        }
        
        init(style: GSTabBarBackGroundStyle, @ViewBuilder content: () -> Content) {
            self.style = style
            self.content = content()
        }
        
    }
    
}


