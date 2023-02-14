//
//  Tag.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/05.
//

import Foundation

// MARK: - Temporary Tag Struct
struct Tag: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var tagName: String
    var repositories: [String]  // “${username}/${repoName}”
    var isSelected: Bool = false
}
