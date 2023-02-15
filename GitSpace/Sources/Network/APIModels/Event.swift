//
//  Event.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/15.
//

import Foundation

//typealias events = [Event]?

struct Event: Codable, Identifiable {
    let id: String
    let type: String?
    let actor: Actor
    let repo: Repo
    let `public`: Bool
    let createdAt: String
    
    enum Codingkeys: String, CodingKey {
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
    
    enum Codingkeys: String, CodingKey {
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

//{
//    "id": "22249084964",
//    "type": "PushEvent",
//    "actor": {
//      "id": 583231,
//      "login": "octocat",
//      "display_login": "octocat",
//      "gravatar_id": "",
//      "url": "https://api.github.com/users/octocat",
//      "avatar_url": "https://avatars.githubusercontent.com/u/583231?v=4"
//    },
//    "repo": {
//      "id": 1296269,
//      "name": "octocat/Hello-World",
//      "url": "https://api.github.com/repos/octocat/Hello-World"
//    },
//    "payload": {
//      "push_id": 10115855396,
//      "size": 1,
//      "distinct_size": 1,
//      "ref": "refs/heads/master",
//      "head": "7a8f3ac80e2ad2f6842cb86f576d4bfe2c03e300",
//      "before": "883efe034920928c47fe18598c01249d1a9fdabd",
//      "commits": [
//        {
//          "sha": "7a8f3ac80e2ad2f6842cb86f576d4bfe2c03e300",
//          "author": {
//            "email": "octocat@github.com",
//            "name": "Monalisa Octocat"
//          },
//          "message": "commit",
//          "distinct": true,
//          "url": "https://api.github.com/repos/octocat/Hello-World/commits/7a8f3ac80e2ad2f6842cb86f576d4bfe2c03e300"
//        }
//      ]
//    },
//    "public": true,
//    "created_at": "2022-06-09T12:47:28Z"
//  },
//  {
//    "id": "22196946742",
//    "type": "CreateEvent",
//    "actor": {
//      "id": 583231,
//      "login": "octocat",
//      "display_login": "octocat",
//      "gravatar_id": "",
//      "url": "https://api.github.com/users/octocat",
//      "avatar_url": "https://avatars.githubusercontent.com/u/583231?v=4"
//    },
//    "repo": {
//      "id": 1296269,
//      "name": "octocat/Hello-World",
//      "url": "https://api.github.com/repos/octocat/Hello-World"
//    },
//    "payload": {
//      "ref": null,
//      "ref_type": "repository",
//      "master_branch": "master",
//      "description": null,
//      "pusher_type": "user"
//    },
//    "public": false,
//    "created_at": "2022-06-07T07:50:26Z",
//    "org": {
//      "id": 9919,
//      "login": "github",
//      "gravatar_id": "",
//      "url": "https://api.github.com/orgs/github",
//      "avatar_url": "https://avatars.githubusercontent.com/u/9919?"
//    }
//  }
//]
