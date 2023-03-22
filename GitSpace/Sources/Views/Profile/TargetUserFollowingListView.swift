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
    @State var perPage: Int = 20
    @State var currentPage: Int = 1
    
    var body: some View {
        ScrollView {
            
            if isLoading && currentPage == 1 {
                FollowingSkeletonView()
            } else {
                VStack {
                    ForEach(Array(zip(followerViewModel.followers.indices, followerViewModel.followers)), id: \.0) { index, user in
                        
                        LazyVStack {
                            NavigationLink(destination: TargetUserProfileView(user: user)) {
                                HStack(spacing: 20) {
                                    
                                    VStack {
                                        GithubProfileImage(urlStr: user.avatar_url, size: 50)
                                        Spacer()
                                    } // VStack
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        /* 유저네임 */
                                        GSText.CustomTextView(
                                            style: .title3,
                                            string: user.name ?? user.login)
                                        
                                        /* 유저ID */
                                        GSText.CustomTextView(
                                            style: .caption1,
                                            string: user.login)
                                        
                                        /* 유저 Bio */
                                        if user.bio != nil {
                                            Text("\(user.bio!)")
                                                .font(.system(size: 12))
                                                .foregroundColor(.primary)
                                        }
                                    } // VStack
                                    .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                } // HStack
                            } // NavigationLink
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .onAppear {
                                // Paging Logic
                                if index % 20 == 15 {
                                    currentPage += 1
                                    requestTargetUserFollowerList()
                                }
                            } // onAppear
                            
                            Divider()
                        } // LazyVStack
                    } // ForEach
                    
                    if isLoading && currentPage > 1 {
                        ProgressView()
                    }
                    
                } // VStack
            } // if-else
        } // ScrollView
        .navigationBarTitle("\(followers) followers", displayMode: .inline)
        .task {
            requestTargetUserFollowerList()
        }
        .refreshable {
            // 값 초기화
            followerViewModel.followers.removeAll()
            followerViewModel.temporaryFollowers.removeAll()
            currentPage = 1
            
            requestTargetUserFollowerList()
        }
    } // body
    
    private func requestTargetUserFollowerList() -> Void {
        
        withAnimation(.easeInOut) {
            isLoading = true
        }
        
        Task {
            let followerListResult = await followerViewModel.requestFollowers(user: targetUserLogin, perPage: perPage, page: currentPage)
            
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
    @State var perPage: Int = 20
    @State var currentPage: Int = 1
    
    var body: some View {
        ScrollView {
            if isLoading && currentPage == 1 {
                FollowingSkeletonView()
            } else {
                VStack {
                    ForEach(Array(zip(followingViewModel.followings.indices, followingViewModel.followings)), id: \.0) { index, user in
                        
                        LazyVStack {
                            NavigationLink(destination: TargetUserProfileView(user: user)) {
                                HStack(spacing: 20) {
                                    
                                    VStack {
                                        GithubProfileImage(urlStr: user.avatar_url, size: 50)
                                        Spacer()
                                    } // VStack
                                    
                                    VStack(alignment: .leading, spacing: 3) {
                                        /* 유저네임 */
                                        GSText.CustomTextView(
                                            style: .title3,
                                            string: user.name ?? user.login)
                                        
                                        /* 유저ID */
                                        GSText.CustomTextView(
                                            style: .caption1,
                                            string: user.login)
                                        
                                        /* 유저 Bio */
                                        if user.bio != nil {
                                            Text("\(user.bio!)")
                                                .font(.system(size: 12))
                                                .foregroundColor(.primary)
                                        }
                                    } // VStack
                                    .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                } // HStack
                            } // NavigationLink
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .onAppear {
                                // Paging Logic
                                if index % 20 == 15 {
                                    currentPage += 1
                                    requestTargetUserFollowingList()
                                }
                            } // onAppear
                            
                            Divider()
                        } // LazyVStack
                    } // ForEach
                    
                    if isLoading && currentPage > 1 {
                        ProgressView()
                    }
                    
                } // VStack
            } // if-else
        } // ScrollView
        .navigationBarTitle("\(following) following", displayMode: .inline)
        .task {
            requestTargetUserFollowingList()
        }
        .refreshable {
            // 값 초기화
            followingViewModel.followings.removeAll()
            followingViewModel.temporaryFollowings.removeAll()
            currentPage = 1
            
            requestTargetUserFollowingList()
        }
    } // body
    
    private func requestTargetUserFollowingList() -> Void {
        
        withAnimation(.easeInOut) {
            isLoading = true
        }
        
        Task {
            let followingListResult = await followingViewModel.requestFollowings(user: targetUserLogin, perPage: perPage, page: currentPage)
            
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
