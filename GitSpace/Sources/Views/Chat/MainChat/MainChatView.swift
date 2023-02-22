//
//  ChatView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

struct MainChatView: View {
    
    let gitHubService = GitHubService()
    
    @EnvironmentObject var chatStore : ChatStore
    @StateObject var followerViewModel = FollowerViewModel()
    @State private var showGuideCenter: Bool = false
	@State public var chatID: String? = nil
    
    var body: some View {
        
        ScrollView {
            // FIXME: - 팔로워 0명일때 분기처리
            ChatUserRecommendationSection(followerViewModel: followerViewModel)
				.padding()
            Divider()
            ChatListSection(chatID: $chatID)
        }
        .onAppear {
            Task {
                let followerResult = await gitHubService.requestAuthenticatedUserFollowers(perPage: 100, page: 1)
                switch followerResult {
                case .success(let followers):
                    followerViewModel.responses.removeAll()
                    followerViewModel.responses = Array(followers.shuffled()[0...2])
                    await followerViewModel.requestUsers()
                case .failure(let error):
                    print(error)
                }
            }
        }
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
            
            /*
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddChatView()
                } label: {
                    Text("채팅 추가하기")
                }
            }
             */
		}
        .fullScreenCover(isPresented: $showGuideCenter) {
            GuideCenterView()
        }
    }
}



