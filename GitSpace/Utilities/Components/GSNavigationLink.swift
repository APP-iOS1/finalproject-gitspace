//
//  GSNavigationLink.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/02.
//

import SwiftUI

struct GSNavigationLink<Destination: View, Label: View>: View {
	@Environment(\.colorScheme) var colorScheme
	
	private(set) var destination: Destination
	private(set) var label: Label
	private(set) var style: Constant.LabelHierarchy
	
	// MARK: - Body
	var body: some View {
		switch style {
		case .primary:
			navigationLinkBuilder(style: style)
				.shadowColorSchemeModifier()
			
		default:
			navigationLinkBuilder(style: style)
		}
	}
	
	// MARK: - LIFECYCLE
	init(
		style: Constant.LabelHierarchy,
		destination: @escaping () -> Destination,
		label: @escaping () -> Label
	) {
		self.style = style
		self.destination = destination()
		self.label = label()
	}
	
	// MARK: - METHODS
	@ViewBuilder
	private func navigationLinkBuilder(
		style: Constant.LabelHierarchy
	) -> some View {
		NavigationLink {
			destination
		} label: {
			label
				.labelHierarchyModifier(style: style)
            // 컬러스키마에 상관없이 검은 텍스트
                .foregroundColor(.primary)
		}
		.buttonStyle(
			ViewHighlightColorStyle(style: style)
		)
	}
}

struct GSNavigationPreview: PreviewProvider {
	static var previews: some View {
		NavigationView {
			VStack {
				GSNavigationLink(style: .tertiary()) {
					Text("?")
				} label: {
					Text("Hi")
				}
				
				GSNavigationLink(style: .secondary) {
					Text("?")
				} label: {
					Text("Hi")
				}
				
				GSNavigationLink(style: .primary) {
					Text("?")
				} label: {
					Text("Hi")
				}
			}
		}
	}
}
