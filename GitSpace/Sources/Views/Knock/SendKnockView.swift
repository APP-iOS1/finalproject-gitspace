//
//  SendKnockView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/31.
//

import SwiftUI

enum TextEditorFocustState {
    case edit
    case done
}

struct SendKnockView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var pushNotificationManager: PushNotificationManager
    
    @Namespace var topID
    @Namespace var bottomID
    
    @StateObject private var keyboardHandler = KeyboardHandler()
    @FocusState private var isFocused: TextEditorFocustState?
    @State private var chatPurpose: String = ""
    @State private var knockMessage: String = ""
    @State private var showKnockGuide: Bool = false
    
    @State private var newKnock: Knock? = nil
    @State private var isKnockSent: Bool = false
    @State private var opacity: CGFloat = 0.4
    
    /**
     Knock를 받을 상대방의 정보는 GithubUser 타입으로 전달됩니다.
     전달받은 아규먼트의 정보를 토대로 상대방의 UserInfo를 DB에서 색인합니다.
     */
    @State var sendKnockToGitHubUser: GithubUser?
    @State private var targetUserInfo: UserInfo? = nil
    
    var body: some View {
        VStack {
            if let targetUserInfo {
                ScrollViewReader { proxy in
                    ScrollView {
                        HStack {
                        }
                        .id(topID)
                        
                        // MARK: - 상단 프로필 정보 뷰
                        TopperProfileView(targetUserInfo: targetUserInfo)
                        
                        Divider()
                            .padding(.vertical, 10)
                            .padding(.horizontal, 5)
                        
                        if !isKnockSent {
                            // MARK: - 안내 문구
                            /// userName님께 보내는 첫 메세지네요!
                            /// 노크를 해볼까요?
                            VStack(spacing: 5) {
                                HStack(spacing: 5) {
                                    Text("It's the first message to")
                                    Text("\(sendKnockToGitHubUser?.login ?? "NONO")!")
                                        .bold()
                                }
                                
                                HStack(spacing: 5) {
                                    Text("Would you like to")
                                    Button {
                                        showKnockGuide.toggle()
                                    } label: {
                                        Text("Knock")
                                            .bold()
                                    }
                                    Text("?")
                                        .padding(.leading, -4)
                                }
                            }
                            .padding(.vertical, 15)
                            
                            // MARK: - 안내 문구
                            /// 상대방에게 알려줄 채팅 목적을 선택해주세요.
                            VStack(alignment: .center) {
                                Text("Please specify the purpose of your chat to let")
                                Text("your pal better understand your situation.")
                            }
                            .font(.footnote)
                            .foregroundColor(.gsLightGray1)
                            .padding(.bottom, 10)
                            
                            // MARK: - 채팅 목적 버튼
                            HStack(spacing: 30) {
                                GSButton.CustomButtonView(style: .secondary(
                                    isDisabled: false)) {
                                        withAnimation(.easeInOut.speed(1.5)) {
                                            chatPurpose = "offer"
                                        }
                                        withAnimation(.easeInOut.speed(1.5)) { proxy.scrollTo(bottomID) }
                                    } label: {
                                        Text("🚀 Offer")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                            .bold()
                                            .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                                    } // button: Offer
                                
                                GSButton.CustomButtonView(style: .secondary(
                                    isDisabled: false)) {
                                        withAnimation(.easeInOut.speed(1.5)) {
                                            chatPurpose = "question"
                                        }
                                        withAnimation(.easeInOut.speed(1.5)) { proxy.scrollTo(bottomID) }
                                    } label: {
                                        Text("💡 Question")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                            .bold()
                                    } // button: Question
                            } // HStack
                        } // if
                        
                        // MARK: - 안내문구
                        /// userName에게 KnockMessage를 보내세요!
                        /// 상대방이 Knock message를 확인하기 전까지 수정할 수 있습니다.
                        /// Knock message는 전송 이후에 삭제하거나 취소할 수 없습니다.
                        if !chatPurpose.isEmpty {
                            VStack(alignment: .center, spacing: 10) {
                                
                                if !isKnockSent {
                                    VStack (alignment: .center) {
                                        Text("Send your Knock messages to")
                                        Text("\(sendKnockToGitHubUser?.login ?? "NONO")!")
                                            .bold()
                                    } // VStack
                                    
                                    VStack(alignment: .center) {
                                        Text(
"""
You cannot modify or delete a message after it has been sent.
Please write a message carefully.
""")
                                        // MARK: !!!
                                        /// 노크 메세지가 수정 가능하면 대체할 텍스트 입니다.
                                        //                                    Text("""
                                        //You can edit your Knock message before receiver reads it,
                                        //but can't cancel or delete chat once it is sent.
                                        //""")
                                    } // VStack
                                    .font(.footnote)
                                    .foregroundColor(.gsLightGray1)
                                    .multilineTextAlignment(.center)
                                    
                                    Divider()
                                        .padding(.vertical, 15)
                                        .frame(width: 350)
                                } // if
                                
                                HStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: 3, height: 15)
                                        .foregroundColor(colorScheme == .light
                                                         ? .gsGreenPrimary
                                                         : .gsYellowPrimary)
                                    Text(
                                        isKnockSent
                                        ? "Your Knock Message"
                                        : "Example Knock Message"
                                    )
                                    .font(.footnote)
                                    .foregroundColor(.gsLightGray1)
                                    .bold()
                                    
                                    Spacer()
                                } // HStack
                                .padding(.leading, 20)
                                
                                VStack {
                                    GSCanvas.CustomCanvasView.init(style: .primary, content: {
                                        Text(
                                            isKnockSent
                                            ? "\(knockViewManager.newKnock?.knockMessage ?? "")"
                                            : "\("Hi! This is Gildong from South Korea who’s\ncurrently studying Web programming.\nWould you mind giving me some time and\nadvising me on my future career path?\nThank you so much for your help!")"
                                        )
                                        .font(.system(size: 13, weight: .regular))
                                        .foregroundColor(.primary)
                                        //                                        .padding(.horizontal, 10)
                                        //                                        .padding(.vertical, 10)
                                    })
                                    .padding(10)
                                    
                                    if isKnockSent {
                                        Text("Your Knock Message has successfully been\ndelivered to **\(sendKnockToGitHubUser?.login ?? "")**")
                                            .font(.system(size: 10, weight: .regular))
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 20)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .multilineTextAlignment(.center)
                                        
                                        Text("\(knockViewManager.newKnock?.knockedDate.dateValue().formattedDateString() ?? "")")
                                            .font(.callout)
                                            .foregroundColor(.gsGray1)
                                            .padding(.vertical, 8)
                                    }
                                } // VStack
                            } // VStack
                            .padding(.top, 80)
                        }
                        
                        HStack {
                        }
                        .id(bottomID)
                        .frame(height: isKnockSent ? 5 : 320)
                        
                    } // ScrollView
                    //                .padding(.bottom, keyboardHandler.keyboardHeight)
                    /// chatPurpose 값이 바뀜에 따라 키보드를 bottomID로 이동시킴
                    .onChange(of: chatPurpose) { _ in
                        withAnimation(.easeInOut.speed(1.5)) { proxy.scrollTo(bottomID) }
                    }
                    /// TextEditor 이외의 공간을 터치할 경우,
                    /// 키보드 포커싱을 없앰
                    .onTapGesture {
                        self.endTextEditing()
                    }
                    .animation(.default, value: keyboardHandler.keyboardHeight)
                } // ScrollViewReader
                
                // MARK: - 텍스트 에디터
                VStack {
                    if chatPurpose == "offer" {
                        
                        if !isKnockSent {
                            Divider()
                                .padding(.top, -8)
                            
                            HStack {
                                Text("✍️ Offer-related message...")
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
                            } // HStack
                            .padding(.horizontal)
                        }
                        
                        HStack(spacing: 10) {
                            // MARK: 최초 릴리즈 버전에서는 사용하지 않습니다.
                            //                            Button {
                            //                                print("이미지 첨부 버튼 탭")
                            //                            } label: {
                            //                                Image(systemName: "photo")
                            //                                    .resizable()
                            //                                    .aspectRatio(contentMode: .fit)
                            //                                    .frame(width: 20, height: 30)
                            //                            }
                            //
                            //                            Button {
                            //                                print("레포지토리 선택 버튼 탭")
                            //                            } label: {
                            //                                Image("RepositoryIcon")
                            //                                    .resizable()
                            //                                    .aspectRatio(contentMode: .fit)
                            //                                    .frame(width: 28, height: 23)
                            //                            }
                            
                            
                            GSTextEditor.CustomTextEditorView(style: .message,
                                                              text: $knockMessage,
                                                              sendableImage: "paperplane.fill",
                                                              unSendableImage: "paperplane") {
                                Task {
                                    let newKnock = Knock(
                                        date: .now,
                                        knockMessage: knockMessage,
                                        knockStatus: Constant.KNOCK_WAITING,
                                        knockCategory: chatPurpose,
                                        receivedUserName: targetUserInfo.githubLogin,
                                        sentUserName: userStore.currentUser?.githubLogin ?? "",
                                        receivedUserID: targetUserInfo.id,
                                        sentUserID: userStore.currentUser?.id ?? ""
                                    )
                                    
                                    // Assign New Knock On Model
                                    knockViewManager.assignNewKnock(newKnock: newKnock)
                                    
                                    // TODO: 알람 보내기
                                    // 새로운 노크가 생성될 때의 Push Notification 전달
                                    await pushNotificationManager.sendNotification(
                                        with: .knock(
                                            title: "New Knock has been Arrived.",
                                            body: knockMessage,
                                            knockSentFrom: userStore.currentUser?.githubLogin ?? "",
                                            knockPurpose: chatPurpose,
                                            knockID: newKnock.id
                                        ),
                                        to: targetUserInfo
                                    )
                                    
                                    await knockViewManager.createKnockOnFirestore(knock: newKnock)
                                    
                                    withAnimation(.easeInOut.speed(1.5)) { isKnockSent = true }
                                    knockMessage = ""
                                }
                            }
                        } // HStack
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                    } else if chatPurpose == "question" {
                        
                        if !isKnockSent {
                            Divider()
                                .padding(.top, -8)
                            
                            HStack {
                                Text("✍️ Question-related message...")
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
                            } // HStack
                            .padding(.horizontal)
                        }
                        
                        HStack(spacing: 10) {
                            // MARK: 최초 릴리즈 버전에서는 사용하지 않습니다.
                            //                            Button {
                            //                                print("이미지 첨부 버튼 탭")
                            //                            } label: {
                            //                                Image(systemName: "photo")
                            //                                    .resizable()
                            //                                    .aspectRatio(contentMode: .fit)
                            //                                    .frame(width: 20, height: 30)
                            //                            }
                            //
                            //                            Button {
                            //                                print("레포지토리 선택 버튼 탭")
                            //                            } label: {
                            //                                Image("RepositoryIcon")
                            //                                    .resizable()
                            //                                    .aspectRatio(contentMode: .fit)
                            //                                    .frame(width: 28, height: 23)
                            //                            }
                            
                            
                            
                            GSTextEditor.CustomTextEditorView(style: .message,
                                                              text: $knockMessage,
                                                              sendableImage: "paperplane.fill",
                                                              unSendableImage: "paperplane") {
                                Task {
                                    let newKnock = Knock(
                                        date: .now,
                                        knockMessage: knockMessage,
                                        knockStatus: Constant.KNOCK_WAITING,
                                        knockCategory: chatPurpose,
                                        receivedUserName: targetUserInfo.githubLogin,
                                        sentUserName: userStore.currentUser?.githubLogin ?? "",
                                        receivedUserID: targetUserInfo.id,
                                        sentUserID: userStore.currentUser?.id ?? ""
                                    )
                                    
                                    // Assign New Knock On Model
                                    knockViewManager.assignNewKnock(newKnock: newKnock)
                                    
                                    // TODO: 알람 보내기
                                    // 새로운 노크가 생성될 때의 Push Notification 전달
                                    await pushNotificationManager.sendNotification(
                                        with: .knock(
                                            title: "New Knock has been Arrived.",
                                            body: knockMessage,
                                            knockSentFrom: userStore.currentUser?.githubLogin ?? "",
                                            knockPurpose: chatPurpose,
                                            knockID: newKnock.id
                                        ),
                                        to: targetUserInfo
                                    )
                                    
                                    await knockViewManager.createKnockOnFirestore(knock: newKnock)
                                    
                                    withAnimation(.easeInOut.speed(1.5)) { isKnockSent = true }
                                    knockMessage = ""
                                }
                            }
                        } // HStack
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                        .padding(.bottom)
                    } // if - else if
                } // VStack
            }
            else {
                Text("loading")
                    .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
            }
        } // VStack
        .task {
            self.targetUserInfo = await userStore.requestUserInfoWithGitHubID(githubID: sendKnockToGitHubUser?.id ?? 0)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                NavigationLink {
                    ProfileDetailView()
                } label: {
                    HStack(spacing: 5) {
                        AsyncImage(url: URL(string: "\(sendKnockToGitHubUser?.avatar_url ?? "")")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 30)
                        } placeholder: {
                            ProgressView()
                        } // AsyncImage
                        
                        Text("\(sendKnockToGitHubUser?.login ?? "NONO")")
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
                            } // Button
                        } // ToolbarItem
                    } // toolbar
            }
            .navigationBarTitle("Knock")
        }
    }
    
    // TODO: - Push Notification, Make new Knock Implement
}

//struct SendKnockView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            SendKnockView()
//        }
//    }
//}
