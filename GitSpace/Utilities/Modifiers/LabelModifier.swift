//
//  LabelModifier.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

struct GSLabelModifier: ViewModifier {
	@Environment(\.colorScheme) var colorScheme
	
	let style: Constant.LabelHierarchy
	let maxHeight: CGFloat? = nil
	
	func body(content: Content) -> some View {
		switch style {
		case .primary:
			content
				.foregroundColor(colorScheme == .light ? .black : .black)
				.padding(.horizontal, 34)
				.padding(.vertical, 18)
				.frame(minWidth: 150)
				.frame(maxHeight: maxHeight)
				
		case .secondary:
			content
				.foregroundColor(colorScheme == .light ? .black : .black)
				.padding(.horizontal, 23)
				.padding(.vertical, 13)
				.frame(minWidth: 80)
				.frame(maxHeight: maxHeight)
				
		case let .tertiary(isSelected):
			content
				.foregroundColor(
					colorScheme == .light
					? tertiaryLightForegroundColor(
						isSelected: isSelected)
					: tertiaryDarkForegroundColor(
						isSelected: isSelected)
				)
				.padding(.horizontal, 12)
				.padding(.vertical, 9)
				.frame(minWidth: 62)
				.frame(maxHeight: maxHeight)
		}
	}
	
	private func tertiaryLightForegroundColor(isSelected: Bool?) -> Color {
		if let isSelected {
			if isSelected { return .black }
			else { return .white }
		} else {
			return .black
		}
	}
	
	private func tertiaryDarkForegroundColor(isSelected: Bool?) -> Color {
		if let isSelected {
			if isSelected { return .black }
			else { return .white }
		} else {
			return .black
		}
	}
}
