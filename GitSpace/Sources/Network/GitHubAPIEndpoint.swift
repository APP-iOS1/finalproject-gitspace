//
//  GitHubAPI.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/05.
//

import Foundation

/**
 GitHub API에서 사용할 기능들에 따른 구조체입니다.
 path는 EndPoint 경로를 나타내며,
 queryItems에는 필요한 query 혹은 파라미터를 말합니다.
 - Author: 제균
 */
struct GitHubAPIEndpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
    let baseURL = "https://api.github.com/"
}

/**
 URLComponents를 사용하여 URL을 생성합니다.
 URL이 제대로 생성된다면 url을 리턴하고,
 올바르지 않은 url이 생성되면 error를 리턴합니다.
 */
extension GitHubAPIEndpoint {
    var url: Result<URL, GitHubAPIError> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return .failure(GitHubAPIError.invalidURL)
        }
        
        return .success(url)
    }
}

/**
 GitHub API에서 사용하려는 기능별로 연산 프로퍼티를 만듭니다.
 */
extension GitHubAPIEndpoint {
    /**
     인증된 유저의 star 목록을 불러옵니다.
     */
    static var starList: Self {
        GitHubAPIEndpoint(path: "user/starred")
    }
}
