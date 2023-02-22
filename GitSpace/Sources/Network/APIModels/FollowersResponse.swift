//
//  Follower.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/15.
//

import Foundation

struct FollowersResponse: Codable, Identifiable, Equatable {
    
    let id: Int
    let name: String?
    let url: String
    let login: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, url, login
        case avatarURL = "avatar_url"
    }
    
    // 이름, 프로필사진,
    // 팔로워수, 레포지토리 수
    
}
