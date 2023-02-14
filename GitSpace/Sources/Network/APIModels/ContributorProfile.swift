//
//  ContributorProfile.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/14.
//

import Foundation

struct ContributorProfile: Identifiable, Codable {

    var id: Int // 고유 id
    var login: String // github id
    
    var url: String
    var avatar_url: String // profile image
    
    var followers_url: String // followers
    var following_url: String // following

}
