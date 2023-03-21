//
//  EventViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/15.
//

import Foundation

final class EventViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    @Published var eventRepositories: [Repository] = []
    
    
    @MainActor
    public func fetchEventRepositories() async {
        
        eventRepositories.removeAll()
        
        for event in events {
            
            let splitted = event.repo.name.split(separator: "/")
            let name = String(splitted[0])
            let repositoryName = String(splitted[1])
            
            let result = await GitHubService().requestRepositoryInformation(owner: name, repositoryName: repositoryName)
            
            switch result {
            case .success(let repository):
                eventRepositories.append(repository)
            // 레포지토리의 정보를 불러올 수 없는 경우 해당 이벤트는 건너뛴다.
            case .failure:
                continue
            }
        }
    }

}
