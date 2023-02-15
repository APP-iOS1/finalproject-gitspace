//
//  Event.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/15.
//

import Foundation

struct Event: Codable, Identifiable {
    let id: String
    let type: String?
    let actor: Actor
    let repo: Repo
    let `public`: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, type, actor, repo, `public`
        case createdAt = "created_at"
    }
}

struct Actor: Codable, Identifiable {
    let id: Int
    let login: String
    let displayLogin: String
    let gravatarID: String?
    let url: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, login, url
        case displayLogin = "display_login"
        case gravatarID = "gravatar_id"
        case avatarURL = "avatar_url"
    }
    
}

struct Repo: Codable, Identifiable {
    let id: Int
    let name: String
    let url: String
}
