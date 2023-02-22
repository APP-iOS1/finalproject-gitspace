//
//  GitHubAPIEndpoint.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/05.
//

import Foundation

/**
 사용할 API 기능별 case를 나눕니다.
 */
enum GitHubAPIEndpoint {
    case authenticatedUserInformation
    case authenticatedUserStarRepositories(page: Int)
    case authenticatedUserRepositories(page: Int)
    case authenticatedUserFollowers(perPage: Int, page: Int)
    case authenticatedUserReceivedEvents(userName: String, page: Int)
    case userInformation(userName: String)
    case userStarRepositories(userName: String, page: Int)
    case repositoryInformation(owner: String, repositoryName: String)
    case repositoryREADME(owner: String, repositoryName: String)
    case markdownToHTML(markdownString: String)
    case starRepository(owner: String, repositoryName: String)
    case unstarRepository(owner: String, repositoryName: String)
    case repositoryContributors(owner: String, repositoryName: String, page: Int)
}

extension GitHubAPIEndpoint: Endpoint {
    
    var path: String {
        switch self {
        case .authenticatedUserInformation:
            return "/user"
        case .authenticatedUserRepositories:
            return "/user/repos"
        case .authenticatedUserStarRepositories:
            return "/user/starred"
        case .authenticatedUserFollowers:
            return "/user/followers"
        case .authenticatedUserReceivedEvents(let userName, _ ):
            return "/users/\(userName)/received_events"
        case .starRepository(let owner, let repositoryName):
            return "/user/starred/\(owner)/\(repositoryName)"
        case .unstarRepository(let owner, let repositoryName):
            return "/user/starred/\(owner)/\(repositoryName)"
        case .repositoryInformation(let owner, let repositoryName):
            return "/repos/\(owner)/\(repositoryName)"
        case .repositoryContributors(let owner, let repositoryName, _ ):
            return "/repos/\(owner)/\(repositoryName)/contributors"
        case .repositoryREADME(let owner, let repositoryName):
            return "/repos/\(owner)/\(repositoryName)/readme"
        case .markdownToHTML:
            return "/markdown"
        case .userInformation(let userName):
            return "/users/\(userName)"
        case .userStarRepositories(let userName, _ ):
            return "/users/\(userName)/starred"
        
        }
        
    }

    var method: HTTPRequestMethod {
        switch self {
        case .authenticatedUserInformation:
            return .get
        case .authenticatedUserStarRepositories:
            return .get
        case .authenticatedUserRepositories:
            return .get
        case .authenticatedUserFollowers:
            return .get
        case .authenticatedUserReceivedEvents:
            return .get
        case .starRepository:
            return .put
        case .unstarRepository:
            return .delete
        case .repositoryInformation:
            return .get
        case .repositoryContributors:
            return .get
        case .repositoryREADME:
            return .get
        case .markdownToHTML:
            return .post
        case .userInformation:
            return .get
        case .userStarRepositories:
            return .get
        }
    }

    var header: [String: String]? {
        // FIXME: - 혀이님과 accessToken 관련 협의 할 것
        // 헤더 정보가 케이스별로 다르지 않다면 제거하고 통일할 것
        guard let accessToken = UserDefaults.standard.string(forKey: "AT") else { return nil }
        
        switch self {
        case .authenticatedUserInformation:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(String(describing: accessToken))",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .authenticatedUserStarRepositories:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .authenticatedUserFollowers:
            // FIXME: 유저 추천 카드 브랜치 머지 후 누락부분. 규니에게 체크 필요. By.태영
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .authenticatedUserReceivedEvents:
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
                "Authorization": "Bearer \(String(describing: accessToken))",
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
        case .repositoryREADME:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Bearer \(accessToken)",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        case .markdownToHTML:
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
        case .authenticatedUserRepositories:
            return nil
        case .authenticatedUserReceivedEvents:
            return nil
        case .starRepository:
            return nil
        case .unstarRepository:
            return nil
        case .repositoryContributors:
            return nil
        case .userInformation:
            return nil
        case .userStarRepositories:
            return nil
        case .repositoryREADME:
            return nil
        case .markdownToHTML(let markdownString):
            return [
                "text": markdownString
            ]
        case .authenticatedUserFollowers:
            return nil
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .authenticatedUserInformation:
            return []
        case .authenticatedUserStarRepositories(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
            // defualt는 한 페이지당 30개의 repository 이며, pagenation을 위해 page를 연관값으로 가짐
        case .authenticatedUserRepositories(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .authenticatedUserReceivedEvents( _ , let page):
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
        case .userInformation:
            return []
        case .userStarRepositories(_, let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .repositoryREADME:
            return []
        case .markdownToHTML:
            return []
        case .authenticatedUserFollowers(let perPage, let page):
            return [URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "per_page", value: "\(perPage)")]
        }
    }


}
