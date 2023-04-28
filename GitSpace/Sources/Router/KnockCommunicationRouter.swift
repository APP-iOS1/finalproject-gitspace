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
    @State private var isFetchDone: Bool = false // 왜 필요함?
    @State private var isKnockSendable: Bool = false
    
    @State private var knockStateFilter: KnockStateFilter? = nil
    @State private var chat: Chat? = nil
    @State private var targetUserInfo: UserInfo? = nil
    @State private var knock: Knock = .init(isFailedDummy: true)
    
    let targetGithubUser: GithubUser
    
    var body: some View {
        VStack {
            if isFetchDone {
                if isKnockSendable {
                    // MARK: - Success
                    SendKnockView(sendKnockToGitHubUser: targetGithubUser)
                } else if let knockStateFilter {
                    switch knockStateFilter {
                    case .waiting: // !!!: If CurrentUser Received, go to ReceivedKnockDetailView
                        if knock.receivedUserID == userStore.currentUser?.id ?? "" {
                            // MARK: - Success
                            ReceivedKnockDetailView(knock: $knock)
                        } else if knock.sentUserID == userStore.currentUser?.id ?? "" {
                            // MARK: - Success
                            KnockHistoryView(
                                eachKnock: $knock,
                                userSelectedTab: .constant(Constant.KNOCK_SENT)
                            )
                        }
                    case .accepted: // !!!: Chat Exists
                        // MARK: - Success
                        if let chat,
                           let targetUserInfo {
                            ChatRoomView(chat: chat, targetUserInfo: targetUserInfo)
                        }
                    case .declined: // !!!: -> KnockHistoryView
                        // MARK: - Success
                        KnockHistoryView(
                            eachKnock: $knock,
                            userSelectedTab: .constant(Constant.KNOCK_RECEIVED)
                        )
                    default:
                        if isKnockSendable {
                            SendKnockView()
                        } else {
                            Text("Default")
                        }
                    }
                }
            } else {
                // MARK: - Success
                LoadingProgressView()
            }
        }
        .task {
            if let targetUserInfo = await userStore.requestUserInfoWithGitHubID(githubID: targetGithubUser.id) {
                self.targetUserInfo = targetUserInfo
                let result = await knockViewManager.checkIfKnockHasBeenSent(
                    currentUser: userStore.currentUser ?? .getFaliedUserInfo(),
                    targetUser: targetUserInfo
                )
                
                switch result {
                case let .knockHasBeenSent(knockStatus, withKnock, toChatID):
                    if let withKnock {
                        self.knock = withKnock
                        self.knockStateFilter = knockStatus
                        
                        if knockStatus == .accepted,
                           let toChatID {
                            self.chat = await chatViewManager.requestPushedChat(chatID: toChatID)
                        }
                    }
                case let .ableToSentNewKnock(KnockFlag):
                    // true일 때만 할당하도록 하여 불필요한 뷰 렌더링 최소화
                    if KnockFlag {
                        self.isKnockSendable = KnockFlag
                    }
                }
                self.isFetchDone.toggle()
            }
        }
    }
}
