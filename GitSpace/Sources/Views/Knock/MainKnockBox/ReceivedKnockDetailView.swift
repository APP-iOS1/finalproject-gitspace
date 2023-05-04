//
//  ReceivedKnockView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/31.
//

import SwiftUI

struct ReceivedKnockDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var pushNotificationManager: PushNotificationManager
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var tabBarRouter: GSTabBarRouter
    
    @Binding var knock: Knock
    @State private var isAccepted: Bool = false
    @State private var targetUser: UserInfo? = nil
    @State private var isReporting: Bool = false
    @State private var isBlockOtherUser: Bool = false
    @State private var isEditingKnockMessage: Bool = false
    
    var body: some View {
        VStack {
            if
                let targetUser,
                targetUser.id == "FAILED" {
                GSText.CustomTextView(
                    style: .title3,
                    string: "The user has withdrawn."
                )
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background {
                        Color.gsRed
                    }
            }
            
            ScrollView {
                // MARK: - 상단 프로필 정보 뷰
                if
                    let targetUser,
                    targetUser.id != "FAILED" {
                    TopperProfileView(targetUserInfo: targetUser)
                    
                    Divider()
                        .padding(.vertical, 20)
                        .padding(.horizontal, 5)
                } else {
                    Text("\(knock.sentUserName)")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.primary)
                    
                    Text("The user has withdrawn.")
                        .font(.footnote)
                        .foregroundColor(.gsLightGray2)
                        .padding(.bottom, 8)
                }
                
                 
                // MARK: - Knock Message
                /// 1. 전송 시간
                /// 2. 시스템 메세지: Knock Message
                /// 3. 메세지 내용
                
                VStack(spacing: 10) {
                    /// 1. 전송 시간
                    Text("\(knock.knockedDate.dateValue().formattedDateString())")
                        .font(.footnote)
                        .foregroundColor(.gsLightGray2)
                    
                    /// 2. 시스템 메세지: Knock Message
                    HStack {
                        Text("Knock Message")
                            .font(.subheadline)
                            .foregroundColor(.gsLightGray2)
                            .bold()
                        
                        Spacer()
                        
                        KnockMessageMenu(
                            knock: $knock,
                            isReporting: $isReporting,
                            isEditingKnockMessage: $isEditingKnockMessage
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    /// 3. 메세지 내용
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(knock.knockMessage)")
                                .font(.callout)
                                .foregroundColor(Color.black)
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .padding(.vertical, 36)
                        .padding(.horizontal, 25)
                    } // VStack
                    .frame(width: UIScreen.main.bounds.width / 1.2)
                    .padding(.horizontal, 20)
                    .background {
                        RoundedRectangle(cornerRadius: 17)
                            .foregroundColor(.white)
                            .shadow(
                                color: Color(.systemGray6),
                                radius: 10,
                                x: 5,
                                y: 5
                            )
                            .padding(.horizontal, 10)
                    } // Knock Message Bubble
                }
            } // ScrollView
            
            if let targetUser,
               knock.knockStatus == Constant.KNOCK_WAITING,
               targetUser.id != "FAILED" {
                VStack(spacing: 10) {
                    
                    Divider()
                        .padding(.top, -8)
                    
                    Text("Accept knock request from \(knock.sentUserName)?")
                        .font(.subheadline)
                        .bold()
                        .padding(.bottom, 10)
                    
                    Text("If you accept, they will also be able to call you and see info such as your activity status and when you've read messages.")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .foregroundColor(.gsGray2)
                        .padding(.top, -15)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    GSButton.CustomButtonView(
                        style: .secondary(isDisabled: false)
                    ) {
                        Task {
                            // TODO: PUSH NOTIFICATION
                            async let newChat = makeNewChat(with: targetUser)
                            
                            await chatStore.addChat(await newChat)
                            
                            await knockViewManager.updateKnockOnFirestore(
                                knock: knock,
                                knockStatus: Constant.KNOCK_ACCEPTED,
                                newChatID: await newChat.id
                            )
                            
                            await self.sendPushNotification(
                                pushNotificationTitle: "Your Knock has been Accepted!",
                                to: targetUser
                            )
                            
                            tabBarRouter.currentPage = .chats
                        }
                    } label: {
                        Text("Accept")
                            .font(.body)
                            .foregroundColor(.black)
                            .bold()
                            .padding(EdgeInsets(top: 0, leading: 130, bottom: 0, trailing: 130))
                    } // button: Accept
                    
                    HStack(spacing: 60) {
                        Button {
                            Task {
                                // TODO: PUSH NOTIFICATION
                                self.targetUser = await userStore.requestUserInfoWithID(userID: knock.sentUserID)
                                
                                // TODO: Update Knock decline Message.
                                // TODO: Decline 메시지를 작성할 뷰 구현
                                await knockViewManager.updateKnockOnFirestore(
                                    knock: knock,
                                    knockStatus: Constant.KNOCK_DECLINED,
                                    declineMessage: ""
                                )
                                
                                // TODO: - decline Message를 Push에 보낼거?
                                await self.sendPushNotification(
                                    pushNotificationTitle: "Your Knock has been declined",
                                    to: targetUser
                                )
                            }
                        } label: {
                            Text("Decline")
                                .bold()
                                .foregroundColor(.primary)
                        } // Button: Decline
                    }
                    .frame(height: 30)
                    
                } // VStack
            } else if knock.knockStatus == Constant.KNOCK_ACCEPTED {
                GSButton.CustomButtonView(style: .primary(isDisabled: false)) {
                    print("TODO: Navigate To Chat")
                } label: {
                    Text("Go chat with **\(knock.sentUserName)**")
                }
            } else if knock.knockStatus == Constant.KNOCK_DECLINED {
                Text("You Declined \(knock.sentUserName)'s knock at \(knock.declinedDate?.dateValue() ?? knock.knockedDate.dateValue())")
            }
        }
        .sheet(isPresented: $isReporting) {
            ReportView(
                isReportViewShowing: $isReporting,
                isSuggestBlockViewShowing: $isBlockOtherUser
            )
        }
        .task {
            self.targetUser = await userStore.requestUserInfoWithID(userID: knock.sentUserID)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let targetUser {
                    HStack(spacing: 5) {
                        GithubProfileImage(urlStr: targetUser.avatar_url, size: 25)
                        
                        Text("\(knock.sentUserName)")
                            .bold()
                    } // HStack
                    .foregroundColor(.black)
                }
            } // ToolbarItem
        } // toolbar
        // TODO: - Connect HalfModal
    }
    
    /**
     푸쉬 알람을 보내는 메소드.
     최초 Knock가 보내지는 SendKnockView를 제외한 곳에서는 노크를 수신한 사람의 응답을 알람으로 발신한다.
     */
    private func sendPushNotification(
        pushNotificationTitle: String,
        to targetUser: UserInfo
    ) async {
        await pushNotificationManager.sendNotification(
            with: .knock(
                title: pushNotificationTitle,
                body: knock.declineMessage != nil ? knock.declineMessage : "",
                pushSentFrom: knock.receivedUserName,
                knockPurpose: "",
                knockID: knock.id
            ),
            to: targetUser
        )
    }
    
    private func makeNewChat(
        with targetUser: UserInfo
    ) async -> Chat {
        Chat(
            id: UUID().uuidString,
            createdDate: .now,
            joinedMemberIDs: [
                userStore.currentUser?.id ?? "",
                targetUser.id
            ],
            lastContent: "",
            lastContentDate: .now,
            knockContent: knock.knockMessage,
            knockContentDate: knock.knockedDate.dateValue(),
            unreadMessageCount: [
                userStore.currentUser?.id ?? "": 0,
                targetUser.id: 0
            ]
        )
    }
    
    private func makeNewChat() -> Chat {
        return Chat.init(id: UUID().uuidString,
                         createdDate: .now,
                         joinedMemberIDs: [knock.sentUserID, knock.receivedUserID],
                         lastContent: "",
                         lastContentDate: .now,
                         knockContent: knock.knockMessage,
                         knockContentDate: knock.knockedDate.dateValue(),
                         unreadMessageCount: [knock.sentUserID : 0, knock.receivedUserID : 0])
    }
}
//
//struct ReceivedKnockView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ReceivedKnockView()
//        }
//    }
//}
