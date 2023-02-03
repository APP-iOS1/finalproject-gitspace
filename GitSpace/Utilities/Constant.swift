//
//  Constant.swift
//  GitSpace
//
//  Created by 이승준, 원태영, 이다혜, 최한호, 정예슬, 박제균, 최예은 on 2023/02/03.
//

import SwiftUI

public enum Constant {
	// 전체가 정적인 텍스트만 상수로 관리
	
	/* EXAMPLE
	 
	 enum Example {
		static let HORIZONTAL_PADDING: CGFloat = 24
	 }
	 
	 enum Button {
		 static let script = 24
		 static let editButton = 40
		 static let defaultButton = 48
		 static let camperAuthButtonHeight = 48
		 static let domainWidth = 120
		 static let domainHeight = 60
		 static let camera = 24
		 static let blogLinkChangeWidth = 50
		 static let blogLinkChangeHeight = 30
	 }
	 */

    
    enum TextFieldConst {
        
        static let SEARCHBAR_SYMBOL_PLACEHOLDER_SPACE: CGFloat = 8
        static let SEARCHBAR_INSET_HORIZONTAL: CGFloat = 14
        static let SEARCHBAR_INSET_VERTICAL: CGFloat = 12
        static let SEARCHBAR_CORNER_RADIUS: CGFloat = 10
        static let SEARCHBAR_FIELD_SYMBOL_NAME: String = "magnifyingglass"
        static let SEARCHBAR_FIELD_PLACEHOLDER: String = "Search"
        
        static let ADDTAG_INSET_HORIZONTAL: CGFloat = 10
        static let ADDTAG_INSET_VERTICAL: CGFloat = 10
        static let ADDTAG_CORNER_RADIUS: CGFloat = 10
        static let ADDTAG_FIELD_PLACEHOLDER: String = "Tag name"
        
    }

	
	public enum LabelHierarchy {
		case primary
		case secondary
		case tertiary(isSelected: Bool? = nil)
	}

}
