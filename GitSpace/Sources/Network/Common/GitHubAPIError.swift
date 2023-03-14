//
//  GitHubAPIError.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/05.
//

import Foundation

enum GitHubAPIError: Error {
    /// URLComponents를 통해 URL 생성에 실패한 경우 보여줄 에러 메시지
    case invalidURL
    case invalidResponse
    case failToDecoding
    case failToEncoding
    case failToLoadREADME
    case unauthorized
    case unexpectedStatusCode
    case notModified
    case requiresAuthentification
    case forbidden
    case notFound
    case failToRequest
    case unknown
    
    var errorDescription: String {
        switch self {
            case .invalidURL: return "URL was invalid, Please try again."
            case .invalidResponse: return "Invalid response from the server. Please try again."
            case .failToDecoding: return "Fail to decode data. Please try again"
            case .failToEncoding: return "Fail to encode data. Please try again"
            case .unauthorized: return "Authorization Failed. Please try again"
            case .unexpectedStatusCode: return "Unexpected Error occured. Please try again"
            case .notModified: return "No data modification has been made. Please try again"
            case .requiresAuthentification: return "Authentication is required. Please try again"
            case .forbidden: return "This is an invalid permission. Please Try Again"
            case .notFound: return "Resources are not found. Please Try Again"
            case .failToLoadREADME: return "Fail to load README.md from Server. Please Try Again"
            case .failToRequest: return "Fail to Request Network. Please Try Again"
            default: return "Unknown Error. Please try Again"
        }
    }
}
