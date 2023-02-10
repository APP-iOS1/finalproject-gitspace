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
    @State private var targetName: String = ""
    @EnvironmentObject var userStore : UserStore
    @EnvironmentObject var chatStore: ChatStore
    @State var opacity: Double = 0.4
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ProfileAsyncImage(size: 55)
                    .padding(.trailing)

                
                VStack(alignment: .leading) {
                    Text("@\(targetName)")
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
            }            .frame(width: 330,height: 100, alignment: .leading)
            Divider()
                .frame(width: 350)
        }
        .task {
            targetName = await chat.targetUserName
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
        }
        .onChange(of: chatStore.isListenerModified) { n in
            Task {
                targetName = await chat.targetUserName
            }
        }
    }
}


