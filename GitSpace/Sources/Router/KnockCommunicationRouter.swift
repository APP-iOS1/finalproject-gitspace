//
//  KnockCommunicationRouter.swift
//  GitSpace
//
//  Created by Celan on 2023/03/16.
//

import SwiftUI

struct KnockCommunicationRouter: View {
    @EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var chatViewManager: ChatStore
    @State private var isFetchDone: Bool = false
    @State private var isKnockSendable: Bool = false
    
    @State private var knockStateFilter: KnockStateFilter? = nil
    @State private var knock: Knock? = nil
    @State private var chat: Chat? = nil
    
    let targetGithubUser: GithubUser
    
    var body: some View {
        VStack {
            
        }
        .task {
            if let targetUser = await userStore.requestUserInfoWithGitHubID(githubID: targetGithubUser.id){
                let result = await knockViewManager.checkIfKnockHasBeenSent(
                    currentUser: userStore.currentUser ?? .getFaliedUserInfo(),
                    targetUser: targetUser
                )
                
                switch result {
                case let .knockHasBeenSent(knockStatus, withKnock, toChatID):
                    switch knockStatus {
                    case .accepted:
                        self.chat = await chatViewManager.requestPushedChat(chatID: toChatID ?? "")
                        fallthrough
                    case .declined:
                        fallthrough
                    case .waiting:
                        fallthrough
                    default:
                        if let withKnock {
                            self.knock = withKnock
                        }
                    }
                case let .ableToSentNewKnock(KnockFlag):
                    // true일 때만 할당하도록 하여 불필요한 뷰 렌더링 최소화
                    if KnockFlag {
                        self.isKnockSendable = KnockFlag
                    }
                }
            }
        }
    }
}
