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
        ZStack{
            ScrollView {
                ForEach(userStore.users) { user in
                    Button {
                        Task{
                            chatPersonID = user.id
                            print(chatStore.targetChat ?? "no target")
                            chatStore.requestChatFromUserList(userIDs: [Utility.loginUserID, chatPersonID])
                            print(chatStore.targetChat ?? "no target 2")
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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.4))
            }
        }
        .task {
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
