//
//  ChatListCell.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/07.
//

import SwiftUI

struct ChatListCell: View {
    
    let chat: Chat
    let targetUserInfo: UserInfo
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var chatStore: ChatStore
    @State var opacity: Double = 0.4
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                GithubProfileImage(urlStr: targetUserInfo.avatar_url, size: 52)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    GSText.CustomTextView(style: .title2, string: "@\(targetUserInfo.githubLogin)")
                        .lineLimit(1)
                        .padding(.bottom, 1)
                    
                    GSText.CustomTextView(style: .description,
                                          string: chat.lastContent.isEmpty
                                          ? chat.knockContent
                                          : chat.lastContent)
                }
                
                Spacer()
                HStack(alignment: .bottom) {
                    // MARK: - 안읽은 메시지 갯수 표시
                    if let count = chat.unreadMessageCount[Utility.loginUserID], count > 0 {
                        Text("\(count)")
                            .font(.system(size: 12))
                            .foregroundColor(Color.unreadMessageText)
                            .padding(3)
                            .padding(.horizontal, 5)
                            .background(Color.unreadMessageCapsule)
                            .clipShape(Capsule())
                    }
                }
            }
            .frame(height: 90, alignment: .leading)
            Divider()
        }
        .id(chat.id)
        .task {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
        }
    }
    
    private func getGithubProfileImageURL(targetUserName: String) async -> String {
        let githubService = GitHubService()
        let githubUserResult = await githubService.requestUserInformation(userName: targetUserName)
        switch githubUserResult {
        case .success(let githubUser):
            return githubUser.avatar_url
        case .failure(let error):
            print(error)
        }
        return ""
    }
}

