//
//  GitHubUser.swift
//  GitSpace
//
//  Created by 이다혜, 박제균 on 2023/02/09.
//

import Foundation

struct GitHubUser: Identifiable, Codable {
    let id : Int       // 고유 id
    let login: String   // github id
    let name : String?  // username
    let email : String? // email
    let avatar_url: String // profile image
    let bio: String? // bio, intro message
    let company: String? // company
    let location: String? // location
    let blog: String? // blog url
    let public_repos: Int // public repos
    let followers: Int // followers
    let following: Int // following
    let public_repos: Int
}

