//
//  CurrentUserProfileViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/03/09.
//

import Foundation

final class CurrentUserProfileViewModel: ObservableObject {
    
    let gitHubService: GitHubService
    
    init(service: GitHubService) {
        self.gitHubService = service
    }
    
    @MainActor
    func requestUserReadMe(user: GithubUser) async -> Result<String, GitHubAPIError> {
        let result = await gitHubService.requestRepositoryReadme(owner: user.login, repositoryName: user.login)
        
        switch result {
            
        case .success(let readme):
            guard let content = Data(base64Encoded: readme.content, options: .ignoreUnknownCharacters) else {
                return .failure(.failToLoadREADME)
            }
            
            guard let decodeContent = String(data: content, encoding: .utf8) else {
                return .failure(.failToLoadREADME)
            }
            
            let htmlResult = await gitHubService.requestMarkdownToHTML(content: decodeContent)
            
            switch htmlResult {
                
            case .success(let result):
                return .success(result)
            // markdown을 html로 변환 실패
            case .failure(let error):
                return .failure(error)
            }
            
            // repository의 markdown을 요청 실패
        case .failure(let error):
            return .failure(error)
        }
    }
    
}
