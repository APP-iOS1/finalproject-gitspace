//
//  ChatView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

struct MainChatView: View {
    
    @EnvironmentObject var chatStore : ChatStore
    @State private var showGuideCenter: Bool = false
    
    var body: some View {
        
        ScrollView {
            ChatUserRecommendationSection()
				.padding()
            
            Divider()
            
            Text("채팅방 개수 : \(chatStore.chats.count)")
            Text("로그인 유저 ID : \(Utility.loginUserID)")
            
            Divider()
            ChatListSection()
        }
        // FIXME: - 추후 네비게이션 타이틀 지정 (작성자: 제균)
        .navigationTitle("")
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Text("GitSpace")
					.font(.title2)
					.bold()
			}
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showGuideCenter.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(.primary)
                }

            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddChatView()
                } label: {
                    Text("채팅 추가하기")
                }
            }
		}
        .fullScreenCover(isPresented: $showGuideCenter) {
            GuideCenterView()
        }
    }
}



