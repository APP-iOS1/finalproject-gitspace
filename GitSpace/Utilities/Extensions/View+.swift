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
    
    
    // MARK: - 팔로워, 레포 숫자를 처리를 위한 extension
    /// Int 타입으로 된 숫자 데이터를 받아와 소수점 처리 후 단위를 붙여 String 타입으로 반환
    /// 예: 3300 -> "3.3k"
    func handleCountUnit(countInfo: Int) -> String {
        var handledCount: String
        let convertedIntCount: Double = Double(countInfo)
        
        if convertedIntCount > 999 {
            handledCount = "\((convertedIntCount / 1000).rounded())k"
        } else {
            handledCount = String(countInfo)
        }
        
        return handledCount
    }
}
