//
//  Repository.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/05.
//

import Foundation

// MARK: - Temporary Repository Sturct
struct Repository: Identifiable {
    var id: Int
    var name: String
    var fullName: String
    var owner: GitHubUser
    var description: String
    var tags: [Int]?
    var isPrivate: Bool
    var stargazers_count: Int
    
    enum CodingKeys : String, CodingKey{
        case fullName = "full_name"
        case isPrivate = "private"
    }
}
