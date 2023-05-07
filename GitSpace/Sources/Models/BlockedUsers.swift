//
//  BlockedUsers.swift
//  GitSpace
//
//  Created by 최한호 on 2023/05/07.
//
import Foundation

final class BlockedUsers: ObservableObject {
    
    @Published var blockedUserList: [(userInfo: UserInfo, gitHubUser: GithubUser)] = []
}
