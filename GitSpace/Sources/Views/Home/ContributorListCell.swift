//
//  ContributorListCell.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/27.
//

import SwiftUI

// MARK: - GitSpaceUser Cell
/// GitSpace를 사용하는 Contributor들을 보여주는 Cell 입니다.
struct ContributorGitSpaceUserListCell: View {

    let targetUser: GithubUser

    var body: some View {
        
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                HStack(spacing: 15) {
                    /* 유저 프로필 이미지 */
                    GithubProfileImage(urlStr: targetUser.avatar_url, size: 40)

                    VStack(alignment: .leading) {
                        /* 유저네임 */
                        GSText.CustomTextView(
                            style: .title3,
                            string: targetUser.name ?? targetUser.login)

                        /* 유저ID */
                        GSText.CustomTextView(
                            style: .sectionTitle,
                            string: targetUser.login)
                    }
                    
                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.gsGray2)
                } // HStack
            }) // GSCanvas
    }
}

// MARK: - Non-GitSpaceUser Cell
/// GitSpace를 사용하지 않는 Contributor들을 보여주는 Cell 입니다.
struct ContributorListCell: View {

    let targetUser: GithubUser

    var body: some View {
        
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                HStack(spacing: 15) {
                    /* 유저 프로필 이미지 */
                    GithubProfileImage(urlStr: targetUser.avatar_url, size: 40)

                    VStack(alignment: .leading) {
                        /* 유저네임 */
                        GSText.CustomTextView(
                            style: .title3,
                            string: targetUser.name ?? targetUser.login)

                        /* 유저ID */
                        GSText.CustomTextView(
                            style: .sectionTitle,
                            string: targetUser.login)
                    }
                    Spacer()
                } // HStack
            }) // GSCanvas
    }
}


struct ContributorListCell_Previews: PreviewProvider {
    static var previews: some View {
        ContributorListCell(targetUser: GithubUser(id: 123, login: "asdf", name: "asdf", email: "asdf@mnawe.com", avatar_url: "asdf", bio: "asdf", company: "asdf", location: "asdf", blog: "asdf", public_repos: 123, followers: 123, following: 123))
    }
}
