//
//  ButtonColorSchemeModifier.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

// MARK: - BUTTON COLOR SCHEME MODIFIER
public struct GSButtonStyleModifiers: ViewModifier {
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
					.tint(isDisabled ? .gsGray1 : .gsGreenPrimary)
					.shadowColorSchemeModifier()
				
			case let .secondary(isDisabled):
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
                    .tint(isDisabled ? .gsGray1 : .gsGreenPrimary)
                    .overlay {
                        // Custom Disable 구현을 위해 .disabled() 대신 Capsule을 overlay 합니다.
                        // why: .disabled() 는 systemGray를 자동으로 적용하는 이슈가 있음.
                        if isDisabled {
                            Capsule()
                                .fill(.white.opacity(0.0001))
                        }
                    }
					
			case let .tag(isAppliedInView, isSelectedInAddTagSheet):
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(
                        getTertiaryTagLightModeTintColor(
                            isAppliedInView: isAppliedInView,
                            isSelectedInAddTagSheet: isSelectedInAddTagSheet
                        )
                    )
                    .overlay {
                        if isSelectedInAddTagSheet != nil {
                            RoundedRectangle(cornerRadius: .infinity)
                                .stroke(Color.black, lineWidth: 2)
                        }
                    }
				
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
				
            case let .secondary(isDisabled):
                content
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                    .tint(isDisabled ? .gsGray1 : .gsYellowPrimary)
                    .overlay {
                        // Custom Disable 구현을 위해 .disabled() 대신 Capsule을 overlay 합니다.
                        // why: .disabled() 는 systemGray를 자동으로 적용하는 이슈가 있음.
                        if isDisabled {
                            Capsule()
                                .fill(.white.opacity(0.0001))
                        }
                    }
				
            case let .tag(isAppliedInView, isSelectedInAddTagSheet):
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(
                        getTertiaryTagDarkModeTintColor(
                            isAppliedInView: isAppliedInView,
                            isSelectedInAddTagSheet: isSelectedInAddTagSheet
                        )
                    )
                    .overlay {
                        if isSelectedInAddTagSheet != nil {
                            RoundedRectangle(cornerRadius: .infinity)
                                .stroke(Color.gsGray3, lineWidth: 2)
                        }
                    }
				
			case let .plainText(isDestructive):
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
	
    private func getTertiaryTagLightModeTintColor(
        isAppliedInView: Bool?,
        isSelectedInAddTagSheet: Bool?
    ) -> Color {
        if isAppliedInView != nil {
            return .gsGreenPrimary
        } else if let isSelectedInAddTagSheet {
            if isSelectedInAddTagSheet {
                return .black
            } else {
                return .white
            }
        }
        
        return .black
    }
    
    private func getTertiaryTagDarkModeTintColor(
        isAppliedInView: Bool?,
        isSelectedInAddTagSheet: Bool?
    ) -> Color {
        if isAppliedInView != nil {
            return .gsYellowPrimary
        } else if let isSelectedInAddTagSheet {
            if isSelectedInAddTagSheet {
                return .gsGray3
            } else {
                return .black
            }
        }
        
        return .black
    }
    
}
