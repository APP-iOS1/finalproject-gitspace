//
//  DesignSystemStyleEnums.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

public enum GSButtonStyle {
	case primary(isDisabled: Bool)
	case secondary(isDisabled: Bool)
    
    /**
     레포지토리뷰, 스타뷰, 필터뷰에서는 적용된 상태의 스타일을 적용하여 Green, Yellow 컬러로 tint한다
     AddTagSheetView에서는 isSelectedInAddTagSheet에 유저가 태그를 선택했는지 여부를 할당하고 흑백 컬러로 분기한다.
     */
	case tag(
        isAppliedInView: Bool? = nil,
        isSelectedInAddTagSheet: Bool? = nil
    )
	case plainText(isDestructive: Bool)
	case homeTab(tabName: String,
				 tabSelection: Binding<String>)
}
