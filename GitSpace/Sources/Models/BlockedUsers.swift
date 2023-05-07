//
//  BlockedUsers.swift
//  GitSpace
//
//  Created by 최한호 on 2023/05/07.
//
import Foundation

final class BlockedUsers: ObservableObject {
    /**
     currentUser의 BlockedUsers를 담아줄 배열입니다. ContentView의 retrieveBlockedUserList 메서드를 통해 currentUser의 BlockedUsers를 blockedUserList에 담아줍니다.
     - Properties: (UserInfo, GithubUser) 형식의 튜플 타입으로 이루어져 있습니다.
     - Author: 한호
     */
    @Published var blockedUserList: [(userInfo: UserInfo, gitHubUser: GithubUser)] = []
}
