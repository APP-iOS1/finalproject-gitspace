//
//  TargetUserFollowingListView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/03/20.
//

import SwiftUI

struct TargetUserFollowerListView: View {
    
    @StateObject var followerViewModel = FollowerViewModel(service: GitHubService())
    let gitHubService: GitHubService
    let targetUserLogin: String
    
    init(service: GitHubService, targetUserLogin: String) {
        self.gitHubService = service
        self.targetUserLogin = targetUserLogin
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(followerViewModel.followers) { user in
                    
                    NavigationLink(destination: TargetUserProfileView(user: user)) {
                        HStack(spacing: 20) {
                            GithubProfileImage(urlStr: user.avatar_url, size: 50)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                /* 유저네임 */
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: user.name ?? user.login)
                                
                                /* 유저ID */
                                GSText.CustomTextView(
                                    style: .sectionTitle,
                                    string: user.login)
                            } // VStack
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                        } // HStack
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    Divider()
                }
            } // VStack
        }
        .navigationBarTitle(targetUserLogin, displayMode: .inline)
        .task {
            requestTargetUserFollowerList()
        }
        .refreshable {
            requestTargetUserFollowerList()
        }
    } // body
    
    private func requestTargetUserFollowerList() -> Void {
        followerViewModel.followers.removeAll()
        followerViewModel.temporaryFollowers.removeAll()
        
        Task {
            let followerListResult = await followerViewModel.requestFollowers(user: targetUserLogin, perPage: 100, page: 1)
            
            switch followerListResult {
            case .success():
                followerViewModel.followers = followerViewModel.temporaryFollowers
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct TargetUserFollowingListView: View {
    
    @StateObject var followingViewModel = FollowingViewModel(service: GitHubService())
    let gitHubService: GitHubService
    let targetUserLogin: String
    
    init(service: GitHubService, targetUserLogin: String) {
        self.gitHubService = service
        self.targetUserLogin = targetUserLogin
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(followingViewModel.followings) { user in
                    
                    NavigationLink(destination: TargetUserProfileView(user: user)) {
                        HStack(spacing: 20) {
                            GithubProfileImage(urlStr: user.avatar_url, size: 50)
                            
                            VStack(alignment: .leading, spacing: 3) {
                                /* 유저네임 */
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: user.name ?? user.login)
                                
                                /* 유저ID */
                                GSText.CustomTextView(
                                    style: .sectionTitle,
                                    string: user.login)
                            } // VStack
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                        } // HStack
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    Divider()
                }
            } // VStack
        }
        .navigationBarTitle(targetUserLogin, displayMode: .inline)
        .task {
            requestTargetUserFollowingList()
        }
        .refreshable {
            requestTargetUserFollowingList()
        }
    } // body
    
    private func requestTargetUserFollowingList() -> Void {
        followingViewModel.followings.removeAll()
        followingViewModel.temporaryFollowings.removeAll()
        
        Task {
            let followingListResult = await followingViewModel.requestFollowings(user: targetUserLogin, perPage: 100, page: 1)
            
            switch followingListResult {
            case .success():
                followingViewModel.followings = followingViewModel.temporaryFollowings
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct TargetUserFollowingListView_Previews: PreviewProvider {
    static var previews: some View {
        TargetUserFollowingListView(service: GitHubService(), targetUserLogin: "guguhanogu")
    }
}
