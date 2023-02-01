//
//  NewKnockView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/31.
//

import SwiftUI

enum TextEditorFocustState {
    case edit
    case done
}


struct NewKnockView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Namespace var topID
    @Namespace var bottomID
    
    @StateObject private var keyboardHandler = KeyboardHandler()
    @FocusState private var isFocused: TextEditorFocustState?
    @State private var chatPurpose: String = ""
    @State private var knockMessage: String = ""
    
    var body: some View {
        VStack {
            VStack {
                Button {
                    
                } label: {
                    
                }
            } // VStack
            
            ScrollViewReader { proxy in
                ScrollView {
                    // MARK: - User Profice Pic
                    AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/64696968?v=4")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(width: 100)
                    } placeholder: {
                        ProgressView()
                    } // AsyncImage
                    
                    // MARK: - User Info
                    VStack(spacing: 5) {
                        /// userName이 들어갈 자리
                        Text("\("guguhanogu")")
                            .bold()
                            .font(.title3)
                            .foregroundColor(Color(.black))
                        
                        /// user의 팔로워 수, 레포 수 가 표시될 자리
                        HStack {
                            Text("\("0") repositories﹒\("392") followers")
                        }
                    } // VStack : User Info
                    .font(.footnote)
                    .foregroundColor(Color(.systemGray))
                    
                    // MARK: - 프로필 이동 버튼
                    NavigationLink {
                        ProfileDetailView()
                    } label: {
                        GSButton.CustomButtonView(style: .secondary(
                            isDisabled: false)) {
                                
                            } label: {
                                Text("View Profile")
                                    .font(.footnote)
                                    .foregroundColor(.primary)
                                    .bold()
                                    .padding(-8)
                                    .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: -10))
                            }
                    }
                    
                    Divider()
                        .padding(.vertical, 10)
                        .padding(.horizontal, 5)
                    
                    // MARK: - 안내 문구
                    /// userName님께 보내는 첫 메세지네요!
                    /// 노크를 해볼까요?
                    VStack(spacing: 5) {
                        HStack(spacing: 5) {
                            Text("It's the first message to")
                            Text("\("guguhanogu")!")
                                .bold()
                        }
                        
                        HStack(spacing: 5) {
                            Text("Would you like to")
                            Button {
                                
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
//                                    proxy.scrollTo(bottomID, anchor: .top)
                                }
                            } label: {
                                Text("🚀 Offer")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .bold()
                                    .padding(-10)
                                    .padding(EdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13))
                            } // button: Offer
                        
                        GSButton.CustomButtonView(style: .secondary(
                            isDisabled: false)) {
                                withAnimation(.easeInOut.speed(1.5)) {
                                    chatPurpose = "question"
//                                    proxy.scrollTo(bottomID, anchor: .top)
                                }
                            } label: {
                                Text("💡 Question")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .bold()
                                    .padding(-10)
                            } // button: Question
                    } // HStack
                    
                    // MARK: - 안내문구
                    /// userName에게 KnockMessage를 보내세요!
                    /// 상대방이 Knock message를 확인하기 전까지 수정할 수 있습니다.
                    /// Knock message는 전송 이후에 삭제하거나 취소할 수 없습니다.
                    /// You can edit your knock message before receiver reads it, but can’t cancel or delete chat once it is sent.
                    if !chatPurpose.isEmpty {
                        
                        VStack(alignment: .center, spacing: 10) {
                            VStack (alignment: .center) {
                                Text("Send your Knock messages to")
                                Text("\("guguhanogu")!")
                                    .bold()
                            }
                            
                            VStack(alignment: .center) {
                                Text("You can edit your Knock message before receiver")
                                Text("reads it, but can't cancel or delete chat once it is sent.")
                            }
                            .font(.footnote)
                            .foregroundColor(.gsLightGray1)
                            
                            Divider()
                                .padding(.vertical, 15)
                                .frame(width: 300)
                            
                            HStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: 3, height: 15)
                                    .foregroundColor(.gsGreenPrimary)
                                
                                Text("Example Knock Message")
                                    .font(.footnote)
                                    .foregroundColor(.gsLightGray1)
                                    .bold()
                            }
                            .padding(.leading, -75)
                            
                            VStack {
                                
                                Text("\("Hi! This is Gildong from South Korea who’s\ncurrently studying Web programming.\nWould you mind giving me some time and\nadvising me on my future career path?\nThank you so much for your help!")")
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
                                    
                            }
                            
                        }
                        .padding(.top, 100)
                    }
                    
                    HStack {
                    }.id(bottomID)
                        .frame(height: 300)
                        
                    
                } // ScrollView
//                .onChange(of: keyboardHandler.keyboardHeight) { _ in
//                            withAnimation { proxy.scrollTo(bottomID) }
//                        }
                .onChange(of: chatPurpose/*keyboardHandler.keyboardHeight*/) { _ in
                    withAnimation(.easeIn.speed(0.5)) { proxy.scrollTo(bottomID) }
                        }
                .onTapGesture {
                    self.endTextEditing()
                    
                }
//                .padding(.top, -(keyboardHandler.keyboardHeight / 2))
                .animation(.default, value: keyboardHandler.keyboardHeight)
//                .onChange(of: isFocused) { value in
//                    withAnimation(.easeInOut.speed(1.5)) {
//                        proxy.scrollTo(bottomID, anchor: .top)
//                    }
//                }
            } // ScrollViewReader
//            .padding(.top, -40)
            
            VStack {
                if chatPurpose == "offer" {
                    HStack {
                        Text("✍️ Offer-related message...")
                            .foregroundColor(.gsLightGray1)
                            .bold()
                        Spacer()
                        
                        Button {
                            self.endTextEditing()
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                        
                    } // HStack
                    .padding(.horizontal)
                    
                    TextEditor(text: $knockMessage)
                        .frame(maxHeight: 50)
                        .focused($isFocused, equals: .edit)
                    //                        .padding()
                    //                        .border(Color.systemGray3, width: 1)
                    
                    
                    
                } else if chatPurpose == "question" {
                    HStack {
                        Text("✍️ Question-related message...")
                            .foregroundColor(.gsLightGray1)
                            .bold()
                        Spacer()
                        
                        Button {
                            self.endTextEditing()
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                        
                    } // HStack
                    .padding(.horizontal)
                    
                    TextEditor(text: $knockMessage)
                        .frame(maxHeight: 50)
                        .focused($isFocused, equals: .edit)
                    //                        .padding()
                    //                        .border(Color.systemGray3, width: 1)
                    
                } // if - else if
            } // VStack
        } // VStack
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button {
//                    dismiss()
//                } label: {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                        Text("Back")
//                            .padding(.leading, -5)
//                    }
//                    .foregroundColor(.black)
//                }
//
//            } // ToolbarItem
            
            ToolbarItemGroup(placement: .principal) {
                NavigationLink {
                    ProfileDetailView()
                } label: {
                    HStack(spacing: 5) {
                        AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/64696968?v=4")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 30)
                        } placeholder: {
                            ProgressView()
                        } // AsyncImage
                        
                        Text("\("guguhanogu")")
                            .bold()
                    } // HStack
                    .foregroundColor(.black)
                }
            } // ToolbarItemGroup
        } // toolbar
    }
}

struct NewKnockView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewKnockView()
        }
    }
}
