//
//  RepositoryCardView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/05.
//

import SwiftUI

// MARK: - Repository Card View
/// Starred View에서 사용되는 Repository를 감싸는 Card View입니다.
struct RepositoryCardView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    // FIXME: 배경색을 GScolor로 바꿔줘야 함
    /// systemGray 컬러를 임시 방편으로 다크모드에 대응하도록 설정하였다.
    var body: some View {
        Group(content: content)
            .background(colorScheme == .light ? .white : Color(.systemGray4))
            .cornerRadius(17)
            .shadow(
                color: Color(.systemGray6),
                radius: 8,
                x: 0, y: 2)
    }
}
