//
//  BlockedUsersListCell.swift
//  GitSpace
//
//  Created by 최한호 on 2023/04/20.
//

import SwiftUI

struct BlockedUsersListCell: View, Blockable {
    
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @EnvironmentObject var userInfoManager: UserStore
    @EnvironmentObject var blockedUsers: BlockedUsers
        
    let userInfo: UserInfo
    let gitHubUser: GithubUser
        
    var body: some View {
        GSCanvas.CustomCanvasView.init(style: .primary, content: {
            HStack(spacing: 15) {
                
                NavigationLink(destination: TargetUserProfileView(user: gitHubUser)) {
                    
                    HStack(spacing: 15) {
                        /* 유저 프로필 이미지 */
                        GithubProfileImage(urlStr: gitHubUser.avatar_url, size: 40)
                        
                        VStack(alignment: .leading) {
                            /* 유저네임 */
                            GSText.CustomTextView(
                                style: .title3,
                                string: gitHubUser.name ?? gitHubUser.login)
                            
                            /* 유저ID */
                            GSText.CustomTextView(
                                style: .sectionTitle,
                                string: gitHubUser.login)
                        } // VStack
                        .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                GSButton.CustomButtonView(
                    style: .secondary(isDisabled: false)
                ) {
                    Task {
                        if let currentUser = userInfoManager.currentUser {
                            let _ = try await unblockTargetUser(in: currentUser, with: userInfo)
                            
                            blockedUsers.blockedUserList.removeAll {
                                $0 == (userInfo: userInfo, gitHubUser: gitHubUser)
                            }
                        }
                    }
                } label: {
                    Text("**Unblock**")
                }
            } // HStack
        }) // GSCanvas
        .padding(.horizontal, 10)
    }
}

struct BlockedUsersListCell_Previews: PreviewProvider {
    static var previews: some View {
        BlockedUsersListCell(userInfo: UserInfo(id: "0kOWGBrrDeZXzgPIN4mXptYTj0l1", createdDate: Date(), deviceToken: "", blockedUserIDs: [""], githubID: 19788294, githubLogin: "jekyun-park", githubName: "jegyun", githubEmail: "", avatar_url: "https://avatars.githubusercontent.com/u/19788294?v=4", bio: "", company: "", location: "", blog: "", public_repos: 9, followers: 47, following: 50), gitHubUser: GithubUser(id: 19788294, login: "jekyun-park", name: "jegyun", email: "parkjekyun@gmail.com", avatar_url: "https://avatars.githubusercontent.com/u/19788294?v=4", bio: "", company: "Hanyang University, ERICA", location: "Suwon", blog: "https://jegyun97.tistory.com/", public_repos: 9, followers: 47, following: 50))
    }
}
