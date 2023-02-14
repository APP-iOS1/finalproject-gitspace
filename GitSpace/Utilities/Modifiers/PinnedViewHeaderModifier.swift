//
//  PinnedViewHeaderModifier.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/12.
//

import SwiftUI

struct PinnedViewHeaderModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.padding(.vertical, 12)
			.padding(.horizontal, 20)
			.frame(alignment: .leading)
			.background {
				LinearGradient(
					colors: [
						Color(.systemBackground),
						Color(.systemBackground).opacity(0.4)
					],
					startPoint: .top,
					endPoint: .bottom
				)
			}
	}
}
