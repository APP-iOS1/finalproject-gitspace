//
//  ButtonLabelLayoutModifier.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

public struct ButtonLabelLayoutModifier: ViewModifier {
	public let buttonLabel: GSButton.GSButtonStyle
	
	public func body(content: Content) -> some View {
		switch buttonLabel {
		case .primary(let isDisabled):
			content
				.modifier(GSButtonLabelModifier(
					horizontalPadding: 34,
					verticalPadding: 18,
					minWidth: 150)
				)
				.foregroundColor(isDisabled ? Color.white : Color.primary)
			
		case .secondary(let isDisabled):
			content
				.modifier(GSButtonLabelModifier(
					horizontalPadding: 23,
					verticalPadding: 13,
					minWidth: 80)
				)
				.foregroundColor(isDisabled ? .white : Color.primary)
		
		// TODO: - TAG BUTTON 액션이 다 정리되면 마지막으로 구현예정
		case .tag(let isEditing, let isSelected):
			content
				.modifier(GSButtonLabelModifier(
					horizontalPadding: 12,
					verticalPadding: 9,
					minWidth: 62)
				)
				.foregroundColor(isSelected ? Color.primary : Color.white)
			
		case .homeTab:
			content
				.foregroundColor(Color.primary)
			
		case .plainText(let isDestructive):
			content
				.foregroundColor(isDestructive ? .gsRed : Color.primary)
			
		case .navigate(let style):
			switch style {
			case .primary(let isDisabled):
				content
					.modifier(GSButtonLabelModifier(
						horizontalPadding: 34,
						verticalPadding: 18,
						minWidth: 150)
					)
					.foregroundColor(isDisabled ? Color.white : Color.primary)
				
			case .secondary(let isDisabled):
				content
					.modifier(GSButtonLabelModifier(
						horizontalPadding: 23,
						verticalPadding: 13,
						minWidth: 80)
					)
					.foregroundColor(isDisabled ? .white : Color.primary)
				
			case .tag(_, let isSelected):
				content
					.modifier(GSButtonLabelModifier(
						horizontalPadding: 12,
						verticalPadding: 9,
						minWidth: 62)
					)
					.foregroundColor(isSelected ? Color.primary : Color.white)
				
			default:
				content
			}
//			content
		}
	}
	
	init(buttonLabel: GSButton.GSButtonStyle) {
		self.buttonLabel = buttonLabel
	}
	
	fileprivate struct GSButtonLabelModifier: ViewModifier {
		let horizontalPadding: CGFloat
		let verticalPadding: CGFloat
		let minWidth: CGFloat
		
		func body(content: Content) -> some View {
			content
				.padding(.horizontal, horizontalPadding)
				.padding(.vertical, verticalPadding)
				.frame(minWidth: minWidth)
		}
	}
}

public enum ButtonLabelType {
	case primary
	case secondary(isDisabled: Bool)
	case tag
	case homeTab
	case plainText(isDestructive: Bool)
}
