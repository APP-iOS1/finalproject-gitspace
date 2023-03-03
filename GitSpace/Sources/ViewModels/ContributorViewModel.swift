//
//  ContributorViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/14.
//

import Foundation

final class ContributorViewModel: ObservableObject {
    
    @Published var contributors: [GithubUser] = []
	
	/// FirebaseUserID로 GitHub Contributor 를 가져오는 메소드.
	public func getContributor(with userID: Int) -> GithubUser? {
		
		let result = contributors.filter { $0.id == userID }.first
		print(#file, #function, result?.name ?? "FAILED")
		return result
	}
}
