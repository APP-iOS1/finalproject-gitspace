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
			NavigationLink {
				destination
			} label: {
				label
					.labelHierarchyModifier(style: .primary)
			}
			.buttonStyle(
				ViewHighlightColorStyle(style: style)
			)
			.shadowColorSchemeModifier()
			
		case .secondary:
			NavigationLink {
				destination
			} label: {
				label
					.labelHierarchyModifier(style: .secondary)
			}
			.buttonStyle(
				ViewHighlightColorStyle(style: style)
			)
			
		case .tertiary:
			NavigationLink {
				destination
			} label: {
				label
					.labelHierarchyModifier(style: .tertiary())
			}
			.buttonStyle(
				ViewHighlightColorStyle(style: style)
			)
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
	private func isLightMode() -> Bool {
		colorScheme == .light ? true : false
	}
}

struct Test3: PreviewProvider {
	static var previews: some View {
		NavigationView {
			VStack {
				GSNavigationLink(style: .tertiary()) {
					Text("?")
				} label: {
					Text("Hi")
				}
			}
		}
	}
}
