import SwiftUI

struct ChatListSection: View {
    
    @EnvironmentObject var chatStore: ChatStore
    
    var body: some View {
        // MARK: -Constant : 채팅방 리스트를 최근순으로 정렬한 리스트
        VStack(alignment: .leading) {
            Text("My Penpals")
                .font(.footnote)
                .foregroundColor(Color.gray)
            
            // 채팅방 목록 리스트
            ForEach(chatStore.chats) { chat in
                NavigationLink {
                    ChatRoomView(chat: chat)
                } label: {
                    ListCellLabel(chat: chat)
                    .foregroundColor(.black)
                }
            }
        }
        .task{
            chatStore.fetchChats()
        }
    }
}

struct ListCellLabel : View {
    
    let chat : Chat
    @State private var targetName: String = ""
    @EnvironmentObject var userStore : UserStore
    @EnvironmentObject var chatStore: ChatStore
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                ProfileAsyncImage(size: 55)
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text("@\(targetName)")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                        .lineLimit(1)
                    
                    Text(chat.lastContent)
                        .foregroundColor(.gray)
                }
                
            }
            .frame(height: 100)
            Divider()
                .frame(width: 350)
        }
        .task {
            targetName = await chat.targetUserName
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
