//
//  GitHubAPIEndpoint.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/05.
//

import Foundation


enum GitHubAPIEndpoint {
    case authenticatedUserInformation
    case authenticatedUserStarRepositories(page: Int)
    case authenticatedUserRepositories(page: Int)
    case userInformation(userName: String)
    case userStarRepositories(userName: String, page: Int)
    case repositoryInformation(owner: String, repositoryName: String)
    case starRepository(owner: String, repositoryName: String)
    case unstarRepository(owner: String, repositoryName: String)
    case repositoryContributors(owner: String, repositoryName: String, page: Int)
}

extension GitHubAPIEndpoint: Endpoint {
    var path: String {
        switch self {
        case .authenticatedUserInformation:
            return "/user"
        case .authenticatedUserStarRepositories:
            return "/user/starred"
        case .repositoryInformation(let owner, let repositoryName):
            return "/repos/\(owner)/\(repositoryName)"
        case .starRepository(let owner, let repositoryName):
            return "/repos/\(owner)/\(repositoryName)"
        case .unstarRepository(let owner, let repositoryName):
            return "/repos/\(owner)/\(repositoryName)"
        case .repositoryContributors(let owner, let repositoryName, _ ):
            return "/repos/\(owner)/\(repositoryName)/contributors"
        case .authenticatedUserRepositories:
            return "/user/repos"
        case .userInformation(let userName):
            return "/users/\(userName)"
        case .userStarRepositories(let userName, _):
            return "/users/\(userName)/starred"
        }
    }

    var method: HTTPRequestMethod {
        switch self {
        case .authenticatedUserInformation:
            return .get
        case .authenticatedUserStarRepositories:
            return .get
        case .repositoryInformation:
            return .get
        case .starRepository:
            return .put
        case .unstarRepository:
            return .delete
        case .repositoryContributors:
            return .get
        case .authenticatedUserRepositories:
            return .get
        case .userInformation:
            return .get
        case .userStarRepositories:
            return .get
        }
    }

    var header: [String: String]? {
        // FIXME: - 혀이님과 accessToken 관련 협의 할 것
        // 헤더 정보가 케이스별로 다르지 않다면 제거하고 통일할 것
        let accessToken = "some accessToken"
        switch self {
        case .authenticatedUserInformation:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .authenticatedUserStarRepositories:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .repositoryInformation:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .starRepository:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .unstarRepository:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .repositoryContributors:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .authenticatedUserRepositories:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .userInformation:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .userStarRepositories:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        }
    }

    var body: [String: String]? {
        switch self {
        case .authenticatedUserInformation:
            return nil
        case .authenticatedUserStarRepositories:
            return nil
        case .repositoryInformation:
            return nil
        case .starRepository:
            return nil
        case .unstarRepository:
            return nil
        case .repositoryContributors:
            return nil
        case .authenticatedUserRepositories:
            return nil
        case .userInformation:
            return nil
        case .userStarRepositories:
            return nil
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .authenticatedUserInformation:
            return []
        case .authenticatedUserStarRepositories(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .repositoryInformation:
            return []
        case .starRepository:
            return []
        case .unstarRepository:
            return []
        // defualt는 한 페이지당 30명의 contributor이며, pagenation을 위해 page를 연관값으로 가짐
        case .repositoryContributors(_, _, let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        // defualt는 한 페이지당 30개의 repository 이며, pagenation을 위해 page를 연관값으로 가짐
        case .authenticatedUserRepositories(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .userInformation:
            return []
        case .userStarRepositories(_, let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }


}
