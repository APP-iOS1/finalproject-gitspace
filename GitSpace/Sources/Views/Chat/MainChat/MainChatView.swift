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
	@State public var chatID: String? = nil
    
    var body: some View {
        
        ScrollView {
            ChatUserRecommendationSection()
				.padding()
            Divider()
            ChatListSection(chatID: $chatID)
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ChatRoomScrollFeatView()
                } label: {
                    Text("Scroll")
                }
            }
		}
        .fullScreenCover(isPresented: $showGuideCenter) {
            GuideCenterView()
        }
    }
}



