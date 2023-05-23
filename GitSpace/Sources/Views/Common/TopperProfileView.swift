//
//  TopperProfileView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/06.
//

import SwiftUI

struct TopperProfileView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @State private var user: UserInfo? = nil
    let targetUserInfo: UserInfo
    
    var body: some View {
        VStack(spacing: 8) {
            
            // MARK: - User Profice Pic
            GithubProfileImage(urlStr: targetUserInfo.avatar_url
                               , size: 100)
            
            
            // MARK: - User Name
            /// userName이 들어갈 자리
            Text(targetUserInfo.githubLogin)
                .bold()
                .font(.title3)
                .foregroundColor(Color(.black))
            
            // MARK: - User Info
            /// user의 레포 수, 팔로워 수,
            /// 대표 레포의 소유자 / 기여자 정보가 표시될 자리
            VStack(spacing: 3) {
                Text("\(targetUserInfo.public_repos) repositories﹒\(targetUserInfo.followers) followers")
//                Text("Owner of ") + Text("\("Airbnb-swift")").bold()
            }
            .font(.footnote)
            .foregroundColor(.gsLightGray2)
            
            // MARK: - 프로필 이동 버튼
            GSNavigationLink(style: .secondary()) {
                TargetUserProfileView(user: GithubUser(id: targetUserInfo.githubID, login: targetUserInfo.githubLogin, name: targetUserInfo.githubName, email: targetUserInfo.githubEmail, avatar_url: targetUserInfo.avatar_url, bio: targetUserInfo.bio, company: targetUserInfo.company, location: targetUserInfo.location, blog: targetUserInfo.blog, public_repos: targetUserInfo.public_repos, followers: targetUserInfo.followers, following: targetUserInfo.following), isFromTopperProfileView: true)
            } label: {
                Text("View Profile")
                    .font(.footnote)
                    .foregroundColor(.black)
                    .bold()
            }
            .padding(5)
        }
//		.task {
//			user = await userStore.requestUserInfoWithID(userID: userID)
//		}
    }
}
