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
	
    var body: some View {
        
        VStack {
            VStack {
                Button {
                    
                } label: {
                    
                }
            } // VStack
            
            ScrollView {
                // MARK: - 상단 프로필 정보 뷰
                /*
                TopperProfileView()
                
                Divider()
                    .padding(.vertical, 20)
                    .padding(.horizontal, 5)
                */
                 
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
                            async let knockSentUser = userStore.requestUserInfoWithID(userID: knock.sentUserID)
                            
                            if let knockSentUser = await knockSentUser {
                                await pushNotificationManager.sendNotification(
                                    with: .knock(
                                        title: "Your Knock has been Accepted!",
                                        body: knock.knockMessage,
                                        knockSentFrom: knock.sentUserName,
                                        knockPurpose: "",
                                        knockID: knock.id
                                    ),
                                    to: knockSentUser
                                )
                            }
                            
                            // TODO: Update Knock Status
                            await knockViewManager.updateKnockOnFirestore(
                                knock: knock, knockStatus: Constant.KNOCK_ACCEPTED
                            )
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
                            
                        } label: {
                            Text("Block")
                                .bold()
                                .foregroundColor(.red)
                        } // Button: Block
                        
                        Divider()
                        
                        Button {
                            Task {
                                // TODO: PUSH NOTIFICATION
                                async let knockSentUser = userStore.requestUserInfoWithID(userID: knock.sentUserID)
                                
                                if let knockSentUser = await knockSentUser {
                                    await pushNotificationManager.sendNotification(
                                        with: .knock(
                                            title: "Your Knock has been Declined.",
                                            body: knock.knockMessage,
                                            knockSentFrom: knock.sentUserName,
                                            knockPurpose: "",
                                            knockID: knock.id
                                        ),
                                        to: knockSentUser
                                    )
                                }
                                
                                // TODO: Update Knock Status
                                await knockViewManager.updateKnockOnFirestore(
                                    knock: knock, knockStatus: Constant.KNOCK_DECLINED
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
                    // chat id 할당
                    pushNotificationManager.assignViewBuildID(chatStore.newChat.id)
                    
                    // tab 이동
                    tabBarRouter.currentPage = .chats
                    
                    print(#file, #function, "\(pushNotificationManager.viewBuildID ?? "NONONO")")
                } label: {
                    Text("Go chat with **\(knock.sentUserName)**")
                }
            } else if knock.knockStatus == Constant.KNOCK_DECLINED {
                Text("You Delined \(knock.sentUserName)'s knock at \(knock.declinedDate?.dateValue() ?? knock.knockedDate.dateValue())")
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 5) {
//                    AsyncImage(url: URL(string: "\("")")) { image in
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .clipShape(Circle())
//                            .frame(width: 30)
//                    } placeholder: {
//                        ProgressView()
//                    } // AsyncImage
                    
					Text("\(knock.sentUserName)")
                        .bold()
                } // HStack
                .foregroundColor(.black)
            } // ToolbarItemGroup
        } // toolbar
    }
	
    // TODO: - Push Notification, Make new Chat Implement
}
//
//struct ReceivedKnockView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ReceivedKnockView()
//        }
//    }
//}
