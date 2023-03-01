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
	
	@State var sendKnockToGitHubUser: GithubUser?
	@State private var sentTo: UserInfo?
	@State private var newKnock: Knock? = nil
	@State private var isKnockSent: Bool = false
	
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    
                    HStack {
                    }
                    .id(topID)
                    
                    // MARK: - 상단 프로필 정보 뷰
                    /*
                    TopperProfileView()
                    
                    Divider()
                        .padding(.vertical, 10)
                        .padding(.horizontal, 5)
                    */
                     
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
//                                    .becomeFirstResponder()
                            } label: {
                                Text("🚀 Offer")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .bold()
                                    .padding(EdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13))
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
                                    .foregroundColor(.primary)
                                    .bold()
                            } // button: Question
                    } // HStack
                    
                    // MARK: - 안내문구
                    /// userName에게 KnockMessage를 보내세요!
                    /// 상대방이 Knock message를 확인하기 전까지 수정할 수 있습니다.
                    /// Knock message는 전송 이후에 삭제하거나 취소할 수 없습니다.
                    if !chatPurpose.isEmpty {
                        
                        VStack(alignment: .center, spacing: 10) {
                            VStack (alignment: .center) {
                                Text("Send your Knock messages to")
                                Text("\(sendKnockToGitHubUser?.login ?? "NONO")!")
                                    .bold()
                            } // VStack
                            
                            VStack(alignment: .center) {
                                Text("You can edit your Knock message before receiver")
                                Text("reads it, but can't cancel or delete chat once it is sent.")
                            } // VStack
                            .font(.footnote)
                            .foregroundColor(.gsLightGray1)
                            
                            Divider()
                                .padding(.vertical, 15)
                                .frame(width: 300)
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 3, height: 15)
                                    .foregroundColor(.gsGreenPrimary)
                                
                                Text(
									isKnockSent
									? "Your Knock Message"
									: "Example Knock Message"
								)
                                    .font(.footnote)
                                    .foregroundColor(.gsLightGray1)
                                    .bold()
                            } // HStack
                            .padding(.leading, -75)
                            
                            VStack {
                                
                                Text(
									isKnockSent
									? "\(newKnock?.knockMessage ?? "")"
									: "\("Hi! This is Gildong from South Korea who’s\ncurrently studying Web programming.\nWould you mind giving me some time and\nadvising me on my future career path?\nThank you so much for your help!")"
								)
                                    .font(.system(size: 10, weight: .regular))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 20)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .background(
                                        RoundedRectangle(cornerRadius: 17)
                                            .fill(.white)
                                            .shadow(color: Color(.systemGray5), radius: 8, x: 0, y: 2)
                                        
                                    )
                                    .padding(.horizontal, 15)
                                
								if isKnockSent {
									Text("Your Knock Message has successfully been\ndelivered to **\(sendKnockToGitHubUser?.login ?? "")**")
										.font(.system(size: 10, weight: .regular))
										.padding(.horizontal, 20)
										.padding(.vertical, 20)
										.fixedSize(horizontal: false, vertical: true)
										.multilineTextAlignment(.center)
									
									Text("\(newKnock?.knockedDate.dateValue().formattedDateString() ?? "")")
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
                    .frame(height: 320)
                    
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
                    
                    Divider()
                        .padding(.top, -8)
                    
                    HStack {
                        Text("✍️ Offer-related message...")
                            .foregroundColor(.gsLightGray1)
                            .bold()
                        
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
                        
                        Spacer()
                        
                        // MARK: 키보드 내리기 버튼
                        Button {
                            self.endTextEditing()
                        } label: {
                            Image(systemName: keyboardHandler.keyboardHeight > 0
                                  ? "keyboard.chevron.compact.down"
                                  : "")
                            .foregroundColor(.gsLightGray1)
                        }
                        
                    } // HStack
                    .padding(.horizontal)
                    
                    HStack(spacing: 10) {
                        
                        //                        VStack {
                        //                            Spacer()
                        
                        Button {
                            print("이미지 첨부 버튼 탭")
                        } label: {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 30)
                        }

                        Button {
                            print("레포지토리 선택 버튼 탭")
                        } label: {
                            Image("RepositoryIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28, height: 23)
                        }
                        
                        GSTextEditor.CustomTextEditorView(style: .message, text: $knockMessage)
                        
                        Button {
							Task {
								// 노크 보내기
								await sendKnock()
								
								// 알람 보내기
								await pushKnockNotification()
								
								isKnockSent = true
							}
                        } label: {
                            Image(systemName: "paperplane")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22)
                                .foregroundColor(knockMessage.isEmpty ? .gsGray2 : .primary)
                        }
                        .disabled(knockMessage.isEmpty || isKnockSent)
                        
                    } // HStack
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                } else if chatPurpose == "question" {
                    
                    Divider()
                        .padding(.top, -8)
                    
                    HStack {
                        Text("✍️ Question-related message...")
                            .foregroundColor(.gsLightGray1)
                            .bold()
                        
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
                        
                        Spacer()
                        
                        // MARK: 키보드 내리기 버튼
                        Button {
                            self.endTextEditing()
                        } label: {
                            Image(systemName: keyboardHandler.keyboardHeight > 0
                                  ? "keyboard.chevron.compact.down"
                                  : "")
                            .foregroundColor(.gsLightGray1)
                        } // Button
                        
                    } // HStack
                    .padding(.horizontal)
                    
                    HStack(spacing: 10) {
                        Button {
                            print("이미지 첨부 버튼 탭")
                        } label: {
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 30)
                        }
                        //                        } // VStack: 이미지 첨부 버튼
                        
                        Button {
                            print("레포지토리 선택 버튼 탭")
                        } label: {
                            Image("RepositoryIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 28, height: 23)
                        }
                        //                        } // VStack: 레포지토리 선택 버튼
                        
                        GSTextEditor.CustomTextEditorView(style: .message, text: $knockMessage)
                        
                        
                        Button {
							Task {
								// 노크 보내기
								await sendKnock()
								// 알람 보내기
								await pushKnockNotification()
								
								isKnockSent = true
							}
                        } label: {
                            Image(systemName: "paperplane")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22, height: 22)
                                .foregroundColor(knockMessage.isEmpty ? .gsGray2 : .primary)
                        }
						.disabled(knockMessage.isEmpty || isKnockSent)
                        //                        } // VStack
                    } // HStack
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                } // if - else if
            } // VStack
        } // VStack
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
                    .foregroundColor(.black)
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
	
	private func sendKnock() async -> Void {
		guard let githubID = sendKnockToGitHubUser?.id else { return }
		
		@Sendable
		func getSentToUser() async -> UserInfo {
			await userStore.requestUserInfoWithGitHubID(
				githubID: githubID
			) ?? .getFaliedUserInfo()
		}
		
		sentTo = await getSentToUser()
		
		self.newKnock = .init(
			date: .now,
			knockMessage: knockMessage,
			knockStatus: Constant.KNOCK_WAITING,
			knockCategory: chatPurpose,
			receivedUserName: sendKnockToGitHubUser?.login ?? "",
			sentUserName: userStore.currentUser?.githubLogin ?? "",
			receivedUserID: sentTo?.id ?? "", // 받을 사람
			sentUserID: userStore.currentUser?.id ?? "" // 보낸 사람
		)
		
		knockMessage = ""
		
		if let newKnock {
			await knockViewManager.createKnock(
				knock: newKnock
			)
		}
	}
	
	private func pushKnockNotification() async -> Void {
		await pushNotificationManager.sendNotification(
			with: .knock(
				title: "New Knock Has Been Arrived!",
				body: newKnock?.knockMessage ?? "",
				nameOfKnockedPerson: userStore.currentUser?.githubLogin ?? "",
				knockID: newKnock?.id ?? ""
			),
			to: sentTo ?? .getFaliedUserInfo()
		)
	}
}

//struct SendKnockView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            SendKnockView()
//        }
//    }
//}
