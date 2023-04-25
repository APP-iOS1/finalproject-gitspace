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
                    style: .secondary(isDisabled: true)
                ) {
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
        BlockedUsersListCell(targetUser: GithubUser(id: 123, login: "guguhanogu", name: "HanHo Choi", email: "", avatar_url: "https://avatars.githubusercontent.com/u/64696968?v=4", bio: "", company: "", location: "", blog: "", public_repos: 123, followers: 123, following: 123))
    }
}
