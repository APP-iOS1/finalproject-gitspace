//
//  Button+.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/24.
//

import SwiftUI

extension Button {
	
	struct GSButtonModifier: ViewModifier {
		@Environment(\.colorScheme) var colorScheme
		
		func body(content: Content) -> some View {
			switch colorScheme {
			case .light:
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(.gsGreenPrimary)
					.shadow(color: .gsYellowPrimary.opacity(0.21),
							radius: 9,
							x: 0,
							y: 9)
			case .dark:
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(.gsYellowPrimary)
					.shadow(color: .gsGreenPrimary.opacity(0.29),
							radius: 36,
							x: 0,
							y: 14)
				
			@unknown default:
				content
			}
		}
	}
	
	public func buttonColorSchemeModifier() -> some View {
		modifier(GSButtonModifier())
	}
}
