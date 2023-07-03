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
    
    static func isNewVersionAvailable() async -> Result<Bool, AppStoreUpdateCheckerError> {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            return .failure(.invalidInfoDictionary)
        }
        
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return .failure(.invalidBundleID)
        }
        
        guard var currentVersionNumber = infoDictionary["CFBundleShortVersionString"] as? String else {
            return .failure(.invalidCurrentVersionNumber)
        }
        
        if currentVersionNumber.components(separatedBy: ".").count <= 2 {
            currentVersionNumber += ".0"
        }
        
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundleID)") else {
            return .failure(.invalidItunesURL)
        }
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(from: url)

            guard let response = urlResponse as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            guard Array(200...299).contains(response.statusCode) else {
                return .failure(.unexpectedStatusCode)
            }

            guard let decodedResponse = try? JSONDecoder().decode(
                AppInfo.self,
                from: data
            ) else {
                return .failure(.failToDecoding)
            }
            
            guard let latestVersionNumber = decodedResponse.results.first?.version else {
                return .failure(.emptyResponse)
            }
            
            return .success(currentVersionNumber != latestVersionNumber)

        } catch {
            return .failure(.unknown)
        }
    }
    
}
