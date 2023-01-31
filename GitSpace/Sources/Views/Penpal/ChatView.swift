//
//  ChatView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var chatStore : ChatStore
    
    var body: some View {
        
        VStack {
            ChatRecommandCardSection()
            
            Divider()
            
            ChatListSection()
        }
        
    }
}

struct ListCellLabel : View {
    
    let chat : Chat
    @EnvironmentObject var userStore : UserStore
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Label(userStore.targetUserName ?? "No Name", systemImage: "person.fill")
                        .font(.title2)
                        .padding(.bottom, 10)
                }
                
                Spacer()
                // 날짜, 시간
                VStack(alignment:.trailing) {
                    Text(chat.stringLastDate)
                    Text(chat.stringLastTime)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Divider()
            
            // 마지막 채팅 메세지
            Text(chat.lastContent)
            
        }
        .task {
            userStore.requestTargetUserName(targetID: chat.targetID)
        }
        .padding()
        .background(Color.backAccent)
        .cornerRadius(20)
        .padding()
    }
}

