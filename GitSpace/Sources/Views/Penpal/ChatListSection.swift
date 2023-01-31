import SwiftUI

struct ChatListSection: View {
    
    @EnvironmentObject var chatStore: ChatStore
    
    var body: some View {
        // MARK: -Constant : 채팅방 리스트를 최근순으로 정렬한 리스트
        ScrollView {
            // 채팅방 목록 리스트
            ForEach(chatStore.chats) { chat in
                NavigationLink {
                    ChatDetailView(chat: chat)
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
    @EnvironmentObject var userStore : UserStore
    @EnvironmentObject var chatStore: ChatStore
    
    var body: some View {
        
//        VStack(alignment: .leading) {
//            HStack(alignment: .top) {
//                VStack(alignment: .leading) {
//                    Label(userStore.targetUserName ?? "No Name", systemImage: "person.fill")
//                        .font(.title2)
//                        .padding(.bottom, 10)
//                }
//
//                Spacer()
//                // 날짜, 시간
//                VStack(alignment:.trailing) {
//                    Text(chat.stringLastDate)
//                    Text(chat.stringLastTime)
//                }
//                .font(.caption)
//                .foregroundColor(.secondary)
//            }
//
//            Divider()
//
//            // 마지막 채팅 메세지
//            Text(chat.lastContent)
//
//        }
//        .task {
//            userStore.requestTargetUserName(targetID: chat.targetID)
//        }
//        .padding()
//        .background(Color.backAccent)
//        .cornerRadius(20)
//        .padding()
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "globe.americas.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .padding(.trailing)
                
                VStack(alignment: .leading){
                    Text(chat.users.receiverID == Utility.loginUserID ? chat.users.senderID : chat.users.receiverID)
                        .font(.title2)
                        .padding(.bottom, 5)
                    Text(chat.lastContent)
                        .foregroundColor(.gray)
                }
                
            }
            Divider()
                .frame(width: 350)
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
