//
//  ButtonColorSchemeModifier.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/03.
//

import SwiftUI

// MARK: - BUTTON COLOR SCHEME MODIFIER
public struct GSButonStyleModifiers: ViewModifier {
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
				
			case .secondary:
				content
					.buttonBorderShape(.capsule)
					.buttonStyle(.borderedProminent)
					.tint(.gsYellowPrimary)
				
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
                                .stroke(Color.white, lineWidth: 2)
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
                return .white
            } else {
                return .black
            }
        }
        
        return .black
    }
    
}
