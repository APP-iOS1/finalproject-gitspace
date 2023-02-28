import SwiftUI
import FirebaseAuth

struct ChatListSection: View {    
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var userStore: UserStore
	@EnvironmentObject var tabBarRouter: GSTabBarRouter
	
	@Binding var chatID: String
	@State private var pushedChat: Chat? = nil
    
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
		.overlay {
			NavigationLink(
				destination: ChatRoomView(
					chat: pushedChat
					?? .init(id: "", createdDate: .now, joinedMemberIDs: [""], lastContent: "", lastContentDate: .now, knockContent: "", knockContentDate: .now, unreadMessageCount: ["":0]), targetUserName: "")
				,
				isActive: $tabBarRouter.navigateToChat) {
					EmptyView()
				}
		}
        .task {
			if !chatStore.isDoneFetch {
                chatStore.addListener()
                await chatStore.fetchChats()
            }
			print(#function, "++++++", Utility.loginUserID)
            await userStore.requestUser(userID: Utility.loginUserID)
        }
		.task {
			// !!!: NAVIGATE TO PUSHED CHAT
			if !tabBarRouter.navigateToChat {
				print(#function, "+++++", chatID)
				async let fetchDone = chatStore.requestPushedChat(chatID: chatID)
				pushedChat = await fetchDone
				print(#function, "+++++", pushedChat?.id ?? "")
				tabBarRouter.navigateToChat.toggle()
			}
		}
    }
}
//
//struct ChatListSection_Previews: PreviewProvider {
//    static var previews: some View {
//		ChatListSection(chatID: .constant(""))
//            .environmentObject(ChatStore())
//            .environmentObject(UserStore())
//    }
//}
