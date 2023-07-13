//
//  KnockHistoryView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/31.
//

import SwiftUI

struct KnockHistoryView: View {
    @Binding var eachKnock: Knock
    @Binding var userSelectedTab: String
    @EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var tabBarRouter: GSTabBarRouter
    @EnvironmentObject var userInfoManager: UserStore
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var blockedUsers: BlockedUsers
    
    @State private var targetUserInfo: UserInfo? = nil
    @State private var isReporting: Bool = false
    @State private var isSuggestBlocking: Bool = false
    @State private var isBlocking: Bool = false
    @State private var isBlockedUser: Bool = false
    
    @State private var editedKnockMessage: String = ""
    @State private var isEditingKnockMessage: Bool = false
    @State private var isUpdatingKnockMessage: Bool = false
    @State private var activatedChat: Chat?
    @FocusState private var isTextEditorFocused: Bool
    
    // MARK: - body
    var body: some View {
        ScrollView(showsIndicators: false) {
            if !isEditingKnockMessage {
                if let targetUserInfo {
                    TopperProfileView(targetUserInfo: targetUserInfo)
                }
                
                Text(
                    userSelectedTab == Constant.KNOCK_RECEIVED
                    ? "\(eachKnock.sentUserName) has sent \nnew Knock Message!"
                    : "Your Knock Message is \nsent to \(eachKnock.receivedUserName)"
                )
                .multilineTextAlignment(.center)
                .font(.footnote)
                .padding(.bottom, 4)
                
                Text(eachKnock.knockedDate.dateValue().formattedDateString())
                    .foregroundColor(.gsLightGray2)
                    .font(.footnote)
            }
            
            HStack {
                Text("Knock Message")
                    .foregroundColor(.gsLightGray2)
                    .font(.footnote)
                
                Spacer()
                
                if eachKnock.knockStatus == Constant.KNOCK_WAITING,
                   !isEditingKnockMessage {
                    KnockMessageMenu(
                        knock: $eachKnock,
                        isReporting: $isReporting,
                        isEditingKnockMessage: $isEditingKnockMessage
                    )
                }
            }
            .padding([.top, .horizontal], 20)
            .padding(.bottom, 10)
            
            if isEditingKnockMessage {
                VStack {
                    TextEditor(text: $editedKnockMessage)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .textEditorBackgroundClear()
                        .frame(
                            maxWidth: UIScreen.main.bounds.width / 1.2,
                            minHeight: 100
                        )
                        .padding(20)
                        .focused($isTextEditorFocused)
                        .task {
                            isTextEditorFocused.toggle()
                        }
                    
                    HStack {
                        GSButton.CustomButtonView(
                            style: .secondary(isDisabled: false)
                        ) {
                            withAnimation {
                                endTextEditing()
                                isEditingKnockMessage.toggle()
                                editedKnockMessage = eachKnock.knockMessage.decodedBase64String ?? "복호화"
                            }
                        } label: {
                            Text("Cancel")
                        }
                        
                        GSButton.CustomButtonView(
                            style: .secondary(isDisabled: isUpdatingKnockMessage)
                        ) {
                            isUpdatingKnockMessage.toggle()
                            
                            Task {
                                eachKnock.knockMessage = editedKnockMessage
                                await knockViewManager.updateKnockOnFirestore(
                                    knock: eachKnock,
                                    knockStatus: eachKnock.knockStatus,
                                    isKnockMessageEdited: isEditingKnockMessage
                                )
                                
                                withAnimation {
                                    endTextEditing()
                                    isUpdatingKnockMessage.toggle()
                                    isEditingKnockMessage.toggle()
                                }
                            }
                        } label: {
                            Text("Update")
                        }
                        .disabled(isUpdatingKnockMessage)
                    }
                    .frame(
                        maxWidth: UIScreen.main.bounds.width / 1.2,
                        alignment: .trailing
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
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
                
            } else {
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(eachKnock.knockMessage.decodedBase64String ?? "복호화")")
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

            if eachKnock.knockStatus == Constant.KNOCK_ACCEPTED {
                if
                    let activatedChat,
                    let targetUserInfo {
                    GSNavigationLink(
                        style: .secondary()
                    ) {
                        ChatRoomView(
                            chat: activatedChat,
                            targetUserInfo: targetUserInfo
                        )
                    } label: {
                        Text("Go Chat")
                            .bold()
                    }
                    .padding(.top, 8)
                }
            }
            
            Divider()
                .padding(.top, 8)
                .padding(.bottom, 30)
            
            HStack {
                Text("Knocking Status")
                    .foregroundColor(.gsLightGray2)
                    .font(.footnote)
                
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.bottom, 16)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 32) {
                    Circle()
                        .frame(maxWidth: 16, maxHeight: 16)
                        .foregroundColor(.green)
                        .offset(y: 3)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(
                            userSelectedTab == Constant.KNOCK_RECEIVED
                            ? "**\(eachKnock.sentUserName)** has sent \n Knock Message."
                            : "Knock Message sent to **\(eachKnock.receivedUserName)**."
                        )
                        
                        Text(eachKnock.knockedDate.dateValue().formattedDateString())
                            .foregroundColor(.gsLightGray2)
                            .font(.footnote)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 16)
                
                switch eachKnock.knockStatus {
                case Constant.KNOCK_WAITING:
                    HStack(alignment: .top, spacing: 32) {
                        Circle()
                            .frame(maxWidth: 16, maxHeight: 16)
                            .foregroundColor(.orange)
                            .offset(y: 3)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Knock Message is Pending.")
                            
                            Text(eachKnock.knockedDate.dateValue().formattedDateString())
                                .foregroundColor(.gsLightGray2)
                                .font(.footnote)
                        }
                    }
                    .padding(.bottom, 16)
                default:
                    EmptyView()
                }
                Spacer()
                
                switch eachKnock.knockStatus {
                case Constant.KNOCK_WAITING:
                    EmptyView()
                case Constant.KNOCK_ACCEPTED:
                    HStack(alignment: .top, spacing: 32) {
                        Circle()
                            .frame(maxWidth: 16, maxHeight: 16)
                            .foregroundColor(.green)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(
                                userSelectedTab == Constant.KNOCK_RECEIVED
                                ? "You has Accepted **\(eachKnock.sentUserName)**'s Knock Message."
                                : "**\(eachKnock.receivedUserName)** has Accepted your Knock Message."
                            )
                            .multilineTextAlignment(.leading)
                            
                            Text(eachKnock.acceptedDate?.dateValue().formattedDateString() ?? "")
                                .foregroundColor(.gsLightGray2)
                                .font(.footnote)
                        }
                    }
                case Constant.KNOCK_DECLINED:
                    HStack(alignment: .top, spacing: 32) {
                        Circle()
                            .frame(maxWidth: 16, maxHeight: 16)
                            .foregroundColor(.red)
                            .offset(y: 3)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(
                                userSelectedTab == Constant.KNOCK_RECEIVED
                                ? "You has Declined **\(eachKnock.sentUserName)**'s Knock Message."
                                : "**\(eachKnock.receivedUserName)** has Declined your Knock Message."
                            )
                            .multilineTextAlignment(.leading)
                            
                            Text(eachKnock.declinedDate?.dateValue().formattedDateString() ?? "")
                                .foregroundColor(.gsLightGray2)
                                .font(.footnote)
                            
                            Divider()
                                .padding(.vertical, 8)
                                .padding(.trailing, 20)
                            
                            Text("**Declined Reason :**")
                            
                            Text("\(eachKnock.declineMessage ?? "")")
                        }
                    }
                    .padding(.bottom, 16)
                default:
                    EmptyView()
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .reportBlockProcessSheet(
            reportViewIsPresented: $isReporting,
            reportType: .knock,
            suggestViewIsPresented: $isSuggestBlocking,
            blockViewIsPresented: $isBlocking,
            isBlockedUser: $isBlockedUser,
            targetUserInfo: targetUserInfo ?? .getFaliedUserInfo()
        )
        .onTapGesture {
            self.endTextEditing()
        }
        .task {
            if eachKnock.knockStatus == Constant.KNOCK_WAITING {
                assignKnockMessageIntoEditState()
            } else if eachKnock.knockStatus == Constant.KNOCK_ACCEPTED {
                await assignChatWithChatID()
            }
            
            // 노크 수신자 == 현재 유저일 경우, 노크 발신자의 정보를 타겟유저로 할당
            if eachKnock.receivedUserID == userInfoManager.currentUser?.id {
                self.targetUserInfo = await userInfoManager.requestUserInfoWithID(userID: eachKnock.sentUserID)
            } else if eachKnock.receivedUserID != userInfoManager.currentUser?.id {
                self.targetUserInfo = await userInfoManager.requestUserInfoWithID(userID: eachKnock.receivedUserID)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text(
                        userSelectedTab == Constant.KNOCK_RECEIVED
                        ? "**\(eachKnock.sentUserName)**"
                        : "**\(eachKnock.receivedUserName)**"
                    )
                }
            }
        }
    }
    
    private func assignKnockMessageIntoEditState() {
        editedKnockMessage = eachKnock.knockMessage.decodedBase64String ?? "복호화"
    }
    
    private func assignChatWithChatID() async {
        if
            let chatID = eachKnock.chatID {
            self.activatedChat = await chatStore.requestPushedChat(chatID: chatID)
        }
    }
}
