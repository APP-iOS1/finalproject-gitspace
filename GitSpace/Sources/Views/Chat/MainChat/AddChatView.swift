//
//  AddChatView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/09.
//

import SwiftUI

struct AddChatView: View {
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var userStore: UserStore
    @State var currentUserName: String = ""
    @State var user1: String = ""
    @State var user2: String = ""
    
    var body: some View {
        
        VStack {
            Text("현재 로그인 유저 이름 : \(currentUserName)")
            ForEach(userStore.users) { user in
                HStack {
                    Text(user.name)
                    Spacer()
                    
                    Group {
                        Button {
                            Utility.loginUserID = user.id
                            currentUserName = user.name
                        } label: {
                            Text("로그인 유저 변경하기")
                        }
                        
                        Button {
                            user1 = user.id
                        } label: {
                            Text("유저1 변경하기")
                        }
                        
                        Button {
                            user2 = user.id
                        } label: {
                            Text("유저2 변경하기")
                        }
                        
                    }
                    .buttonStyle(.bordered)
                    .tint(.pink)
                    
                    
                    
                }
            }
            .padding()
            
            Divider()
            
            Text("유저 1 : \(user1)")
            
            Text("유저 2 : \(user2)")
            
            Button {
                let newChat: Chat = .init(id: UUID().uuidString,
                                          date: Date.now,
                                          joinUserIDs: [user1, user2],
                                          lastDate: Date.now,
                                          lastContent: "",
                                          knockContent: "",
                                          knockDate: Date.now)
                Task {
                    await chatStore.addChat(newChat)
                }
            } label: {
                Text("채팅방 추가하기")
            }
            .buttonStyle(.bordered)
            .tint(.orange)
            
            
        }
        .task {
            userStore.fetchUsers()
        }
    }
}

struct AddChatView_Previews: PreviewProvider {
    static var previews: some View {
        AddChatView()
    }
}
