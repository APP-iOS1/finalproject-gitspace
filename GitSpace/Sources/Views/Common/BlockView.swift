//
//  BlockView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/04/19.
//

import SwiftUI

struct BlockView: View, Blockable {
    
    @EnvironmentObject var userInfoManager: UserStore
    @EnvironmentObject var blockedUsers: BlockedUsers
    @Binding var isBlockViewShowing: Bool
    
    let targetUser: UserInfo
    
    var body: some View {
        VStack {
            GSText.CustomTextView(style: .title2, string: "Block")
            
            VStack(alignment: .leading) {
                GSText.CustomTextView(
                    style: .body1,
                    string: "When you block this user, the following things happen.")
                .padding(.bottom, 1)
                GSText.CustomTextView(
                    style: .description,
                    string:
"""
• You cannot knock/chat with this user.
• This user is classified as a blocked user at repository contributors.
"""
                )
            }
            .padding(.top, 10)
            .padding(.bottom, 30)
            
            VStack {
                GSText.CustomTextView(
                    style: .title3, string: "If you want to block this user?"
                )
                .padding(10)
                
                HStack(spacing: 30) {
                    GSButton.CustomButtonView(style: .plainText(isDestructive: false)) {
                        isBlockViewShowing.toggle()
                    } label: {
                        Text("No")
                            .frame(width: 100, height: 50)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke()
                            }
                    }
                    
                    GSButton.CustomButtonView(style: .plainText(isDestructive: true)) {
                        /* Block Method Call */
                        isBlockViewShowing.toggle()
                        Task {
                            if let currentUser = userInfoManager.currentUser {
                                try await blockTargetUser(in: currentUser, with: targetUser)
                            }
                        }
                        let targetGitHubUser =
                        GithubUser(id: targetUser.githubID, login: targetUser.githubLogin, name: targetUser.githubName, email: targetUser.githubEmail, avatar_url: targetUser.avatar_url, bio: targetUser.bio, company: targetUser.company, location: targetUser.location, blog: targetUser.blog, public_repos: targetUser.public_repos, followers: targetUser.followers, following: targetUser.following)
                        blockedUsers.blockedUserList.append((targetUser, targetGitHubUser))
                    } label: {
                        Text("Yes")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .background(Color.gsRed)
                            .cornerRadius(15)
                    }
                    
                }
            }
        }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(isBlockViewShowing: .constant(true), targetUser: UserInfo(id: "", createdDate: Date.now, deviceToken: "", blockedUserIDs: ["1"], githubID: 0, githubLogin: "", githubName: "test", githubEmail: "test", avatar_url: "test", bio: nil, company: nil, location: nil, blog: nil, public_repos: 0, followers: 0, following: 0))
            .environmentObject(BlockedUsers())
    }
}
