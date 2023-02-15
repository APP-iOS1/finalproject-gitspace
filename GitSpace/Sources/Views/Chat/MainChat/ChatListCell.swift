//
//  ChatListCell.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/07.
//

import SwiftUI

struct ChatListCell : View {
    
    var chat: Chat
    var targetUserName: String
    @EnvironmentObject var userStore : UserStore
    @EnvironmentObject var chatStore: ChatStore
    @State var opacity: Double = 0.4
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ProfileAsyncImage(size: 55)
                    .padding(.trailing)
                
                
                VStack(alignment: .leading) {
                    Text("@\(targetUserName)")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                        .lineLimit(1)
                        .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: !chatStore.isDoneFetch))
                    
                    Text(chat.lastContent)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: !chatStore.isDoneFetch))
                }
                
                // MARK: - 안읽은 메시지 갯수 표시
                if let count = chat.unreadMessageCount[Utility.loginUserID], count > 0 {
//                    Capsule()
//                            .fill(Color.unreadMessageCapsule)
//                            .overlay(
//                                Text("\(count)")
//                                    .foregroundColor(Color.unreadMessageText)
//                            )
                    Text("\(count)")
                        .foregroundColor(Color.unreadMessageText)
                        .padding(5)
                        .padding(.horizontal, 5)
                        .background(Color.unreadMessageCapsule)
                        .clipShape(Capsule())
                        
                }
            }
            .frame(width: 330,height: 100, alignment: .leading)
            Divider()
                .frame(width: 350)
        }
        .task {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
        }
    }
}


