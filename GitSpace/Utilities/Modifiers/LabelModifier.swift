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
				.padding(.horizontal, 20)
				.padding(.vertical, 10)
				.frame(minWidth: 80)
				.frame(maxHeight: maxHeight)
				
		case let .tertiary(isAppliedInView, isSelectedInAddTagSheet):
			content
				.foregroundColor(
                    tertiaryForegroundColorBuilder(
                        isAppliedInView: isAppliedInView,
                        isSelectedInAddTagSheet: isSelectedInAddTagSheet
                    )
				)
				.padding(.horizontal, 12)
				.padding(.vertical, 9)
				.frame(minWidth: 62)
				.frame(maxHeight: maxHeight)
		}
	}
	
    private func tertiaryForegroundColorBuilder(
        isAppliedInView: Bool?,
        isSelectedInAddTagSheet: Bool?
    ) -> Color {
        if isAppliedInView != nil {
            switch colorScheme {
            case .light:
                return .black
            case .dark:
                return .white
            default:
                return .primary
            }
        } else if let isSelectedInAddTagSheet {
            switch colorScheme {
            case .light:
                if isSelectedInAddTagSheet {
                    return .white
                } else if !isSelectedInAddTagSheet {
                    return .black
                }
            case .dark:
                if isSelectedInAddTagSheet {
                    return .black
                } else if !isSelectedInAddTagSheet {
                    return .white
                }
            @unknown default:
                return .white
            }
        }
        return .black
    }
}
