//
//  GitHubAPIError.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/05.
//

import Foundation

enum GitHubAPIError: String, Error {
    /// URLComponents를 통해 URL 생성에 실패한 경우 보여줄 에러 메시지
    case invalidURL = "URL was invalid, Please try again."
    case invalidResponse = "Invalid response from the server. Please try again."
}
