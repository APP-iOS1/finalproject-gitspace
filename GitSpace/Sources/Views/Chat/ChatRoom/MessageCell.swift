//
//  MessageCell.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

// MARK: -View : 채팅 메세지 셀
struct MessageCell : View {
    
    let message: Message
    let targetUserInfo: UserInfo
    var isMine: Bool {
        Utility.loginUserID == message.senderID
    }
    @EnvironmentObject var messageStore: MessageStore
    @EnvironmentObject var githubAuthManager: GitHubAuthManager
    
    var body: some View {
        
        switch isMine {
        case true:
            HStack (
                alignment: .bottom,
                spacing: 2
            ) {
                Spacer()
                Text(message.sentDateAsString)
                    .modifier(
                        MessageTimeModifier()
                    )
                Text(message.textContent)
                    .modifier(
                        MessageModifier(isMine: self.isMine)
                    )
                    .contextMenu {
                        Button {
                            messageStore.deletedMessage = message
                        } label: {
                            Text("Delete")
                        }
                    }
            }
            //.padding(.trailing, 10)
            
        case false:
            HStack {
                // Profile Image 부분
                VStack {
                    NavigationLink {
                        TargetUserProfileView(user: GithubUser(id: targetUserInfo.githubID, login: targetUserInfo.githubLogin, name: targetUserInfo.githubName, email: targetUserInfo.githubEmail, avatar_url: targetUserInfo.avatar_url, bio: targetUserInfo.bio, company: targetUserInfo.company, location: targetUserInfo.location, blog: targetUserInfo.blog, public_repos: targetUserInfo.public_repos, followers: targetUserInfo.followers, following: targetUserInfo.following))
                    } label: {
                        GithubProfileImage(urlStr: targetUserInfo.avatar_url, size: 35)
                    }
                    Spacer()
                }
                
                // UserName과 Message Bubble 부분
                VStack (
                    alignment: .leading,
                    spacing: 6
                ) {
                    GSText.CustomTextView(
                        style: .caption1,
                        string: targetUserInfo.githubLogin
                    )
                    HStack (
                        alignment: .bottom,
                        spacing: 2
                    ) {
                        Text(message.textContent)
                            .modifier(
                                MessageModifier(isMine: isMine)
                            )
                        Text(message.sentDateAsString)
                            .modifier(
                                MessageTimeModifier()
                            )
                        Spacer()
                    }
                }
            }
        }
    }
    private func getGithubProfileImageURL(targetUserName: String) async -> String {
        let githubService = GitHubService()
        let githubUserResult = await githubService.requestUserInformation(userName: targetUserName)
        switch githubUserResult {
        case .success(let githubUser):
            return githubUser.avatar_url
        case .failure(let error):
            print(error)
        }
        return ""
    }
}


// MARK: - 메세지 셀 말풍선 Custom Shape
struct ChatBubbleShape: Shape {
    
    enum Direction {
        case left
        case right
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        return (direction == .left)
        ? getLeftBubblePath(in: rect)
        : getRightBubblePath(in: rect)
    }
    
    func getLeftBubblePath(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomRight, .bottomLeft, .topRight],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        return Path(path.cgPath)
    }
    
    func getRightBubblePath(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomRight, .bottomLeft, .topLeft],
            cornerRadii: CGSize(width: 20, height: 20)
        )
        return Path(path.cgPath)
    }
}

