//
//  CollectionGroupResearchModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/20.
//

import Foundation

struct Store : Identifiable {
    let id : String = UUID().uuidString
    let name : String
}

struct Review : Identifiable {
    let id : String
    let storeID : String
    let userID : String
    let content : String
}
