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
    let followers: Int
    
    init(service: GitHubService, targetUserLogin: String, followers: Int) {
        self.gitHubService = service
        self.targetUserLogin = targetUserLogin
        self.followers = followers
    }
    
    @State var isLoading: Bool = true
    
    var body: some View {
        ScrollView {
            if !isLoading {
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
            } else {
                FollowingSkeletonView()
            }
        }
        .navigationBarTitle("\(followers) followers", displayMode: .inline)
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
        
        withAnimation(.easeInOut) {
            isLoading = true
        }
        
        Task {
            let followerListResult = await followerViewModel.requestFollowers(user: targetUserLogin, perPage: 100, page: 1)
            
            switch followerListResult {
            case .success():
                followerViewModel.followers = followerViewModel.temporaryFollowers
                withAnimation(.easeInOut) {
                    isLoading = false
                }
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
    let following: Int
    
    init(service: GitHubService, targetUserLogin: String, following: Int) {
        self.gitHubService = service
        self.targetUserLogin = targetUserLogin
        self.following = following
    }
    
    @State var isLoading: Bool = true
    
    var body: some View {
        ScrollView {
            if !isLoading {
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
            } else {
                FollowingSkeletonView()
            }
        }
        .navigationBarTitle("\(following) following", displayMode: .inline)
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
        
        withAnimation(.easeInOut) {
            isLoading = true
        }
        
        Task {
            let followingListResult = await followingViewModel.requestFollowings(user: targetUserLogin, perPage: 100, page: 1)
            
            switch followingListResult {
            case .success():
                followingViewModel.followings = followingViewModel.temporaryFollowings
                withAnimation(.easeInOut) {
                    isLoading = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct TargetUserFollowingListView_Previews: PreviewProvider {
    static var previews: some View {
        TargetUserFollowingListView(service: GitHubService(), targetUserLogin: "guguhanogu", following: 123)
    }
}
