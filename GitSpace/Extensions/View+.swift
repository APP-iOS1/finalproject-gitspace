//
//  View+.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/24.
//

import SwiftUI

// TODO: 어째서 뷰가 Button Modifier를 가져야 하는가..? 아니면 이걸 기똥차게 분리할 수 있나..?
extension View {
	public func buttonLabelLayoutModifier(buttonLabelStyle: ButtonLabelType) -> some View {
		modifier(ButtonLabelLayoutModifier(buttonLabel: buttonLabelStyle))
	}
}

public struct ButtonLabelLayoutModifier: ViewModifier {
	public let buttonLabel: ButtonLabelType
	
	public func body(content: Content) -> some View {
		switch buttonLabel {
		case .primary:
			content
				.padding(.horizontal, 34)
				.padding(.vertical, 18)
				.frame(minWidth: 150)
				.foregroundColor(.black)
		case .secondary(let isDisabled):
			content
				.padding(.horizontal, 23)
				.padding(.vertical, 13)
				.frame(minWidth: 80)
				.foregroundColor(isDisabled ? .white : .black)
		case .tag:
			content
				.padding(.horizontal, 12)
				.padding(.vertical, 9)
				.frame(minWidth: 62)
				.foregroundColor(.black)
		case .homeTab:
			content
				.foregroundColor(Color.primary)
		case .plainText(let isDestructive):
			content
				.foregroundColor(isDestructive ? .gsRed : Color.primary)
		}
	}
	
	fileprivate init(buttonLabel: ButtonLabelType) {
		self.buttonLabel = buttonLabel
	}
}

public enum ButtonLabelType {
	case primary
	case secondary(isDisabled: Bool)
	case tag
	case homeTab
	case plainText(isDestructive: Bool)
}
