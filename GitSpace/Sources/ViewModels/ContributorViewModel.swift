//
//  ContributorViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/14.
//

import Foundation

final class ContributorViewModel: ObservableObject {
    
    @Published var contributors: [GitHubUser] = []
}
