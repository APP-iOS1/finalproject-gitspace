//
//  Repository.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/05.
//

import Foundation

// MARK: - Temporary Repository Sturct
struct Repository: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var owner: String
    var description: String
    var tags: [Int]?
}
