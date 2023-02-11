import SwiftUI

struct ChatListSection: View {
    
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var userStore: UserStore
    
    var body: some View {
        // MARK: -Constant : 채팅방 리스트를 최근순으로 정렬한 리스트
        VStack(alignment: .leading) {
            Text("My Chats")
                .font(.footnote)
                .foregroundColor(Color.gray)
            
            if chatStore.isDoneFetch {
                // 채팅방 목록 리스트
                ForEach(chatStore.chats) { chat in
                    
                    if let targetUserName = chatStore.targetNameDict[chat.id] {
                        
                        NavigationLink {
                            ChatRoomView(chat: chat,
                                         targetUserName: targetUserName)
                        } label: {
                            ChatListCell(chat: chat,
                                         targetUserName: targetUserName)
                            .foregroundColor(.black)
                        }
                        
                    }
                }
            } else {
                ForEach(0..<5, id: \.self) { i in
                    ChatListSkeletonCell()
                }
            }
        }
        .task{
            if !chatStore.isDoneFetch {
                chatStore.addListener()
                await chatStore.fetchChats()
            }
            await userStore.requestUser(userID: Utility.loginUserID)
        }
        
    }
}

struct ChatListSection_Previews: PreviewProvider {
    static var previews: some View {
        ChatListSection()
            .environmentObject(ChatStore())
            .environmentObject(UserStore())
    }
}
