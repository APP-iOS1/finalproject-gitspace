//
//  BlinkingSkeletonModifier.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/02/06.
//

import SwiftUI

struct BlinkingSkeletonModifier: Animatable, ViewModifier{
    
    var opacity: Double
    
    var shouldShow: Bool
    
    var animatableData: Double{
        get { opacity }
        set { opacity = newValue }
    }
    
    func body(content: Content) -> some View {
        content.overlay(
            ZStack{
                //ZStack에서 애니메이션 처리를 할 때 zIndex 지정해주지 않으면 애니메이션 에러가 발생할 수 있음.
                Color.white.zIndex(0)
                
                //아래 있는 코드의 뷰가 더 상위에 떠야하므로 zIndex 1
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray)
                    .opacity(self.opacity).zIndex(1)
            }.opacity(self.shouldShow ? 1 : 0)
        )
    }

    
}

struct BlankModifier: Animatable, ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

