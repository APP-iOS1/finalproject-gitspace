//
//  View+.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/24.
//

import SwiftUI

extension View {
	public func buttonLabelSizeModifier(buttonLabelStyle: ButtonLabelType) -> some View {
		modifier(ButtonLabelSizeModifier(buttonLabel: buttonLabelStyle))
	}	
}

public struct ButtonLabelSizeModifier: ViewModifier {
	public let buttonLabel: ButtonLabelType
	
	public func body(content: Content) -> some View {
		switch buttonLabel {
		case .primary:
			content
				.padding(.horizontal, 34)
				.padding(.vertical, 18)
				.frame(minWidth: 150)
				.foregroundColor(.black)
		case .secondary:
			content
				.padding(.horizontal, 23)
				.padding(.vertical, 13)
				.frame(minWidth: 80)
				.foregroundColor(.black)
		case .tag:
			content
				.padding(.horizontal, 12)
				.padding(.vertical, 9)
				.frame(minWidth: 62)
				.foregroundColor(.black)
		}
	}
}

public enum ButtonLabelType {
	case primary
	case secondary
	case tag
}
