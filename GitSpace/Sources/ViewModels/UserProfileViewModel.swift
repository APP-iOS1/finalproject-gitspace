//
//  UserProfileViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/03/09.
//

import Foundation

final class UserProfileViewModel: ObservableObject {
    
    private let service: GitHubService
    
    init(service: GitHubService) {
        self.service = service
    }
    
    @MainActor
    func requestUserReadMe(user: GithubUser) async -> Result<String, GitHubAPIError> {
        let result = await service.requestRepositoryReadme(owner: user.login, repositoryName: user.login)
        
        switch result {
            
        case .success(let readme):
            guard let content = Data(base64Encoded: readme.content, options: .ignoreUnknownCharacters) else {
                return .failure(.failToDecoding)
            }
            
            guard let decodeContent = String(data: content, encoding: .utf8) else {
                return .failure(.failToDecoding)
            }
            
            let htmlResult = await service.requestMarkdownToHTML(content: decodeContent)
            
            switch htmlResult {
                
            case .success(let result):
                return .success(result)
            // markdown을 html로 변환 실패
            case .failure:
                return .failure(.failToDecoding)
            }
            
            // repository의 markdown을 요청 실패
        case .failure:
            return .failure(.failToLoadREADME)
        }
    }
    
}
