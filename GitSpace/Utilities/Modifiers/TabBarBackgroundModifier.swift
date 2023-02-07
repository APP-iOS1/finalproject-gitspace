//
//  TabBarBackgroundModifier.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/03.
//

import SwiftUI

struct TabBarBackgroundModifier: ViewModifier {
    
    let style: GSTabBarBackGround.GSTabBarBackGroundStyle
    
    init(backgroundStyle: GSTabBarBackGround.GSTabBarBackGroundStyle) {
        self.style = backgroundStyle
    }
    
    func body(content: Content) -> some View {
        switch style {
        case .rectangle(let backGroundColor):
            content
                .background(backGroundColor)
        case .roundedRectangle(let backGroundColor, let cornerRadius):
            content
                .background(backGroundColor)
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
        }
    }
    
}
