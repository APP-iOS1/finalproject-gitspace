//
//  FollowerViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/15.
//

import Foundation
import SwiftUI

final class FollowerViewModel: ObservableObject {
    @Published var responses: [FollowerResponse] = []
    @Published var followers: [GithubUser] = []
    
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

final class FollowingViewModel: ObservableObject {
    
    private let service: GitHubService
    
    init(service: GitHubService) {
        self.service = service
    }
    
    @Published var followings: [GithubUser] = []
    @Published var isLoading: Bool = true
    var temporaryFollowings: [GithubUser] = []
    
    public func getFollowing(with userID: Int) -> GithubUser? {
        let result = followings.filter { $0.id == userID }.first
        print(#file, #function, result?.name ?? "FAILED: getFollowing")
        return result
    }
    
    @MainActor
    func requestFollowings(user: GithubUser, perPage: Int, page: Int) async -> Result<Void, GitHubAPIError> {
        
        let followingsResult = await service.requestUserFollowingList(userName: user, perPage: perPage, page: page)
        
        switch followingsResult {
        case .success(let users):
            for user in users {
                let result = await service.requestUserInformation(userName: user.login)
                
                switch result {
                case .success(let user):
                    temporaryFollowings.append(user)
                case .failure(let error):
                    return .failure(error)
                }
            }
            withAnimation(.easeInOut) {
                self.isLoading = false
            }
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
