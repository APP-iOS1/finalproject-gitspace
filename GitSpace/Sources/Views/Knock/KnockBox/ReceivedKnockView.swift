//
//  ReceivedKnockView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/31.
//

import SwiftUI

struct ReceivedKnockView: View {
    
    @Environment(\.dismiss) private var dismiss
	@EnvironmentObject var knockViewManager: KnockViewManager
	@EnvironmentObject var pushNotificationManager: PushNotificationManager
	@EnvironmentObject var userStore: UserStore
	@EnvironmentObject var chatStore: ChatStore
	@EnvironmentObject var tabBarRouter: GSTabBarRouter
	
	@State var knock: Knock
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
//                TopperProfileView()
                
                Divider()
                    .padding(.vertical, 20)
                    .padding(.horizontal, 5)
                
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
            
			if !isAccepted {
				VStack(spacing: 10) {
					
					Divider()
						.padding(.top, -8)
					
					Text("Accept message request from \(knock.sentUserName)?")
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
					
					GSButton.CustomButtonView(style: .secondary(
						isDisabled: false)) {
							Task {
								await pushKnockNotification(knock: knock)
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
							
						} label: {
							Text("Decline")
								.bold()
								.foregroundColor(.primary)
						} // Button: Decline
					}
					.frame(height: 30)
					
				} // VStack
			} else if isAccepted {
				GSButton.CustomButtonView(style: .primary(isDisabled: false)) {
					// chat id 할당
					pushNotificationManager.assignViewBuildID(chatStore.newChat.id)
					
					// tab 이동
					tabBarRouter.currentPage = .chats
					
					print(#file, #function, "\(pushNotificationManager.viewBuildID ?? "NONONO")")
				} label: {       
					Text("Go chat with **\(knock.sentUserName)**")
				}
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
	
	private func pushKnockNotification(knock: Knock) async -> Void {
		@Sendable
		func getSentToUser() async -> UserInfo {
			await userStore.requestUserInfoWithID(
				userID: knock.sentUserID
			) ?? .getFaliedUserInfo()
		}
		
		async let sentUser = getSentToUser()
		await makeNewChat()
		
		print(await sentUser, chatStore.newChat.id)
		
		await pushNotificationManager.sendNotification(
			with: .chat(
				title: "Your Knock has been accepted!",
				body: "",
				nameOfChatter: knock.receivedUserName,
				chatID: chatStore.newChat.id
			), to: await sentUser
		)
		
		isAccepted.toggle()
	}
	
	private func makeNewChat() async -> Void {
		chatStore.newChat = .init(
			id: UUID().uuidString,
			createdDate: Date.now,
			joinedMemberIDs: [knock.receivedUserID, knock.sentUserID],
			lastContent: "",
			lastContentDate: Date.now,
			knockContent: knock.knockMessage,
			knockContentDate: Date.now,
			unreadMessageCount: [
				knock.receivedUserID : 0,
				knock.sentUserID : 0
			]
		)
		
		chatStore.addChat(chatStore.newChat)
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
