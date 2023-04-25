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
 수신인일 경우, Report 버튼을 띄우고
 발신인일 경우, Edit 버튼을 띄웁니다.
 */
struct KnockEllipsisMenu: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userStore: UserStore
    @Binding var knock: Knock
    @Binding var isReporting: Bool
    @Binding var isEditingKnockMessage: Bool
    
    var body: some View {
        Menu {
            /// Report
            if knock.receivedUserID == userStore.currentUser?.id {
                Button(role: .destructive) {
                    withAnimation {
                        isReporting.toggle()
                    }
                } label: {
                    Label("Report", systemImage: "nosign")
                }
            }
            
            Divider()
            
            /// Edit
            if knock.sentUserID == userStore.currentUser?.id {
                Button {
                    withAnimation {
                        isEditingKnockMessage.toggle()
                    }
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
        } label: {
            Image(systemName: "ellipsis")
                .frame(width: 40, height: 40)
        }
        .tint(colorScheme == .light ? .gsLightGray2 : .white)
    }
}
