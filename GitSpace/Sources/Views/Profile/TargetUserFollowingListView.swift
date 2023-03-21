//
//  TargetUserFollowingListView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/03/20.
//

import SwiftUI

struct TargetUserFollowingListView: View {
    
    @StateObject var followingViewModel = FollowingViewModel(service: GitHubService())
    
    let gitHubService: GitHubService
    let targetUser: GithubUser
    
    init(service: GitHubService, targetUser: GithubUser) {
        self.gitHubService = service
        self.targetUser = targetUser
    }
    
    var body: some View {
        ScrollView() {
            VStack {
                ForEach(followingViewModel.followings) { user in
                    
                    NavigationLink(destination: TargetUserProfileView(user: user)) {
                        GithubProfileImage(urlStr: user.avatar_url, size: 40)
                    }
                }
            }
        }
        .navigationBarTitle("Following", displayMode: .inline)
        .task {
            followingViewModel.followings.removeAll()
            followingViewModel.temporaryFollowings.removeAll()
            
            let followingListResult = await followingViewModel.requestFollowings(user: targetUser, perPage: 30, page: 1)
            
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
        TargetUserFollowingListView(service: GitHubService(), targetUser: GithubUser(id: 123, login: "alexandrethsilva", name: "Alexandre Theodoro da Silva helaksdkfjslekfkfkfkllllllllkkkk", email: "asdf@mnawe.com", avatar_url: "asdf", bio: "asdf", company: "asdf", location: "asdf", blog: "asdf", public_repos: 123, followers: 123, following: 123))
    }
}
