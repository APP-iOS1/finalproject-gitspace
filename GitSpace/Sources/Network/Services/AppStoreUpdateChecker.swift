//
//  AppStoreUpdateChecker.swift
//  GitSpace
//
//  Created by 원태영 on 2023/07/03.
//

import Foundation

enum AppStoreUpdateCheckerError: Error {
    case invalidInfoDictionary
    case invalidBundleID
    case invalidCurrentVersionNumber
    case invalidItunesURL
    case invalidResponse
    case failToDecoding
    case unexpectedStatusCode
    case unknown
    case emptyResponse
}

final class AppStoreUpdateChecker {
    
    
}
