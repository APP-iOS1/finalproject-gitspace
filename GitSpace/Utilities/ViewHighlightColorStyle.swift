//
//  ViewHighlightColorStyle.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

struct ViewHighlightColorStyle: ButtonStyle {
	let style: Constant.LabelHierarchy
	@Environment(\.colorScheme) var colorScheme
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.background(
				configuration.isPressed
				? Color.gsGreenPressed
				: colorSchemeBackgroundColor()
			)
			.cornerRadius(.infinity)
	}
	
	private func colorSchemeBackgroundColor() -> Color {
		switch colorScheme {
		case .light:
			return Color.gsGreenPrimary
		case .dark:
			return Color.gsYellowPrimary
		@unknown default:
			return Color.clear
		}
	}
}
