//
//  RepositoryResponse.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/09.
//


import Foundation

// FIXME: - QuickType 돌린 임시 모델, 필요한 데이터만 골라서 모델링 다시 하기  
struct RepositoryResponse: Codable {
    let id: Int
    let nodeID, name, fullName: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
        case nodeID = "node_id"
    }
    
}


struct RepositoryReadmeResponse: Codable {
    let size: Int
    let name, path, content, url: String
    let gitURL, htmlURL, downloadURL: String?

    enum CodingKeys: String, CodingKey {
        case size, name, path, content, url
        case gitURL = "git_url"
        case htmlURL = "html_url"
        case downloadURL = "download_url"
    }
}
