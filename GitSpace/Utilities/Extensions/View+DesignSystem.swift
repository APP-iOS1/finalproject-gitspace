//
//  View+DesignSystem.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

extension View {	
	public func navigationLinkStyleModifier(navigationStyle: GSButtonStyle) -> some View {
		modifier(GSButtonColorSchemeModifier(style: navigationStyle))
	}
	
	public func labelHierarchyFrameModifier(style: Constant.LabelHierarchy) -> some View {
		modifier(GSLabelModifier(style: style))
	}
}

