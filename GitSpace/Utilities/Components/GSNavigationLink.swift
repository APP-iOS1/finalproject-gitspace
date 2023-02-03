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
	@State private(set) var isTapped: Bool = false
	
	var body: some View {
		switch style {
		case .primary:
			NavigationLink {
				destination
			} label: {
				label
					.foregroundColor(.black)
					.labelHierarchyFrameModifier(style: .primary)
			}
			.buttonStyle(ViewHighlightColorStyle())
			
		case .secondary:
			NavigationLink {
				destination
			} label: {
				label
					.foregroundColor(.black)
					.labelHierarchyFrameModifier(style: .secondary)
			}
			.background {
				Capsule()
					.foregroundColor(
						isLightMode() ? .gsGreenPrimary : .gsYellowPrimary
					)
			}
		case .tertiary:
			NavigationLink {
				destination
			} label: {
				label
					.foregroundColor(.primary)
					.labelHierarchyFrameModifier(style: .tertiary)
			}
			.background {
				Capsule()
					.foregroundColor(
						isLightMode() ? .gsGreenPrimary : .gsYellowPrimary
					)
			}
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
			GSNavigationLink(style: .primary) {
				Text("?")
			} label: {
				Text("Hi")
			}
		}
	}
}
