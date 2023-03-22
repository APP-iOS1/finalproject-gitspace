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
	
    var body: some View {
        
        VStack {
            VStack {
                Button {
                    
                } label: {
                    
                }
            } // VStack
            
            ScrollView {
                // MARK: - 상단 프로필 정보 뷰
                if let targetUser {
                    TopperProfileView(targetUserInfo: targetUser)
                    
                    Divider()
                        .padding(.vertical, 20)
                        .padding(.horizontal, 5)
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
                            .foregroundColor(.gsLightGray1)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.leading, 15)
                    
                    /// 3. 메세지 내용
					Text("\(knock.knockMessage)")
                        .font(.system(size: 15, weight: .regular))
                        .padding(.horizontal, 30)
                        .padding(.vertical, 30)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .fill(.white)
                                .shadow(color: Color(.systemGray5), radius: 8, x: 0, y: 2)
                            
                        )
                        .padding(.horizontal, 15)
                }
            } // ScrollView
            
            if knock.knockStatus == Constant.KNOCK_WAITING {
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
                        .padding(.bottom)
                        .padding(.horizontal)
                    
                    GSButton.CustomButtonView(
                        style: .secondary(isDisabled: false)
                    ) {
                        Task {
                            // TODO: PUSH NOTIFICATION
                            self.targetUser = await userStore.requestUserInfoWithID(userID: knock.sentUserID)
                            if let targetUser {
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
                        }
                    } label: {
                        Text("Accept")
                            .font(.body)
                            .foregroundColor(.primary)
                            .bold()
                            .padding(EdgeInsets(top: 0, leading: 130, bottom: 0, trailing: 130))
                    } // button: Accept
                    
                    HStack(spacing: 60) {
                        Button {
                            // TODO: - 언젠가 블록도 해야지? 지금 못할 거면 빼던가.
                        } label: {
                            Text("Block")
                                .bold()
                                .foregroundColor(.red)
                        } // Button: Block
                        
                        Divider()
                        
                        Button {
                            Task {
                                // TODO: PUSH NOTIFICATION
                                self.targetUser = await userStore.requestUserInfoWithID(userID: knock.sentUserID)
                                if let targetUser {
                                    
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
