//
//  Button+.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/24.
//

import SwiftUI

extension Button {
	/// - Important: ONLY USED IN DESIGN SYSTEM CODE
	public func buttonColorSchemeModifier(style: GSButtonStyle) -> some View {
		modifier(GSButonStyleModifiers(style: style))
	}
}
