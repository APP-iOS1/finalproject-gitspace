//
//  SendKnockView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/05/08.
//

import SwiftUI

struct SendKnockView: View {
    
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
                            
                            if !isKnockSent {
                                BeforeSendKnockSection(
                                    targetGithubUser: targetGithubUser,
                                    showKnockGuide: $showKnockGuide
                                )
                                
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
                                .padding(.top, 10)
                                
                                if !chatPurpose.isEmpty {
                                    EditingKnockSection(
                                        targetGithubUser: targetGithubUser
                                    )
                                        .padding(.top, 80)
                                }
                            }
                            
                            if isKnockSent {
                                AfterSendKnockSection(
                                    targetGithubUser: targetGithubUser
                                )
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
            
            if !isKnockSent,
               !chatPurpose.isEmpty {
                SendKnockTextEditSection(
                    isKnockSent: $isKnockSent,
                    chatPurpose: $chatPurpose,
                    targetGithubUser: targetGithubUser,
                    targetUserInfo: targetUserInfo
                )
            }
        }
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
                        }
                        
                        Text("\(targetGithubUser?.login ?? "NONO")")
                            .bold()
                    }
                    .foregroundColor(.primary)
                }
            }
        }
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

struct SendKnockView_Previews: PreviewProvider {
    
    @State private var targetUserInfo: UserInfo? = UserInfo(id: "rtlnrC8I8LaLtqHPhETxfuG0JjE3", createdDate: Date.now, deviceToken: "1234", blockedUserIDs: [], githubID: 64696968, githubLogin: "guguhanogu", githubName: "hanho", githubEmail: "", avatar_url: "https://avatars.githubusercontent.com/u/64696968?v=4", bio: " iOS Developer- LikeLion iOS AppSchool 1기", company: "", location: "Korea, South", blog: "", public_repos: 7, followers: 33, following: 36)
    
    static var previews: some View {
        SendKnockView()
    }
}
