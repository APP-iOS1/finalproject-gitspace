//
//  Tag.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/05.
//

import Foundation

// MARK: - Temporary Tag Struct
struct Tag: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
//    var selectedCount: Int
    var isSelected: Bool = false
}
