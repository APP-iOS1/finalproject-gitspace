//
//  EventViewModel.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/15.
//

import Foundation

final class EventViewModel: ObservableObject {

    let gitHubService: GitHubService

    init(gitHubService: GitHubService) {
        self.gitHubService = gitHubService
    }

    @Published var events: [Event] = []
    @Published var eventRepositories: [Repository] = []

    @MainActor
    func requestUserInformation(who name: String) async -> Result<GithubUser, GitHubAPIError> {
        let result = await gitHubService.requestUserInformation(userName: name)
        
        switch result {
        case .success(let user):
            return .success(user)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    @MainActor
    func requestRepositoryInformation(repository name: String) async -> Result<Repository, GitHubAPIError> {
        let splitted = name.split(separator: "/")
        let result = await gitHubService.requestRepositoryInformation(owner: String(splitted[0]), repositoryName: String(splitted[1]))
        switch result {
        case .success(let repository):
            return .success(repository)
        case .failure(let error):
            return .failure(error)
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

    @MainActor
    func requestAuthenticatedUserReceivedEvents(who name: String) async throws {
        let activitiesResult = await gitHubService.requestAuthenticatedUserReceivedEvents(userName: name, page: 1)
        self.events.removeAll()
        switch activitiesResult {
        case .success(let events):
            self.events = events.filter { $0.type == "PublicEvent" || $0.type == "WatchEvent" || $0.type == "ForkEvent" || $0.type == "CreateEvent" }
        case .failure(let error):
            print("이벤트 불러오기 실패: \(error)")
            throw error
        }

        await self.fetchEventRepositories()
    }

    @MainActor
    func fetchEventRepositories() async {

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
