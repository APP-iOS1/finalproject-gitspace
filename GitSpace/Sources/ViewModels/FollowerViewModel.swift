//
//  FollowerViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/15.
//

import Foundation

final class FollowerViewModel: ObservableObject {
    @Published var responses: [FollowersResponse] = []
    @Published var followers: [GitHubUser] = []
    
    @MainActor func requestUsers() async {
        followers.removeAll()
        for response in responses {
            let result = await GitHubService().requestUserInformation(userName: response.login)
            switch result {
            case .success(let user):
                followers.append(user)
            case .failure(let error):
                print(error)
            }
        }
    }
}
