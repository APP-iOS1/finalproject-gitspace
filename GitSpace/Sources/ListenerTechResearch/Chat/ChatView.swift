//
//  ChatView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var chatStore : ChatStore
    @State private var isAPIDone : Bool = true
    
    var body: some View {
        
        // MARK: -Constant : 채팅방 리스트를 최근순으로 정렬한 리스트
        ScrollView {
            // 채팅방 목록 리스트
            ForEach(chatStore.chats) { chat in
                
                NavigationLink {
                    ChatView(chatStore: chatStore, userID: userUID, chat: chat)
                } label: {
                    ListCellLabel(chat: chat,
                                  userStore: userStore)
                    .foregroundColor(.black)
                }
            }
        }
        .onAppear{
            chatStore.fetchChats()
        }
    }
}

struct ListCellLabel : View {
    
    let chat : Chat
    
    var body: some View {
        
        let enemyID = chat.userIDList.filter{$0 != userUID}.first ?? "ID 확인 불가"
        let enemyName = userStore.userList[enemyID]?.name ?? "이름 확인 불가"
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Label(enemyName, systemImage: "person.fill")
                        .bold()
                        .font(.title2)
                        .padding(.bottom, 10)
                    
                    Text(board.title)
                        .font(.title3)
                }
                
                Spacer()
                // 날짜, 시간
                VStack(alignment:.trailing) {
                    let dateTime = ChatStore().parseStringDate(strDate: chat.stringDate)
                    Text(dateTime.date)
                    Text(dateTime.time)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Divider()
            
            // 마지막 채팅 메세지
            Text(chat.lastContent)
            
        }
        .padding()
        .background(Color("mango"))
        .cornerRadius(20)
        .padding()
    }
}

