//
//  SendKnock.swift
//  GitSpace
//
//  Created by 최한호 on 2023/05/08.
//

import SwiftUI

struct SendKnock: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var pushNotificationManager: PushNotificationManager
    
    @Namespace var topID
    @Namespace var bottomID
    
    @StateObject private var keyboardHandler = KeyboardHandler()
    @State private var chatPurpose: String = ""
    @State var showKnockGuide: Bool = false
    
    @State private var knockMessage: String = ""
    @State private var newKnock: Knock? = nil
    @State private var isKnockSent: Bool = false
    @State private var opacity: CGFloat = 0.4
    
    /**
     Knock를 받을 상대방의 정보는 GithubUser 타입으로 전달됩니다.
     전달받은 아규먼트의 정보를 토대로 상대방의 UserInfo를 DB에서 색인합니다.
     */
    @State var targetGithubUser: GithubUser?
    @State var targetUserInfo: UserInfo? = nil
    
    var body: some View {
        VStack {
            if let targetUserInfo {
                ScrollViewReader { proxy in
                    ScrollView {
                        HStack {}.id(topID)
                        
                        VStack(alignment: .center, spacing: 10) {
                            
                            TopperProfileView(
                                targetUserInfo: targetUserInfo
                            )
                            
                            Divider()
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                            
                            BeforeSendKnockSection(
                                targetGithubUser: targetGithubUser,
                                showKnockGuide: $showKnockGuide
                            )
                            
                            // MARK: - 채팅 목적 버튼
                            HStack(spacing: 30) {
                                GSButton.CustomButtonView(style: .secondary(
                                    isDisabled: false)) {
                                        withAnimation(.easeInOut.speed(1.5)) {
                                            chatPurpose = "Offer"
                                            proxy.scrollTo(bottomID)
                                        }
                                    } label: {
                                        Text("🚀 Offer")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                            .bold()
                                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                                    }
                                
                                GSButton.CustomButtonView(style: .secondary(
                                    isDisabled: false)) {
                                        withAnimation(.easeInOut.speed(1.5)) {
                                            chatPurpose = "Question"
                                            proxy.scrollTo(bottomID)
                                        }
                                    } label: {
                                        Text("💡 Question")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                            .bold()
                                        
                                    }
                            }
                            
                            if !isKnockSent {
                                if !chatPurpose.isEmpty {
                                    
                                    EditingKnockSection(targetGithubUser: targetGithubUser)
                                        .padding(.top, 80)
                                }
                            } else {
                                AfterSendKnockSection()
                            }
                        }
                        
                        HStack {
                        }
                        .id(bottomID)
                        .frame(height: isKnockSent ? 5 : 280)
                    }
                    .onChange(of: chatPurpose) { _ in
                        withAnimation(.easeInOut.speed(1.5)) { proxy.scrollTo(bottomID) }
                    }
                    .onTapGesture {
                        self.endTextEditing()
                    }
                    .animation(.default, value: keyboardHandler.keyboardHeight)
                }
            }
            
            VStack {
                
                if isKnockSent == false,
                   !chatPurpose.isEmpty {
                    
                    HStack(spacing: 10) {
                        
                        SendKnockTextEditSection(
                            isKnockSent: $isKnockSent,
                            chatPurpose: $chatPurpose,
                            targetGithubUser: targetGithubUser,
                            targetUserInfo: targetUserInfo
                        )
                        
                        // FIXME: 노크 전송 버튼 disabled 조건에 isKnockSent 추가 필요함! From. 영이 -> To. 노이
//                        if
//                            let currentUser = userStore.currentUser,
//                            let targetUserInfo,
//                            !isKnockSent {
//                            GSTextEditor.CustomTextEditorView(
//                                style: .message,
//                                text: $knockMessage,
//                                isBlocked: false,
//                                sendableImage: "paperplane.fill",
//                                unSendableImage: "paperplane"
//                            ) {
//                                Task {
//                                    let tempKnockMessage = knockMessage
//                                    knockMessage = ""
//                                    let newKnock = Knock(
//                                        date: .now,
//                                        knockMessage: tempKnockMessage,
//                                        knockStatus: Constant.KNOCK_WAITING,
//                                        knockCategory: chatPurpose,
//                                        receivedUserName: targetUserInfo.githubLogin,
//                                        sentUserName: currentUser.githubLogin,
//                                        receivedUserID: targetUserInfo.id,
//                                        sentUserID: currentUser.id
//                                    )
//
//                                    // Assign New Knock On Model
//                                    knockViewManager.assignNewKnock(newKnock: newKnock)
//
//                                    // TODO: 알람 보내기
//                                    // 새로운 노크가 생성될 때의 Push Notification 전달
//                                    await pushNotificationManager.sendNotification(
//                                        with: .knock(
//                                            title: "New Knock has been Arrived.",
//                                            body: tempKnockMessage,
//                                            pushSentFrom: currentUser.githubLogin,
//                                            knockPurpose: chatPurpose,
//                                            knockID: newKnock.id
//                                        ),
//                                        to: targetUserInfo
//                                    )
//
//                                    await knockViewManager.createKnockOnFirestore(knock: newKnock)
//
//                                    withAnimation(.easeInOut.speed(1.5)) { isKnockSent = true }
//                                }
//                            }
                        }
                    }
//                    .foregroundColor(.primary)
//                    .padding(.horizontal)
//                    .padding(.bottom)
                }
            }
//        }
        .task {
            self.targetUserInfo = await userStore.requestUserInfoWithGitHubID(githubID: targetGithubUser?.id ?? 0)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                NavigationLink {
                    if let targetGithubUser {
                        TargetUserProfileView(user: targetGithubUser)
                    }
                } label: {
                    HStack(spacing: 5) {
                        AsyncImage(url: URL(string: "\(targetGithubUser?.avatar_url ?? "")")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 30)
                        } placeholder: {
                            ProgressView()
                        } // AsyncImage
                        
                        Text("\(targetGithubUser?.login ?? "NONO")")
                            .bold()
                    } // HStack
                    .foregroundColor(.primary)
                } // NavigationLink
            } // ToolbarItemGroup
        } // toolbar
        .sheet(isPresented: $showKnockGuide) {
            NavigationView {
                KnockGuideView()
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showKnockGuide.toggle()
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                    }
            }
            .navigationBarTitle("Knock")
        }
    }
}

struct SendKnock_Previews: PreviewProvider {
    
    @State private var targetUserInfo: UserInfo? = UserInfo(id: "rtlnrC8I8LaLtqHPhETxfuG0JjE3", createdDate: Date.now, deviceToken: "1234", blockedUserIDs: [], githubID: 64696968, githubLogin: "guguhanogu", githubName: "hanho", githubEmail: "", avatar_url: "https://avatars.githubusercontent.com/u/64696968?v=4", bio: " iOS Developer- LikeLion iOS AppSchool 1기", company: "", location: "Korea, South", blog: "", public_repos: 7, followers: 33, following: 36)
    
    static var previews: some View {
        SendKnock()
    }
}
