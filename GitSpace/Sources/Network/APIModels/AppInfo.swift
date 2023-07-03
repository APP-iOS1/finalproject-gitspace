//
//  AppInfo.swift
//  GitSpace
//
//  Created by 원태영 on 2023/07/03.
//

import Foundation

struct AppInfo: Codable {
    let resultCount: Int
    let results: [AppInfoResult]
}

struct AppInfoResult: Codable {
    let version: String
}
