import SwiftUI

struct ChatListSection: View {
    
    @EnvironmentObject var chatStore: ChatStore
    
    var body: some View {
        // MARK: -Constant : 채팅방 리스트를 최근순으로 정렬한 리스트
        VStack(alignment: .leading) {
            Text("My Penpals")
                .font(.footnote)
                .foregroundColor(Color.gray)
            
            if chatStore.isDoneFetch {
                // 채팅방 목록 리스트
                ForEach(chatStore.targetUserNames.indices, id: \.self) { i in
                    
                    NavigationLink {
                        ChatRoomView(chat: chatStore.chats[i],
                                     targetName: chatStore.targetUserNames[i])
                    } label: {
                        ChatListCell(chat: chatStore.chats[i],
                                     targetUserID: chatStore.targetUserNames[i])
                            .foregroundColor(.black)
                    }
                }
            } else {
                ForEach(0..<5, id: \.self) { i in
                    ChatListSkeletonCell()
                }
            }
        }
        .task{
            await chatStore.fetchChats()
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
