//
//  GitHubAPIError.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/05.
//

import Foundation

enum GitHubAPIError: String, Error {
    case invalidURL = "URL was invalid, Please try again."
    case invalidResponse = "Invalid response from the server. Please try again."
}
