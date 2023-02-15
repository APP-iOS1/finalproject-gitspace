//
//  ChatDetailView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

// MARK: -View : 채팅방 뷰
struct ChatRoomView: View {
    
    enum MakeChatCase {
        case addContent
        case zeroMessageAfterDeleteLastMessage
        case remainMessageAfterDeleteLastMessage
        case enterChatRoom
    }
    
    let chat: Chat
    let targetUserName: String
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var messageStore: MessageStore
    @EnvironmentObject var userStore: UserStore
    @State var isShowingUpdateCell: Bool = false
    @State private var contentField: String = ""
    
    var body: some View {
        
        VStack {
            // 채팅 메세지 스크롤 뷰
            ScrollViewReader { proxy in
                ScrollView {
                    
                    TopperProfileView()
                    
                    Divider()
                        .padding(.vertical, 20)
                    
                    ChatDetailKnockSection(chat: chat)
                    
                    messageCells
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                    
                    Text("")
                        .id("bottom")
                    
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        proxy.scrollTo("bottom", anchor: .bottomTrailing)
                        print(chat.unreadMessageCount)
                    }
                }
                .onChange(of: messageStore.isMessageAdded) { state in
                    proxy.scrollTo("bottom", anchor: .bottomTrailing)
                }
            }
            
            Divider()
                .padding(.vertical, -8)
            
            // 메세지 입력 필드
            typeContentField
                .padding(.vertical, -3)
                .padding(.horizontal, 15)
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                HStack(spacing: 15) {
                    ProfileAsyncImage(size: 25)
                    Text(targetUserName)
                        .bold()
                        .padding(.horizontal, -8)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    makeChatRoomInfoViewToolbarItem()
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(.primary)
                }
            }
        }
        .task {
            messageStore.addListener(chatID: chat.id)
            await messageStore.fetchMessages(chatID: chat.id)
            let enteredChat = await makeChat(makeChatCase: .enterChatRoom,
                                             deletedMessage: nil)
            await chatStore.updateChat(enteredChat)
        }
        .onDisappear {
            Task {
                // FIXME: 채팅방에 있는 상태에서 신규 메세지를 받았을 때, ChatList에서 이미 읽어진 것으로 처리하기 위한 임시 코드 -> 최종적으로는 Message Listener에 구현해서 실제로 채팅방 안에서 메세지를 받을 때를 인식해야 함 By. 태영
                let exitChat = await makeChat(makeChatCase: .enterChatRoom,
                                              deletedMessage: nil)
                await chatStore.updateChat(exitChat)
                messageStore.removeListener()
            }
            
        }
    }
    
    // MARK: View : message cells ForEach문
    private var messageCells: some View {
        ForEach(messageStore.messages) { message in
            MessageCell(message: message, targetName: targetUserName)
                .padding(.vertical, -5)
                .contextMenu {
                    Button {
                        Task {
                            await deleteContent(message: message)
                        }
                    } label: {
                        Text("Delete Message")
                        Image(systemName: "trash")
                    }
                }
        }
    }
    
    // MARK: Section : 메세지 입력
    private var typeContentField : some View {
        HStack(spacing: 10) {
            Button {
                print("이미지 첨부 버튼 탭")
            } label: {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 30)
            }
            Button {
                print("레포지토리 선택 버튼 탭")
            } label: {
                Image("RepositoryIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 23)
            }
            
            GSTextEditor.CustomTextEditorView(style: .message, text: $contentField)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onSubmit {
                    guard contentField.isEmpty == false else {
                        return
                    }
                    Task {
                        await addContent()
                    }
                }
            
//            TextField("Enter Message",text: $contentField)
//                .textFieldStyle(.roundedBorder)
//                .textInputAutocapitalization(.never)
//                .disableAutocorrection(true)
//                .onSubmit {
//                    guard contentField.isEmpty == false else {
//                        return
//                    }
//                    Task {
//                        await addContent()
//                    }
//                }
            
            addContentButton
                .disabled(contentField.isEmpty)
        }
        .foregroundColor(.primary)
    }
    
    // MARK: Button : 메세지 추가(보내기)
    private var addContentButton : some View {
        Button {
            Task {
                await addContent()
            }
        } label: {
            Image(systemName: contentField.isEmpty ? "paperplane" : "paperplane.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundColor(contentField.isEmpty ? .gsGray2 : .primary)
        }
    }
    
    // MARK: -Methods
    // MARK: Method - 메세지 전송에 대한 DB Create와 Update를 처리하는 함수
    private func addContent() async {
        // MARK: Logic : 메세지 전송 버튼 입력 시 일련의 로직 수행
        /// 새 메세지 셀 생성
        /// 채팅방 입장 시 가져온 Chat으로 새 Chat 생성 + 이번에 입력한 메세지 내용과 입력 시간으로 업데이트
        /// DB 메세지 Collection에 추가, Chat Collection에서 기존 Chat 업데이트
        /// 메세지 입력 필드 공백으로 초기화
        let newMessage = makeMessage()
        let newChat = await makeChat(makeChatCase: .addContent, deletedMessage: nil)
        messageStore.addMessage(newMessage, chatID: chat.id)
        await chatStore.updateChat(newChat)
        contentField = ""
    }
    
    // MARK: Method - Chat의 lastContent를 업데이트하는 함수
    private func updateChatWithLastMessage(deletedMessage: Message) async {
        let isLastMessage = messageStore.messages.last?.id == deletedMessage.id
        if isLastMessage {
            // 삭제 메세지가 유일한 메세지였으면, Chat의 lastContent를 노크 메세지로 변경
            if messageStore.messages.count < 2 {
                let newChat = await makeChat(makeChatCase: .zeroMessageAfterDeleteLastMessage,
                                             deletedMessage: deletedMessage)
                await chatStore.updateChat(newChat)
            } else {
                // 삭제 후에도 메세지가 있으면, 마지막 메세지 직전 메세지의 내용을 Chat의 lastContent로 업데이트
                let newChat = await makeChat(makeChatCase: .remainMessageAfterDeleteLastMessage,
                                             deletedMessage: deletedMessage)
                await chatStore.updateChat(newChat)
            }
        }
    }
    
    // MARK: Method - 메세지 삭제에 대해 DB에 Chat과 Message를 반영하는 함수
    private func deleteContent(message: Message) async {
        await updateChatWithLastMessage(deletedMessage: message)
        await messageStore.removeMessage(message,
                                         chatID: chat.id)
    }
    
    // MARK: Method : Chat 인스턴스를 만들어서 반환하는 함수
    private func makeChat(makeChatCase: MakeChatCase, deletedMessage: Message?) async -> Chat {
        
        // FIXME: 메세지 삭제 시 안 읽은 메세지면 unread 갯수를 지우는 코드 -> 삭제 순서에 따라 작동 여부가 달라서 디버깅 필요! By. 태영
        let newChat: Chat
        // 현재 기준으로 DB에서 안 읽은 메세지 갯수 dictionary를 가져옴
        var newDict: [String : Int] = await chatStore.getUnreadMessageDictionary(chatID: chat.id) ?? [:]
        // 상대방의 안 읽은 메세지 갯수
        let unreadMessageCount = newDict[chat.targetUserID] ?? 1
        // 메세지 배열의 마지막 인덱스 넘버
        let endIndex = messageStore.messages.endIndex - 1
        // 안 읽은 메세지의 index 범위 (시작, 종료)
        let unreadMessagesIndex: (start: Int, end: Int) = (endIndex - unreadMessageCount, endIndex)
        // 삭제 메세지가 상대방이 아직 안 읽은 메세지 범위에 포함되는 메세지인지 여부
        let isContainUnreadMessages: Bool = messageStore.messages[unreadMessagesIndex.start...unreadMessagesIndex.end]
            .map{$0.id}
            .contains(deletedMessage?.id)
        // 삭제 메세지가 상대방이 안 읽은 메세지에 포함되면 안 읽은 갯수 1 감소
        if isContainUnreadMessages {
            newDict[chat.targetUserID, default: 0] -= 1
        }
        
        switch makeChatCase {
            
        case .addContent:
            
            newDict[chat.targetUserID, default : 0] += 1
            
            newChat = Chat(id: chat.id,
                           createdDate: chat.createdDate,
                           joinedMemberIDs: chat.joinedMemberIDs,
                           lastContent: contentField,
                           lastContentDate: Date.now,
                           knockContent: chat.knockContent,
                           knockContentDate: chat.knockContentDate,
                           unreadMessageCount: newDict)
            
        case .zeroMessageAfterDeleteLastMessage:
                        
            // FIXME: 메세지 삭제 로직에도 안 읽은 메세지 -= 1 로직 구현 필요
            newChat = Chat.init(id: chat.id,
                                createdDate: chat.createdDate,
                                joinedMemberIDs: chat.joinedMemberIDs,
                                lastContent: chat.knockContent,
                                lastContentDate: chat.knockContentDate,
                                knockContent: chat.knockContent,
                                knockContentDate: chat.knockContentDate,
                                unreadMessageCount: newDict)
            
        case .remainMessageAfterDeleteLastMessage:
            let endIndex = messageStore.messages.endIndex
            let preLastMessage = messageStore.messages[endIndex-2]
            
            newChat = Chat.init(id: chat.id,
                                createdDate: chat.createdDate,
                                joinedMemberIDs: chat.joinedMemberIDs,
                                lastContent: preLastMessage.textContent,
                                lastContentDate: preLastMessage.sentDate,
                                knockContent: chat.knockContent,
                                knockContentDate: chat.knockContentDate,
                                unreadMessageCount: newDict)
            
        case .enterChatRoom:
            var newDict: [String : Int] = chat.unreadMessageCount
            if let uid = userStore.user?.id {
                newDict[uid] = 0
            }
            newChat = Chat.init(id: chat.id,
                                createdDate: chat.createdDate,
                                joinedMemberIDs: chat.joinedMemberIDs,
                                lastContent: chat.lastContent,
                                lastContentDate: chat.lastContentDate,
                                knockContent: chat.knockContent,
                                knockContentDate: chat.knockContentDate,
                                unreadMessageCount: newDict)
        }
        
        return newChat
    }
    
    // MARK: Method : Message 인스턴스를 만들어서 반환하는 함수
    private func makeMessage() -> Message {
        
        let newMessage = Message.init(id: UUID().uuidString,
                                      senderID: Utility.loginUserID,
                                      textContent: contentField,
                                      imageContent: nil,
                                      sentDate: Date.now,
                                      isRead: false)
        return newMessage
    }
    
    @ViewBuilder
    private func makeChatRoomInfoViewToolbarItem() -> some View {
        // MARK: Logic
        /// 1. Published user 객체가 있는지 검사
        /// 2. ChatRoom Notification 딕셔너리가 UserDefault에 있는지 검사
        /// 2-1. 없으면 최초 생성
        /// 3. 딕셔너리에 chatID로 접근해서 해당 채팅방 알림 수신 여부 Bool 값을 받아옴 (한번도 Chat Info에서 세팅한적이 없으면 true로 고정)
        /// 4. user의 차단 유저 리스트에 채팅 대화 상대방 ID가 있는지 여부 검사
        /// 5. 1~4에서 받아온 정보를 통해서 채팅방 상세 설정 뷰로 이동
        // 1
        if let user = userStore.user {
            let chatRoomNotificationKey = Constant.AppStorageConst.CHATROOM_NOTIFICATION
            let isNotificationReceiveEnableDict = UserDefaults().dictionary(forKey: chatRoomNotificationKey)
            // 2
            if isNotificationReceiveEnableDict == nil {
                // 2-1
                let _ = UserDefaults().set([:], forKey: chatRoomNotificationKey)
            }
            
            if let isNotificationReceiveEnableDict {
                // 3
                let isNotificationReceiveEnable: Bool? = isNotificationReceiveEnableDict[chat.id] as? Bool ?? true
                // 4
                let isChatBlocked: Bool = user.blockedUserIDs.contains(chat.targetUserID)
                // 5
                ChatRoomInfoView(chat: chat,
                                 targetUserName: targetUserName,
                                 isBlocked: isChatBlocked,
                                 isNotificationReceiveEnable: isNotificationReceiveEnable ?? true)
            }
        }
    }
    
}

/// 챗을 만들어서 업데이트 챗을 하는데, 마지막 메세지 시간이랑 내용을 가져와야함
/// 지우는 메세지가 마지막 메세지인지 분기처리를 해야함
