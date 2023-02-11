//
//  GitHubUser.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/09.
//

import Foundation

struct GitHubUser: Identifiable, Codable {
    var id : Int        // 고유 id
    var login: String   // github id
    var name : String?  // usernamae
    var email : String? // email
}
