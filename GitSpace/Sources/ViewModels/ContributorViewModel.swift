//
//  ContributorViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/14.
//

import Foundation

final class ContributorViewModel: ObservableObject {
    
    private let service: GitHubService
    
    init(service: GitHubService) {
        self.service = service
    }
    
    @Published var contributors: [GithubUser] = []
    var temporaryContributors: [GithubUser] = []
    
	
	/// FirebaseUserID로 GitHub Contributor 를 가져오는 메소드.
	public func getContributor(with userID: Int) -> GithubUser? {
		
		let result = contributors.filter { $0.id == userID }.first
		print(#file, #function, result?.name ?? "FAILED")
		return result
	}
    
    @MainActor
    func requestContributors(repository: Repository, page: Int) async  -> Result<Void, GitHubAPIError> {
        
        let contributorsResult = await service.requestRepositoryContributors(owner: repository.owner.login, repositoryName: repository.name, page: page)
        
        switch contributorsResult {
            
        case .success(let users):
            for user in users {
                let result = await service.requestUserInformation(userName: user.login)
                switch result {
                case .success(let user):
                    temporaryContributors.append(user)
                case .failure(let error):
                    return .failure(error)
                }
            }
            return .success(())
        case .failure(let error):
            // 컨트리뷰터 목록을 가져올 수 없다는 에러
            return .failure(error)
        }
    }
    
    
    
    
}
