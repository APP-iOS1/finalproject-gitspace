//
//  EventViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/15.
//

import Foundation

final class EventViewModel: ObservableObject {
    
    @Published var events: [Event] = []
    @Published var eventActors: [GitHubUser] = []
    @Published var eventRepositories: [Repository] = []
    
    @MainActor
    public func fetchEventActors() async {
        
        eventActors.removeAll()
        
        for event in events {
            let result = await GitHubService().requestUserInformation(userName: event.actor.login)
            
            switch result {
            case .success(let actor):
                eventActors.append(actor)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @MainActor
    public func fetchEventRepositories() async {
        
        eventRepositories.removeAll()
        
        for event in events {
            
            let name = String(event.repo.name.split(separator: "/")[0])
            let repositoryName = String(event.repo.name.split(separator: "/")[1])
            
            let result = await GitHubService().requestRepositoryInformation(owner: name, repositoryName: repositoryName)
            
            switch result {
            case .success(let repository):
                eventRepositories.append(repository)
            case .failure(let error):
                print(error)
            }
        }
    }

}
