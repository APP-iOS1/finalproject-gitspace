//
//  RepositoryDetailViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/03/08.
//

import Foundation

final class RepositoryDetailViewModel: ObservableObject {
    
    private let service: GitHubService
    
    init(service: GitHubService) {
        self.service = service
    }
    
    @MainActor
    func requestReadMe(repository: Repository) async -> String {
        let readMeResult = await service.requestRepositoryReadme(owner: repository.owner.login, repositoryName: repository.name)
        
        switch readMeResult {
            
        case .success(let response):
            guard let content = Data(base64Encoded: response.content, options: .ignoreUnknownCharacters) else {
                return GitHubAPIError.failToLoadREADME.errorDescription
            }
            
            guard let decodeContent = String(data: content, encoding: .utf8) else {
                return GitHubAPIError.failToLoadREADME.errorDescription
            }
            
            let htmlResult = await service.requestMarkdownToHTML(content: decodeContent)
            
            switch htmlResult {
            case .success(let result):
                return result
            case .failure(let error):
                return error.errorDescription
            }
            
        case .failure(let error):
            return error.errorDescription
        }
    }
    
    
}
