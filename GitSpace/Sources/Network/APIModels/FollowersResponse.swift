//
//  Follower.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/15.
//

import Foundation

struct FollowersResponse: Codable {
    let id: Int
    let name: String?
    let url: String
    let login: String
    let avatarURL: String
    
    enum Codingkeys: String, CodingKey {
        case id, name, url, login
        case avatarURL = "avatar_url"
    }
    
    // 이름, 팔로워수, 프로필사진, 레포지토리 수
    
}
//{
//  "type": "array",
//  "items": {
//    "title": "Simple User",
//    "description": "A GitHub user.",
//    "type": "object",
//    "properties": {
//      "name": {
//        "type": [
//          "string",
//          "null"
//        ]
//      },
//      "email": {
//        "type": [
//          "string",
//          "null"
//        ]
//      },
//      "login": {
//        "type": "string",
//        "examples": [
//          "octocat"
//        ]
//      },
//      "id": {
//        "type": "integer",
//        "examples": [
//          1
//        ]
//      },
//      "node_id": {
//        "type": "string",
//        "examples": [
//          "MDQ6VXNlcjE="
//        ]
//      },
//      "avatar_url": {
//        "type": "string",
//        "format": "uri",
//        "examples": [
//          "https://github.com/images/error/octocat_happy.gif"
//        ]
//      },
//      "gravatar_id": {
//        "type": [
//          "string",
//          "null"
//        ],
//        "examples": [
//          "41d064eb2195891e12d0413f63227ea7"
//        ]
//      },
//      "url": {
//        "type": "string",
//        "format": "uri",
//        "examples": [
//          "https://api.github.com/users/octocat"
//        ]
//      },
//      "html_url": {
//        "type": "string",
//        "format": "uri",
//        "examples": [
//          "https://github.com/octocat"
//        ]
//      },
//      "followers_url": {
//        "type": "string",
//        "format": "uri",
//        "examples": [
//          "https://api.github.com/users/octocat/followers"
//        ]
//      },
//      "following_url": {
//        "type": "string",
//        "examples": [
//          "https://api.github.com/users/octocat/following{/other_user}"
//        ]
//      },
//      "gists_url": {
//        "type": "string",
//        "examples": [
//          "https://api.github.com/users/octocat/gists{/gist_id}"
//        ]
//      },
//      "starred_url": {
//        "type": "string",
//        "examples": [
//          "https://api.github.com/users/octocat/starred{/owner}{/repo}"
//        ]
//      },
//      "subscriptions_url": {
//        "type": "string",
//        "format": "uri",
//        "examples": [
//          "https://api.github.com/users/octocat/subscriptions"
//        ]
//      },
//      "organizations_url": {
//        "type": "string",
//        "format": "uri",
//        "examples": [
//          "https://api.github.com/users/octocat/orgs"
//        ]
//      },
//      "repos_url": {
//        "type": "string",
//        "format": "uri",
//        "examples": [
//          "https://api.github.com/users/octocat/repos"
//        ]
//      },
//      "events_url": {
//        "type": "string",
//        "examples": [
//          "https://api.github.com/users/octocat/events{/privacy}"
//        ]
//      },
//      "received_events_url": {
//        "type": "string",
//        "format": "uri",
//        "examples": [
//          "https://api.github.com/users/octocat/received_events"
//        ]
//      },
//      "type": {
//        "type": "string",
//        "examples": [
//          "User"
//        ]
//      },
//      "site_admin": {
//        "type": "boolean"
//      },
//      "starred_at": {
//        "type": "string",
//        "examples": [
//          "\"2020-07-09T00:17:55Z\""
//        ]
//      }
//    },
//    "required": [
//      "avatar_url",
//      "events_url",
//      "followers_url",
//      "following_url",
//      "gists_url",
//      "gravatar_id",
//      "html_url",
//      "id",
//      "node_id",
//      "login",
//      "organizations_url",
//      "received_events_url",
//      "repos_url",
//      "site_admin",
//      "starred_url",
//      "subscriptions_url",
//      "type",
//      "url"
//    ]
//  }
//}
