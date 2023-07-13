//
//  SendKnockTextEditSection.swift
//  GitSpace
//
//  Created by 최한호 on 2023/05/08.
//

import SwiftUI

struct SendKnockTextEditSection: View {
    
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var pushNotificationManager: PushNotificationManager
    
    @State private var knockMessage: String = ""
    
    @Binding var isKnockSent: Bool
    @Binding var chatPurpose: String
    
    @State var targetGithubUser: GithubUser?
    @State var targetUserInfo: UserInfo?
    
    var body: some View {
        
        if let currentUser = userStore.currentUser,
           let targetUserInfo {
            VStack {
                Divider()
                    .padding(.top, -8)
                
                HStack {
                    Text("✍️ \(chatPurpose)-related message...")
                        .foregroundColor(.gsLightGray1)
                        .bold()
                    
                    Spacer()
                    
                    // MARK: 메세지 작성 취소 버튼
                    /// chatPurpose가 없어지면서, 하단의 설명이 사라지게 된다.
                    Button {
                        self.endTextEditing()
                        withAnimation(.easeInOut.speed(1.5)) {
                            chatPurpose = ""
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gsLightGray1)
                    }
                }
                .padding(.horizontal)
                
                HStack(spacing: 10) {
                    GSTextEditor.CustomTextEditorView(
                        style: .message,
                        text: $knockMessage,
                        isBlocked: isBlockedEither(
                            by: userStore.currentUser ?? .getFaliedUserInfo(),
                            by: targetUserInfo
                        ),
                        sendableImage: "paperplane.fill",
                        unSendableImage: "paperplane"
                    ) {
                        Task {
                            let tempKnockMessage = knockMessage
                            knockMessage = ""
                            let newKnock = Knock(
                                date: .now,
                                knockMessage: tempKnockMessage,
                                knockStatus: Constant.KNOCK_WAITING,
                                knockCategory: chatPurpose,
                                receivedUserName: targetUserInfo.githubLogin,
                                sentUserName: currentUser.githubLogin,
                                receivedUserID: targetUserInfo.id,
                                sentUserID: currentUser.id
                            )
                            
                            // Assign New Knock On Model
                            knockViewManager.assignNewKnock(newKnock: newKnock)
                            
                            // 새로운 노크가 생성될 때의 Push Notification 전달
                            await pushNotificationManager.sendNotification(
                                with: .knock(
                                    title: "New Knock has been Arrived.",
                                    body: tempKnockMessage,
                                    pushSentFrom: currentUser.githubLogin,
                                    knockPurpose: chatPurpose,
                                    knockID: newKnock.id
                                ),
                                to: targetUserInfo
                            )
                            
                            await knockViewManager.createKnockOnFirestore(knock: newKnock)
                            
                            withAnimation(.easeInOut.speed(1.5)) { isKnockSent = true }
                        }
                    }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
            .task {
                self.targetUserInfo = await userStore.requestUserInfoWithGitHubID(githubID: targetGithubUser?.id ?? 0)
            }
        }
    }
}

// MARK: - BLOCKABLE
extension SendKnockTextEditSection: Blockable { }

//struct SendKnockTextEditSection_Previews: PreviewProvider {
//    static var previews: some View {
//        SendKnockTextEditSection(
//            knockMessage: .constant(""),
//            isKnockSent: .constant(false),
//            chatPurpose: .constant("offer")
//        )
//    }
//}
