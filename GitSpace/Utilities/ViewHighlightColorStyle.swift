//
//  ViewHighlightColorStyle.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

struct ViewHighlightColorStyle: ButtonStyle {
	@Environment(\.colorScheme) var colorScheme
	
	func makeBody(configuration: Self.Configuration) -> some View {
		configuration.label
			.foregroundColor(.gsGreenPrimary)
			.background(configuration.isPressed ? Color.gsGreenPrimary : Color.gsGreenPressed)
			.cornerRadius(.infinity)
	}
}
