//
//  RepositoryStore.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/05.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class RepositoryViewModel: ObservableObject {
//    @Published var tags: [Tag] = []
    @Published var repositories: [Repository]?
    @Published var filteredRepositories: [Repository]?
    private let database = Firestore.firestore()
    private let const = Constant.FirestorePathConst.self
    
    // MARK: - Request Starred Repositories
    /// 인증된 사용자가 Star로 지정한 Repository의 목록을 요청합니다.
    @MainActor
    func requestStarredRepositories(page: Int) async -> [Repository]? {
        let session = URLSession(configuration: .default)
        let githubAccessToken = UserDefaults.standard.string(forKey: "AT")
        var gitHubComponent = URLComponents(string: GithubURL.baseURL.rawValue + GithubURL.userPath.rawValue + GithubURL.starredPath.rawValue + "?")
        gitHubComponent?.queryItems = [
            URLQueryItem(name: "per_page", value: "30"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        var request = URLRequest(url: (gitHubComponent?.url)!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(String(describing: githubAccessToken!))", forHTTPHeaderField: "Authorization")
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await session.data(for: request)
            // FIXME: status code에 따라 네트워크 에러 처리하기
            /// 200이면 통과, 401이면 인증되지 않은 사용자 등 문제 해결하기
            /// let statusCode = (response as? HTTPURLResponse)?.statusCode
            
            return DecodingManager.decodeArrayData(data, [Repository].self)
        } catch {
            print(#function, "Starred Repository Error")
            return nil
        }
    }
    
    func requestfilteredRepositories(by selectedTags: [Tag]) async -> [String]? {
        do {
            var filteredRepositoryList: [String] = []
            for tag in selectedTags {
                let tagInfo = try await database.collection(const.COLLECTION_USER_INFO)
                    .document(Auth.auth().currentUser?.uid ?? "")
                    .collection("Tag")
                    .document(tag.id)
                    .getDocument()
                filteredRepositoryList.append( contentsOf: Array(Set(tagInfo["repositories"] as? [String] ?? [])) )
            }
            return filteredRepositoryList
        } catch {
            print("Error")
            return nil
        }
    }
    
    @MainActor
    func filterRepository(selectedTagList: [Tag]) {
        Task {
            let filteredRepositoriesList = await self.requestfilteredRepositories(by: selectedTagList)
            let filteredRepositories = self.repositories?.filter({ repo in
                return filteredRepositoriesList!.contains(repo.fullName)
            })
            self.filteredRepositories = filteredRepositories!
        }
    }
}
