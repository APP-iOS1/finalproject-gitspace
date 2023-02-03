//
//  ShadowColorSchemeModifier.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

// MARK: - SHADOW COLOR SCHEME MODIFIER
public struct ShadowColorSchemeModifier: ViewModifier {
	@Environment(\.colorScheme) var colorScheme
	
	public func body(content: Content) -> some View {
		switch colorScheme {
		case .light:
			content
				.shadow(
					color: .gsYellowPrimary.opacity(0.21),
					radius: 9,
					x: 0,
					y: 9
				)
		case .dark:
			content
				.shadow(
					color: .gsGreenPrimary.opacity(0.29),
					radius: 36,
					x: 0,
					y: 14
				)
		@unknown default:
			content
			
		}
	}
}
