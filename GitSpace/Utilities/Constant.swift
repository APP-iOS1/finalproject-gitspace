//
//  Constant.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

enum Constant {
	// 전체가 정적인 텍스트만 상수로 관리
	
    
    //MARK: - Text DesignSystem에 들어갈 속성값들
    enum GSTextConst {
        static let TITLE1_SIZE: CGFloat = 28
        static let TITLE1_FONT_WEIGHT: Font.Weight = .semibold
        static let TITLE1_COLOR: Color = Color.primary
        
        static let TITLE2_SIZE: CGFloat = 20
        static let TITLE2_FONT_WEIGHT: Font.Weight = .semibold
        static let TITLE2_COLOR: Color = Color.primary
        
        static let TITLE3_SIZE: CGFloat = 16
        static let TITLE3_FONT_WEIGHT: Font.Weight = .semibold
        static let TITLE3_COLOR: Color = Color.primary
        
        static let SECTION_TITLE_SIZE: CGFloat = 13
        static let SECTION_TITLE_FONT_WEIGHT: Font.Weight = .regular
        static let SECTION_TITLE_COLOR: Color = Color.gsGray2
        
        static let BODY1_SIZE: CGFloat = 16
        static let BODY1_FONT_WEIGHT: Font.Weight = .regular
        static let BODY1_COLOR: Color = Color.primary

        static let BODY2_SIZE: CGFloat = 12
        static let BODY2_FONT_WEIGHT: Font.Weight = .regular
        static let BODY2_COLOR: Color = Color.gsGray1

        static let CAPTION1_SIZE: CGFloat = 13
        static let CAPTION1_FONT_WEIGHT: Font.Weight = .medium
        static let CAPTION1_COLOR: Color = Color.gsGray2
        
        static let CAPTION2_SIZE: CGFloat = 12
        static let CAPTION2_FONT_WEIGHT: Font.Weight = .regular
        static let CAPTION2_COLOR: Color = Color.gsGray2
        
        static let DESCRIPTION_SIZE: CGFloat = 16
        static let DESCRIPTION_FONT_WEIGHT: Font.Weight = .medium
        static let DESCRIPTION_COLOR: Color = Color.gsGray2

    }
	
	
}
