//
//  ActivityFeedView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/01/18.
//

import SwiftUI

struct ActivityFeedView: View {
    
    @ObservedObject var eventViewModel: EventViewModel
    @State private var user: GithubUser?
    @State private var repository: Repository?
    
    let event: Event

    var body: some View {
        
        HStack(spacing: 25) {
            // FIXME: - UserProfileView로 보내기 위해 GithubUser 필요
            NavigationLink {
                if let user {
                    TargetUserProfileView(user: user)
                } else {
                    // TODO: - 유저 정보를 불러오지 못했다는 텅뷰
                    Text("Cannot load user information")
                }
            } label: {
                if let url = URL(string: event.actor.avatarURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } placeholder: {
                        Image("avatarImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                } else {
                    Image("avatarImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
            }
                .foregroundColor(.primary)

            VStack {
                HStack {
                    NavigationLink {
                        if let user {
                            TargetUserProfileView(user: user)
                        } else {
                            // TODO: - 유저 정보를 불러오지 못했다는 텅뷰
                            Text("Cannot load user information")
                        }
                    } label: {
                        GSText.CustomTextView(style: .title3, string: event.actor.login)
                    }
                    
                    Spacer()
                    
                    Menu {
//                        Button(role: .none) {
//                            // action
//                        } label: {
//                            Text("Star")
//                                .foregroundColor(.red)
//                            Image(systemName: "star")
//                                .renderingMode(.original)
//                        }
                        
//                        Divider()
//
//                        Button(role: .destructive) {
//                            // action
//                        } label: {
//                            Text("Unstar")
//                            Image(systemName: "star.slash")
//                                .renderingMode(.original)
//                        }

                        // !!!: - 경고: 정말 Unfollow 하시겠습니까?
                        Button(role: .destructive) {
                            Task {
                                do {
                                    try await eventViewModel.requestToUnfollowUser(who:event.actor.login)
                                } catch(let error) {
                                    print("unfollow 실패: \(error)")
                                }
                            }
                        } label: {
                            Text("Unfollow User")
                            Image(systemName: "person.badge.minus")
                        }

                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .foregroundColor(.primary)
                }
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    NavigationLink {
                        if let repository {
                            RepositoryDetailView(service: GitHubService(), repository: repository)
                        } else {
                            // TODO: - 레포 정보를 불러오지 못했다는 텅뷰
                            Text("Cannot load repository information")
                        }
                    } label: {
                        GSText.CustomTextView(style: .body1, string: "\(event.actor.login) \(makeFeedSentence(type: event.type, repository: event.repo.name))")
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    GSText.CustomTextView(style: .caption2, string: "\(event.createdAt.stringToDate().timeAgoDisplay())")
                }
            } // vstack
        } // hstack
        .task {
            let userResult = await eventViewModel.requestUserInformation(who: event.actor.login)
            let repositoryResult = await eventViewModel.requestRepositoryInformation(repository: event.repo.name)
            
            switch userResult {
            case .success(let user):
                self.user = user
            case .failure:
                self.user = nil
            }
            
            switch repositoryResult {
            case .success(let repository):
                self.repository = repository
            case .failure:
                self.repository = nil
            }
            
        }
        .padding(.horizontal)
    } // body
    
    private func makeFeedSentence(type: String?, repository: String) -> String {
        switch type {
        case "PublicEvent":
            return "made **\(repository)** public"
        case "CreateEvent":
            return "created **\(repository)**"
        case "WatchEvent":
            return "starred **\(repository)**"
        case "ForkEvent":
            return "forked **\(repository)**"
        default:
            return ""
        }
    }
}

struct ActivityFeedView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityFeedView(eventViewModel: EventViewModel(gitHubService: GitHubService()), event: Event(id: "", type: "", actor: Actor(id: 0, login: "", displayLogin: "", gravatarID: "", url: "", avatarURL: ""), repo: Repo(id: 0, name: "", url: ""), public: true, createdAt: ""))
    }
}
