//
//  View+.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/24.
//

import SwiftUI

extension View {
    
    /**
     탭바의 배경화면 생성을 위한 modifier
     */
    func tabBarBackGroundModifier(style: GSTabBarBackGround.GSTabBarBackGroundStyle) -> some View {
        modifier(TabBarBackgroundModifier(backgroundStyle: style))
    }
    
    // MARK: - 키보드 내리기 위한 extension
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
