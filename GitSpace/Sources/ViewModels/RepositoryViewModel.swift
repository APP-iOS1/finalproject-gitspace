//
//  RepositoryStore.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/05.
//

import Foundation

final class RepositoryViewModel: ObservableObject {
    // MARK: - Dummy Tag Data
    @Published var tags: [Tag] = [
        Tag(name: "SwiftUI"),
        Tag(name: "Swift"),
        Tag(name: "MVVM"),
        Tag(name: "Interview"),
        Tag(name: "iOS"),
        Tag(name: "UIKit"),
        Tag(name: "Yummy"),
        Tag(name: "Checkit"),
        Tag(name: "TheVoca"),
        Tag(name: "GGOM-GGO-MI")
    ]
    
    @Published var repositories: [Repository]?
    
    // MARK: - Request Starred Repositories
    /// 인증된 사용자가 Star로 지정한 Repository의 목록을 요청합니다.
    @MainActor
    func requestStarredRepositories(page: Int) async -> Void {
        let session = URLSession(configuration: .default)
        var gitHubComponent = URLComponents(string: GithubURL.baseURL.rawValue + GithubURL.userPath.rawValue + GithubURL.starredPath.rawValue + "?")
        gitHubComponent?.queryItems = [
            URLQueryItem(name: "per_page", value: "30"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        var request = URLRequest(url: (gitHubComponent?.url)!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(String(describing: tempoaryAccessToken!))", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // FIXME: status code에 따라 네트워크 에러 처리하기
            /// 200이면 통과, 401이면 인증되지 않은 사용자 등 문제 해결하기
            /// let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            self.repositories = DecodingManager.decodeArrayData(data, [Repository].self)
        } catch {
            print(#function, "Starred Repository Error")
        }
    }
}
