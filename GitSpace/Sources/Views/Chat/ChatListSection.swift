import SwiftUI

struct ChatListSection: View {
    
    @EnvironmentObject var chatStore: ChatStore
    @State var opacity: Double = 0.4
    
    var body: some View {
        // MARK: -Constant : 채팅방 리스트를 최근순으로 정렬한 리스트
        VStack(alignment: .leading) {
            Text("My Penpals")
                .font(.footnote)
                .foregroundColor(Color.gray)
            
            // 채팅방 목록 리스트
            ForEach(chatStore.chats.indices, id: \.self) { i in
                NavigationLink {
                    ChatRoomView(chat: chatStore.chats[i])
                } label: {
                    ListCellLabel(chat: chatStore.chats[i], targetUserID: chatStore.targetUserID[i])
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
    
    var chat: Chat
    var targetUserID: String
    @State private var targetName: String = ""
    @State public var isTargetName: Bool = false
    @EnvironmentObject var userStore : UserStore
    @EnvironmentObject var chatStore: ChatStore
    @State var opacity: Double = 0.4
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                ProfileAsyncImage(size: 55)
                    .padding(.trailing)
//                    .overlay(RoundedRectangle(cornerRadius: 8).fill())
//                    .overlay(Circle().fill(.gray).opacity(self.opacity))
                
                VStack(alignment: .leading) {
                    Text("@\(targetUserID)")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                        .lineLimit(1)
                        .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: !isTargetName))
                    
                    Text(chat.lastContent)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: !isTargetName))
                }
                
            }
            .frame(width: 330,height: 100, alignment: .leading)
            Divider()
                .frame(width: 350)
        }
        .task {
            targetName = await chat.targetUserName
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)){
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
            isTargetName = true
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
