//
//  ChatListSection.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/31.
//

import SwiftUI

struct ChatListSection: View {
    var body: some View {
        // MARK: -Constant : 채팅방 리스트를 최근순으로 정렬한 리스트
        ScrollView {
            // 채팅방 목록 리스트
            ForEach(chatStore.chats) { chat in
                
                NavigationLink {
                    ChatDetailView(chat: chat, isFromUserList: false)
                } label: {
                    ListCellLabel(chat: chat)
                    .foregroundColor(.black)
                }
            }
        }
        .onAppear{
            chatStore.fetchChats()
        }
    }
}

struct ChatListSection_Previews: PreviewProvider {
    static var previews: some View {
        ChatListSection()
    }
}
