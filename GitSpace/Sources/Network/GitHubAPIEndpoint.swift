//
//  GitHubAPIEndpoint.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/05.
//

import Foundation

/**
 GitHub API에서 사용할 기능들에 따른 구조체입니다.
 path는 path parameter 를 의미하고,
 queryItems는 필요한 query parameter를 의미합니다.
 - Author: 제균
 */

struct GitHubAPIEndpoint {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension GitHubAPIEndpoint {

    /**
     URLComponents를 사용하여 URL을 생성합니다.
     URL이 제대로 생성된다면 url을 리턴하고,
     올바르지 않은 url이 생성되면 error를 리턴합니다.
     
     - Author: 제균
     - returns:
     URL 생성 성공시: URL, 생성 실패시: Error
     */
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
 GitHub API에서 사용하려는 기능별로 연산 프로퍼티 혹은 함수를 만듭니다.
 Endpoint URL에 외부에서 입력받아야 하는 값이 없는 경우: 연산 프로퍼티, 있는 경우: 함수
 */
extension GitHubAPIEndpoint {

    /**
     사용자의 star 레포지토리 목록을 불러올때 사용하는 Endpoint.
     - Author: 제균
     - parameters:
        - queryParameters: [GitHub REST API Documentation](https://docs.github.com/en/rest/activity/starring?apiVersion=2022-11-28#list-repositories-starred-by-the-authenticated-user)를 참고하여 필요한 query parameter를 URLQueryItem의 배열로 작성합니다. default는 빈 배열입니다.
     - returns: 사용자의 star 목록을 불러올때 필요한 GitHubAPIEndpoint 구조체의 인스턴스
     - Important: GET 메서드 사용
     */

    static func getStarRepositories(_ queryParameters: [URLQueryItem] = []) -> Self {
        GitHubAPIEndpoint(path: "user/starred", queryItems: queryParameters)
    }

    /**
     레포지토리를 star하거나 unstar할때 사용하는 Endpoint.
     - Author: 제균
     - returns: 레포지토리를 star하거나 unstar할 때 필요한 GitHubAPIEndpoint 구조체의 인스턴스
     - Important: star: PUT 메서드, unstar: DELETE 메서드 사용
     */

    static func starringRepository(_ owner: String, _ repository: String) -> Self {
        GitHubAPIEndpoint(path: "user/starred/\(owner)/\(repository)")
    }

    /**
     레포지토리의 정보를 가져올 때 사용하는 Endpoint
     - Author: 제균
     - parameters:
        - owner: 레포지토리 owner의 GitHub userName, 대소문자 구분하지 않음
        - repository: 레포지토리 이름, 대소문자 구분하지 않음
     - returns: 레포지토리의 정보를 가져올 때 필요한 GitHubAPIEndpoint 구조체의 인스턴스
     - Important: GET 메서드 사용
     */

    static func getRepository(_ owner: String, _ repository: String) -> Self {
        GitHubAPIEndpoint(path: "repos/\(owner)/\(repository)")
    }

    /**
     레포지토리의 contributor 목록을 가져올 때 사용하는 Endpoint
     - Author: 제균
     - parameters:
        - owner:
        - repository:
        - queryParameters: [GitHub REST API Documentation의 Query Parameters](https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#list-repository-contributors)를 참고하여 필요한 query parameter를 URLQueryItem의 배열로 작성합니다. default는 빈 배열입니다.
     - returns: 레포지토리의 contributor 목록을 가져올 때 필요한 GitHubAPIEndpoint 구조체의 인스턴스
     - Important: GET 메서드 사용
     */

    static func getRepositoryContributors(_ owner: String, _ repository: String, _ queryParameters: [URLQueryItem] = []) -> Self {
        GitHubAPIEndpoint(path: "repos/\(owner)/\(repository)/contributors")
    }

    /**
     레포지토리의 주요 사용 언어 목록을 가져올 때 사용하는 Endpoint
     - Author: 제균
     - parameters:
        - owner: 레포지토리 owner의 GitHub userName, 대소문자 구분하지 않음
        - repository: 레포지토리 이름, 대소문자 구분하지 않음
     - returns: 레포지토리의 주요 사용 언어 목록을 가져올 때 필요한 GitHubAPIEndpoint 구조체의 인스턴스
     - Important: GET 메서드 사용
     */

    static func getRepositoryLanguages(_ owner: String, _ repository: String) -> Self {
        GitHubAPIEndpoint(path: "repos/\(owner)/\(repository)/languages")
    }

    /**
     사용자가 보유중인(권한을 가지고 있는, 공동작업자로 되어있는 레포지토리 포함) 모든 레포지토리를 가져올 때 사용하는 Endpoint
     - Author: 제균
     - parameters:
        - queryParameters: [GitHub REST API Documentation의 Query Parameters](https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-the-authenticated-user)를 참고하여 필요한 query parameter를 URLQueryItem의 배열로 작성합니다. default는 빈 배열입니다.
     - returns: 사용자가 보유중인 모든 레포지토리를 가져올 때 필요한 GitHubAPIEndpoint 구조체의 인스턴스
     - Important: GET 메서드 사용
     */

    static func getAllRepositories(_ queryParameters: [URLQueryItem] = []) -> Self {
        GitHubAPIEndpoint(path: "user/repos", queryItems: queryParameters)
    }

    /**
     특정 유저의 Public 레포지토리를 가져올 때 사용하는 Endpoint
     - Author: 제균
     - parameters:
        - userName: GitHub userName, 대소문자 구분하지 않음
        - queryParameters: [GitHub REST API Documentation의 Query Parameters](https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-a-user)를 참고하여 필요한 query parameter를 URLQueryItem의 배열로 작성합니다. default는 빈 배열입니다.
     - returns: 사용자가 보유중인 모든 레포지토리를 가져올 때 필요한 GitHubAPIEndpoint 구조체의 인스턴스
     - Important: GET 메서드 사용
     */

    static func getUserRepository(_ userName: String, _ queryParameters: [URLQueryItem] = []) -> Self {
        GitHubAPIEndpoint(path: "users/\(userName)/repos", queryItems: queryParameters)
    }

    /**
     GitHub API를 사용하여 마크다운을 HTML로 변환할 때 사용하는 Endpoint
     - Author: 제균
     - Important: Post 메서드 사용, body에 **반드시** 마크다운 텍스트 포함
     */
    static var renderMarkdownToHTML: Self {
        GitHubAPIEndpoint(path: "markdown")
    }
}
