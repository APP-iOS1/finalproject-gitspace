import SwiftUI

//TODO: -  으니의 피드백
/// 1. GSText들 디자인 시스템으로 변경
/// 2. 안읽은 메시지 띄워주는 캡슐 및 텍스트의 글씨가 조금 크다. 텍스트는 caption2의 크기로 맞추기 -> 완료
/// 3. 메시지 셀의 크기가 좀 크다. 메시지 셀의 높이와 아이디-메시지 내용 사이의 간격 모두 90%정도로 줄여도 될 듯. -> 완료
/// 4. 이미지 크기를 추천 카드의 이미지 크기에 맞춰서 조금 줄여도 될 듯. 

struct ChatListSection: View {    
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var tabBarRouter: GSTabBarRouter
    @Binding var chatID: String?
    @State private var pushedChat: Chat? = nil
    
    var body: some View {
        // MARK: -Constant : 채팅방 리스트를 최근순으로 정렬한 리스트
        VStack(alignment: .leading) {
            HStack {
                GSText.CustomTextView(style: .sectionTitle, string: "My Chats")
                Spacer()
            }
            .padding(.top, 3)
            
            if chatStore.isDoneFetch {
                // 채팅방 목록 리스트
                ForEach(chatStore.chats) { chat in
                    
                    if let targetUserName = chatStore.targetNameDict[chat.id] {
                        NavigationLink {
                            ChatRoomView(chat: chat, targetUserName: targetUserName)
                        } label: {
                            ChatListCell(chat: chat, targetUserName: targetUserName)
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
        .padding(.horizontal, 20)
        .overlay {
            NavigationLink(
                destination: ChatRoomView(
                    chat: pushedChat
                    ?? .init(id: "", createdDate: .now, joinedMemberIDs: [""], lastContent: "", lastContentDate: .now, knockContent: "", knockContentDate: .now, unreadMessageCount: ["":0]), targetUserName: ""),
                isActive: $tabBarRouter.navigateToChat) {
                    EmptyView()
                }
        }
        .task {
            if !chatStore.isDoneFetch {
                chatStore.addListener()
                await chatStore.fetchChats()
            }
            await userStore.requestUser(userID: Utility.loginUserID)
        }
        .task {
            // !!!: NAVIGATE TO PUSHED CHAT
            if let chatID,
               !tabBarRouter.navigateToChat {
                async let fetchDone = chatStore.requestPushedChat(chatID: chatID)
                pushedChat = await fetchDone
                tabBarRouter.navigateToChat.toggle()
            }
        }
    }
}
