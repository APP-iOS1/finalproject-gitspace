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
    @State var user1: String = ""
    @State var user2: String = ""
    
    var body: some View {
        
        VStack {
            Text("현재 로그인 유저 이름 : \(userStore.user?.githubUserName ?? "패치 실패")")
            ForEach(userStore.users) { user in
                HStack {
                    Text(user.githubUserName)
                    Spacer()
                    
                    Group {
                        Button {
                            Utility.loginUserID = user.id
                            Task {
                                await userStore.requestUser(userID: Utility.loginUserID)
                            }
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
                                          createdDate: Date.now,
                                          joinedMemberIDs: [user1, user2],
                                          lastContent: "",
                                          lastContentDate: Date.now,
                                          knockContent: "",
                                          knockContentDate: Date.now)
                Task {
                    chatStore.addChat(newChat)
                }
            } label: {
                Text("채팅방 추가하기")
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
        .task {
            await userStore.requestUsers()
            
        }
    }
}

struct AddChatView_Previews: PreviewProvider {
    static var previews: some View {
        AddChatView()
    }
}
