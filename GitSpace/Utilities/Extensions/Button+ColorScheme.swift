//
//  Button+.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/24.
//

import SwiftUI

extension Button {
	public struct GSButtonColorSchemeModifier: ViewModifier {
		let style: GSButton.GSButtonStyle
		@Environment(\.colorScheme) var colorScheme
		
		public func body(content: Content) -> some View {
			switch colorScheme {
				
				// MARK: - LIGHT MODE
			case .light: // light Mode
				switch style { // Button Style
				case .primary(let isDisabled):
					content
						.buttonBorderShape(.capsule)
						.buttonStyle(.borderedProminent)
						.tint(isDisabled ? .gsLightGray1 : .gsGreenPrimary)
						.shadow(color: .gsYellowPrimary.opacity(0.21),
								radius: 9,
								x: 0,
								y: 9)
				case .secondary(let isDisabled):
					content
						.buttonBorderShape(.capsule)
						.buttonStyle(.borderedProminent)
						.tint(isDisabled ? .gsLightGray1 : .gsGreenPrimary)
						.shadow(color: .gsYellowPrimary.opacity(0.21),
								radius: 9,
								x: 0,
								y: 9)
				case .tag(let isEditing, let isSelected):
					content
						.buttonBorderShape(.capsule)
						.buttonStyle(.borderedProminent)
						.tint(isSelected ? Color.gsGreenPrimary : Color.primary)
				case .plainText,
						.homeTab:
					content
						.foregroundColor(.primary)
					
				}
					
				// MARK: - DARK MODE
			case .dark: // dark mode
				switch style { // Button Style
				case .primary,
						.secondary:
					content
						.buttonBorderShape(.capsule)
						.buttonStyle(.borderedProminent)
						.tint(.gsYellowPrimary)
						.shadow(color: .gsGreenPrimary.opacity(0.29),
								radius: 36,
								x: 0,
								y: 14)
				case .tag(let isEditing, let isSelected):
					content
						.buttonBorderShape(.capsule)
						.buttonStyle(.borderedProminent)
						.tint(isSelected ? Color.gsYellowPrimary : Color.gsDarkGray)
					//						.tint(tagButtonColorModifier(isEditing: isEditing, isSelected: isSelected))
				case .plainText(let isDestructive):
					content
						.foregroundColor(isDestructive ? .gsRed : .white)
				case .homeTab:
					content
						.colorInvert()
				}
			@unknown default: // neither Light nor Dark
				content
			}	
		}
		
		fileprivate init(style: GSButton.GSButtonStyle) {
			self.style = style
		}
		
		// TODO: - branch Processing for each Bool Value
		private func tagButtonColorModifier(isEditing: Bool, isSelected: Bool) -> Color {
			if isEditing, isSelected { return .primary }
			else { return .gsGreenPrimary }
		}
	}
	
	/// - Important: ONLY USED IN DESIGN SYSTEM CODE
	public func buttonColorSchemeModifier(style: GSButton.GSButtonStyle) -> some View {
		modifier(GSButtonColorSchemeModifier(style: style))
	}
}
