//
//  UserView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

// TODO: 이거 얘기해야 됨
/// 1. userList에서 타겟 채팅방 체크를 언제할지. 이거 ChatDetailView에서 Chat을 옵셔널로 할지도 고려!!
///

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var chatStore: ChatStore
    @State var showZStack: Bool = false
    @State var chatPersonID: String = ""
    
    var body: some View {
        VStack {
            if let targetName = userStore.targetUserName {
                Text("현재 로그인 중인 유저 : \(targetName)")
            }
            
            ZStack{
                List {
                    
                    ForEach(userStore.users) { user in
                        Button {
                            Task{
                                chatPersonID = user.id
                                chatStore.requestChatFromUserList(userIDs: [Utility.loginUserID, chatPersonID])
                                showZStack = true
                            }
                        } label: {
                            HStack{
                                Image(systemName: "person")
                                Text(user.name)
                            }
                        }
                    }
                }
                if showZStack {
                    VStack{
                        NavigationLink {
                            //???: -targetChat is availiable 이거 왜 3번이나 출력 됨?
                            if let targetChat = chatStore.targetChat {
                                let _ = print("targetChat is availiable")
                                ChatDetailView(chat: targetChat, isFromUserList: true)
                            }
                        } label: {
                            Text("채팅 ㄱㄱ?")
                                .modifier(ButtonModifier())
                        }
                        
                        Button {
                            showZStack = false
                        } label: {
                            Text("이미 채팅은 생성했지만 ZStack 끄기")
                                .modifier(ButtonModifier())
                        }

                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
                }
            }
            
        }
        .task {
            userStore.requestTargetUserName(targetID: Utility.loginUserID)
            userStore.fetchUsers()
        }
    }
}


struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
            .environmentObject(UserStore())
            .environmentObject(ChatStore())
    }
}
