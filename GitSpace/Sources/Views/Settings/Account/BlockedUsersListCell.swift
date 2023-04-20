//
//  BlockedUsersListCell.swift
//  GitSpace
//
//  Created by 최한호 on 2023/04/20.
//

import SwiftUI

struct BlockedUsersListCell: View {
    
    let targetUser: GithubUser
    
    var body: some View {
        GSCanvas.CustomCanvasView.init(style: .primary, content: {
            HStack(spacing: 15) {
                
                NavigationLink(destination: TargetUserProfileView(user: targetUser)) {
                    /* 유저 프로필 이미지 */
                    GithubProfileImage(urlStr: targetUser.avatar_url, size: 40)
                }
                
                VStack(alignment: .leading) {
                    /* 유저네임 */
                    GSText.CustomTextView(
                        style: .title3,
                        string: targetUser.name ?? targetUser.login)
                    
                    /* 유저ID */
                    GSText.CustomTextView(
                        style: .sectionTitle,
                        string: targetUser.login)
                } // VStack
                .multilineTextAlignment(.leading)
                
                Spacer()
                
                
                GSButton.CustomButtonView(
                    style: .tag(
                        isAppliedInView: true
                    )
                ) {
                    
                } label: {
                    Text("**Unblock**")
                }
            } // HStack
        }) // GSCanvas
    }
}

struct BlockedUsersListCell_Previews: PreviewProvider {
    
    static var previews: some View {
        BlockedUsersListCell(targetUser: GithubUser(id: 123, login: "guguhanogu", name: "HanHo Choi", email: "", avatar_url: "https://avatars.githubusercontent.com/u/64696968?v=4", bio: "", company: "", location: "", blog: "", public_repos: 123, followers: 123, following: 123))
    }
}
