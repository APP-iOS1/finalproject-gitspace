//
//  ButtonColorSchemeModifier.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

// MARK: - BUTTON COLOR SCHEME MODIFIER
public struct GSButtonColorSchemeModifier: ViewModifier {
	let style: GSButtonStyle
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
					.shadowColorSchemeModifier()
				
			case .secondary(let isDisabled):
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(isDisabled ? .gsLightGray1 : .gsGreenPrimary)
					
			case .tag(let isSelected, let isEditing):
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(tertiaryLightForegroundColor(isSelected: isSelected))
				
			case .plainText,
					.homeTab:
				content
					.foregroundColor(.primary)
				
			}
			
			// MARK: - DARK MODE
		case .dark: // dark mode
			switch style { // Button Style
			case .primary:
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(.gsYellowPrimary)
					.shadowColorSchemeModifier()
				
			case .secondary:
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(.gsYellowPrimary)
				
			case .tag(let isSelected, let isEditing):
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(tertiaryDarkForegroundColor(isSelected: isSelected))
				
			case .plainText(let isDestructive):
				content
					.foregroundColor(isDestructive ? .gsRed : .white)
			case .homeTab:
				content
					.colorInvert()
			}
			
		// neither Light nor Dark
		@unknown default:
			content
		}
	}
	
	init(style: GSButtonStyle) {
		self.style = style
	}
	
	private func tertiaryLightForegroundColor(isSelected: Bool?) -> Color {
		if let isSelected {
			if isSelected { return .gsGreenPrimary }
			else { return .primary }
		} else {
			return .primary
		}
	}
	
	private func tertiaryDarkForegroundColor(isSelected: Bool?) -> Color {
		if let isSelected {
			if isSelected { return .gsYellowPrimary }
			else { return .gsDarkGray }
		} else {
			return .black
		}
	}
}
