//
//  View+.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/24.
//

import SwiftUI

// TODO: 어째서 뷰가 Button Modifier를 가져야 하는가..? 아니면 이걸 기똥차게 분리할 수 있나..?
extension View {
	public func buttonLabelLayoutModifier(buttonLabelStyle: GSButton.GSButtonStyle) -> some View {
		modifier(ButtonLabelLayoutModifier(buttonLabel: buttonLabelStyle))
	}
    
    // MARK: - 키보드 내리기 위한 extension
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
