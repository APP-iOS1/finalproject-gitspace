//
//  KnockEllipsisMenu.swift
//  GitSpace
//
//  Created by Celan on 2023/04/24.
//

import SwiftUI

/**
 EillipsisMenu를 그리는 ViewBuilder입니다.
 Report와 Edit Menu가 Nested 되어 있습니다.
 수신인일 경우, Report 메뉴를 띄우고
 발신인일 경우, Edit 버튼을 띄웁니다.
 */
struct KnockMessageMenu: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userStore: UserStore
    @Binding var knock: Knock
    @Binding var isReporting: Bool
    @Binding var isEditingKnockMessage: Bool
    
    /**
     knock의 발신인이 현재 유저인지 id를 비교하고, 현재 유저가 보낸 knock라면 true를 리턴합니다.
     */
    private var isCurrentUserSentKnock: Bool {
        return knock.sentUserID == userStore.currentUser?.id
    }
    
    // MARK: - BODY
    var body: some View {
        switch isCurrentUserSentKnock {
        case true:
            Button {
                withAnimation {
                    isEditingKnockMessage.toggle()
                }
            } label: {
                Image(systemName: "pencil")
                    .frame(width: 40, height: 40)
            }
            .tint(colorScheme == .light ? .gsLightGray2 : .white)
            
        case false:
            Menu {
                Button(role: .destructive) {
                    withAnimation {
                        isReporting.toggle()
                    }
                } label: {
                    Label("Report", systemImage: "exclamationmark.bubble")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .frame(width: 40, height: 40)
            }
            .tint(colorScheme == .light ? .gsLightGray2 : .white)
            
        }
    }
}
