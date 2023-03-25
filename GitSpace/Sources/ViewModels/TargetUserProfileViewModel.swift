//
//  TargetUserProfileViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/03/15.
//

import Foundation

final class TargetUserProfileViewModel: ObservableObject {
    
    let gitHubService: GitHubService
    
    init(gitHubService: GitHubService) {
        self.gitHubService = gitHubService
    }
    
    @Published var isFollowingUser: Bool = false
    
    @MainActor
    func requestUserReadme(user: String) async -> Result<String, GitHubAPIError> {
        let result = await gitHubService.requestRepositoryReadme(owner: user, repositoryName: user)
        
        switch result {
        case .success(let readme):
            guard let content = Data(base64Encoded: readme.content, options: .ignoreUnknownCharacters) else {
                // TODO: - error case 수정
                return .failure(.failToLoadREADME)
            }
            
            guard let decodeContent = String(data: content, encoding: .utf8) else {
                // TODO: - error case 수정
                return .failure(.failToLoadREADME)
            }
            
            let htmlResult = await gitHubService.requestMarkdownToHTML(content: decodeContent)
            
            switch htmlResult {
            case .success(let result):
                return .success(result)
            // markdown을 html로 변환 실패
            case .failure(let error):
                // TODO: - error case 수정
                return .failure(error)
            }
            
            // repository의 readme markdown을 요청 실패
        case .failure(let error):
            // TODO: - error case 수정
            return .failure(error)
        }
    }
    
    @MainActor
    func checkAuthenticatedUserIsFollowing(who user: String) async -> Bool {
        do {
            try await gitHubService.requestAuthenticatedUserFollowsPerson(userName: user)
            return true
        } catch {
            return false
        }
    }
    
    @MainActor
    func requestToFollowUser(who name: String) async throws {
        
        do {
            try await gitHubService.requestToFollowUser(userName: name)
        } catch(let error) {
            print(error)
        }
        
        
    }
    
    @MainActor
    func requestToUnfollowUser(who name: String) async throws {
        do {
            try await gitHubService.requestToUnfollowUser(userName: name)
        } catch(let error) {
            print(error)
        }
        
    }
    
    
}
