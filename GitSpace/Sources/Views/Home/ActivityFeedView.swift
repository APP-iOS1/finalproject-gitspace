//
//  ActivityFeedView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/01/18.
//

import SwiftUI

struct ActivityFeedView: View {

    let gitHubService: GitHubService
    let event: Event
    
    init(service: GitHubService, event: Event) {
        self.gitHubService = service
        self.event = event
    }

    var body: some View {

        // CreateEvent, ForkEvent, WatchEvent(star), PublicEvent 만을 보여줌
        
        HStack(spacing: 25) {
            // FIXME: - UserProfileView로 보내기 위해 GitHubUser 필요
            NavigationLink {
//                UserProfileView(service: git, user: <#T##GitHubUser#>)
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

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    NavigationLink {
//                        UserProfileView(service: <#T##GitHubService#>, user: <#T##GitHubUser#>)
//                        ProfileDetailView()
                    } label: {
                        GSText.CustomTextView(style: .title3, string: event.actor.login)
                    }

                    NavigationLink {
//                        RepositoryDetailView(service: gitHubService, repository: <#Repository#>)
                    } label: {
                        GSText.CustomTextView(style: .body1, string: "\(event.actor.login) \(makeFeedSentence(type: event.type, repository: event.repo.name))")
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                VStack {
                    // FIXME: - 이벤트 종류에 따른 메뉴 분기처리하기
                    Menu {
                        
                        // FIXME: - GSButton으로 수정필요, role을 연관값으로 가진 style이 아직 없어서 중단
                        Button(role: .none) {
                            // action
                        } label: {
                            Text("Chat")
                            Image(systemName: "bubble.left")
                                .renderingMode(.original)
                        }

                        Button(role: .none) {
                            // action
                        } label: {
                            Text("Star")
                                .foregroundColor(.red)
                            Image(systemName: "star")
                                .renderingMode(.original)
                        }
                        
                        Divider()

                        Button(role: .destructive) {
                            // action
                        } label: {
                            Text("Unstar")
                            Image(systemName: "star.slash")
                                .renderingMode(.original)
                        }

                        Button(role: .destructive) {

                        } label: {
                            Text("Unfollow User")
                            Image(systemName: "person.badge.minus")
                        }

                    } label: {
                        Image(systemName: "ellipsis")
                    }
                        .foregroundColor(.primary)

                    Spacer()
                    
                    GSText.CustomTextView(style: .caption2, string: "\(event.createdAt.stringToDate().timeAgoDisplay())")

                }
            } // vstack
        } // hstack
        .padding(.horizontal)
    } // body
    
    func makeFeedSentence(type: String?, repository: String) -> String {
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
        ActivityFeedView(service: GitHubService(), event: Event(id: "", type: "", actor: Actor(id: 0, login: "", displayLogin: "", gravatarID: "", url: "", avatarURL: ""), repo: Repo(id: 0, name: "", url: ""), public: true, createdAt: ""))
    }
}
