//
//  View+DesignSystem.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

extension View {	
	public func navigationLinkStyleModifier(navigationStyle: GSButtonStyle) -> some View {
		modifier(GSButonStyleModifiers(style: navigationStyle))
	}
	
	public func labelHierarchyModifier(style: Constant.LabelHierarchy) -> some View {
		modifier(GSLabelModifier(style: style))
	}
	
	public func shadowColorSchemeModifier() -> some View {
		modifier(ShadowColorSchemeModifier())
	}
}

