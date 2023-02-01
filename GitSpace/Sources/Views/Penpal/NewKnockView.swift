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
                    
                    
                    
                    HStack {
                    }.id(bottomID)
                        
                    
                } // ScrollView
                .onChange(of: keyboardHandler.keyboardHeight) { _ in
                            withAnimation { proxy.scrollTo(bottomID) }
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
