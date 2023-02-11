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
	case tag(isSelected: Bool? = nil,
			 isEditing: Bool)
	case plainText(isDestructive: Bool)
	case homeTab(tabName: String,
				 tabSelection: Binding<String>)
}
