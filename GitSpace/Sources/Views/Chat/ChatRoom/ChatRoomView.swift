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
        case enterOrQuitChatRoom
    }

    let chat: Chat
    let targetUserInfo: UserInfo
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var messageStore: MessageStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var notificationManager: PushNotificationManager
    @EnvironmentObject var tabBarRouter: GSTabBarRouter
    @StateObject private var keyboardHandler = KeyboardHandler()
    @State private var contentField: String = ""
    @State private var unreadMessageIndex: Int?
    
    
    var body: some View {

        VStack {
            // 채팅 메세지 스크롤 뷰
            ScrollViewReader { proxy in
                ScrollView {
                    
                    TopperProfileView(targetUserInfo: targetUserInfo)
                    
                    Divider()
                        .padding(.vertical, 20)
                     
                    Spacer()
                        .frame(height: 50)
                    
                    ChatDetailKnockSection(chat: chat)
                        .padding(.bottom, 20)
                    
                    messageCells
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    
                    Text("")
                        .id("bottom")
                    
                }
                .onTapGesture {
                    self.endTextEditing()
                }
                // MEMO : 채팅방 진입 시 수행해야하는 스크롤링이지만, proxy 값이 필요하기 때문에 task에서 unreadMessageIndex 변경 -> ScrollView Reader 내부 onChange에서 작업
                .onChange(of: unreadMessageIndex) { state in
                    DispatchQueue.main.async {
                        Task {
                            if await getUnreadCount() == 0 {
                                proxy.scrollTo("bottom", anchor: .bottomTrailing)
                            } else {
                                proxy.scrollTo("Start", anchor: .top)
                            }
                        }
                    }
                }
                // 메세지를 전송했을 때 or 받았을 때 스크롤을 최하단으로 이동
                .onChange(of: messageStore.isMessageAdded) { state in
                    // 채팅방 진입 시 진행하는 첫 Request가 수행된 이후에만 반응하도록 하는 조건
                    if messageStore.isFetchMessagesDone {
                        proxy.scrollTo("bottom", anchor: .bottomTrailing)
                    }
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
                    GithubProfileImage(urlStr: targetUserInfo.avatar_url, size: 25)
                    GSText.CustomTextView(style: .title3, string: targetUserInfo.githubLogin)
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
            // 메세지 리스너 실행, 첫 Request가 이루어지기 전이기 때문에 .added에서 메세지를 추가하지 않음
            messageStore.addListener(chatID: chat.id)
            // 해당 채팅방의 메세지를 날짜순으로 정렬해서 Request
            await messageStore.fetchMessages(chatID: chat.id)
            // 유저가 읽지 않은 메세지의 시작 인덱스를 계산해서 할당
            unreadMessageIndex = await messageStore.messages.count - getUnreadCount()
            // 읽지 않은 메세지 갯수를 0으로 초기화
            await clearUnreadMessageCount()
        }
        // MessageCell ContextMenu에서 삭제 버튼을 탭하면 수행되는 로직
        .onChange(of: messageStore.deletedMessage?.id) { id in
            if let id, let deletedMessage = messageStore.messages.first(where: {$0.id == id}) {
                Task {
                    await deleteContent(message: deletedMessage)
                }
            }
        }
        .onChange(of: scenePhase) { currentPhase in
            // FIXME: inActive 혹은 backGround에 가는 것을 채팅방을 나가는것처럼 처리해줄지, 돌아올 때 채팅방에 입장한 것처럼 처리해줄지 고려 필요. By 태영
            if currentPhase == .inactive {
                Task {
                    await clearUnreadMessageCount()
                }
            }
        }
        .onDisappear {
            Task {
                await clearUnreadMessageCount()
                messageStore.removeListener()
            }
            tabBarRouter.navigateToChat = false
        }
    }
    
    // MARK: View : message cells ForEach문
    private var messageCells: some View {
        ForEach(messageStore.messages.indices, id: \.self) { index in
            
            MessageCell(message: messageStore.messages[index],
                        targetUserInfo: targetUserInfo)
                .padding(.vertical, -5)
                .id(index == unreadMessageIndex ? "Start" : "")
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
            
            addContentButton
                .disabled(contentField.isEmpty)
        }
        .padding(.bottom, 15)
        .foregroundColor(.primary)
    }

    // MARK: Button : 메세지 추가(보내기)
    private var addContentButton : some View {
        Button {
            Task {
                // 상대방의 id로 유저를 가져옵니다.
                let sentFrom = userStore.user?.githubLogin
				async let opponentUser = userStore.requestUserInfoWithID(userID: chat.targetUserID)
                
				// TODO: - PUSH NOTIFICATION 수정 필요
				// !!!: DUE TO USERINFO MODEL UPDATE
                
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
    // MARK: Method - 유저가 읽지 않은 메세지 갯수를 0으로 초기화하고 DB에 업데이트하는 함수
    private func clearUnreadMessageCount() async {
        // 채팅방에 진입한 시점까지 받은 메세지를 모두 읽음 처리한 Chat을 새로 생성 (unreadCount 딕셔너리를 0으로 초기화)
        async let enterOrQuitChat = makeChatInstance(makeChatCase: .enterOrQuitChatRoom,
                                      deletedMessage: nil,
                                      currentContent: nil)
        // 0으로 초기화된 Chat을 DB에 업데이트
        await chatStore.updateChat(enterOrQuitChat)
    }
    
    // MARK: Method - 메세지 전송에 대한 DB Create와 Update를 처리하는 함수
    private func addContent() async {
        // MARK: Logic : 메세지 전송 버튼 입력 시 일련의 로직 수행
        /// 임시 변수에 현재 메세지 입력 내용 저장
        /// 메세지 입력 필드 공백으로 초기화
        /// 새 메세지 셀 생성
        /// 채팅방 입장 시 가져온 Chat으로 새 Chat 생성 + 이번에 입력한 메세지 내용과 입력 시간으로 업데이트
        /// DB 메세지 Collection에 추가, Chat Collection에서 기존 Chat 업데이트
        let tempContent = contentField
        contentField = ""
        let newMessage = makeMessage(currentContent: tempContent)
        let newChat = await makeChatInstance(makeChatCase: .addContent,
                                     deletedMessage: nil,
                                     currentContent: tempContent)
        messageStore.addMessage(newMessage, chatID: chat.id)
        await chatStore.updateChat(newChat)
    }
    
    // MARK: Method - Chat의 lastContent를 업데이트하는 함수
    private func updateChatWithLastMessage(deletedMessage: Message) async {
        let newChat: Chat
        // 삭제 메세지가 유일한 메세지였으면, Chat의 lastContent를 노크 메세지로 변경
        if messageStore.messages.count < 2 {
            newChat = await makeChatInstance(makeChatCase: .zeroMessageAfterDeleteLastMessage,
                                     deletedMessage: deletedMessage,
                                     currentContent: nil)
        }
        // 삭제 후에도 메세지가 있으면, 마지막 메세지 직전 메세지의 내용을 Chat의 lastContent로 업데이트
        else {
            newChat = await makeChatInstance(makeChatCase: .remainMessageAfterDeleteLastMessage,
                                     deletedMessage: deletedMessage,
                                     currentContent: nil)
        }
        await chatStore.updateChat(newChat)
    }
    
    // MARK: Method - 메세지 삭제에 대해 DB에 Chat과 Message를 반영하는 함수
    private func deleteContent(message: Message) async {
        await updateChatWithLastMessage(deletedMessage: message)
        await messageStore.removeMessage(message,
                                         chatID: chat.id)
    }
    
    // MARK: Method - 상대방이 안 읽은 메세지 갯수를 반환하는 함수
    private func getUnreadCount() async -> Int {
        let dict = await chatStore.getUnreadMessageDictionary(chatID: chat.id)
        let unreadCount = dict?[Utility.loginUserID] ?? 0
        return unreadCount
    }
    
    // MARK: Method - 삭제 대상 메세지가 상대방이 안 읽은 메세지 범위에 포함되는지 여부를 체크해서 반환하는 함수
    private func checkUnreadMessagesContainDeletedMessage(deletedMessage: Message,
                                                          unreadCount: Int) -> Bool {
        // MARK: Variables - Delete Message 케이스에서만 사용하는 변수
        // 메세지 배열의 마지막 인덱스 넘버
        let endIndex: Int = messageStore.messages.endIndex
        // 안 읽은 메세지의 index 범위 (시작, 종료)
        let unreadMessagesIndex: (start: Int, end: Int) = (endIndex - unreadCount, endIndex)
        // 삭제 메세지가 상대방이 아직 안 읽은 메세지 범위에 포함되는 메세지인지 여부
        let isContainUnreadMessages: Bool = messageStore.messages[unreadMessagesIndex.start..<unreadMessagesIndex.end]
            .map{$0.id}
            .contains(deletedMessage.id)
        return isContainUnreadMessages
    }
    
    // MARK: Method : Chat 인스턴스를 만들어서 반환하는 함수
    private func makeChatInstance(makeChatCase: MakeChatCase, deletedMessage: Message?, currentContent: String?) async -> Chat {
        
        // 현재 시점의 초기화된 chat을 복사
        // switch문에서 Chat을 만드는 케이스에 따라 필요한 프로퍼티에 접근해서 수정 후 return
        var newChat: Chat = chat
        // 현재 기준으로 DB에서 안 읽은 메세지 갯수 dictionary를 가져옴
        var newUnreadMessageCountDict: [String : Int] = await chatStore.getUnreadMessageDictionary(chatID: chat.id) ?? [:]
        // 상대방의 안 읽은 메세지 갯수
        let unreadMessageCount: Int = newUnreadMessageCountDict[chat.targetUserID] ?? 1
        
        // 메세지 삭제에 대해서 Chat을 업데이트하는 케이스인 경우
        if let deletedMessage,
           makeChatCase == .zeroMessageAfterDeleteLastMessage || makeChatCase == .remainMessageAfterDeleteLastMessage {
            // 삭제 메세지가 상대방이 안 읽은 메세지에 포함되면 안 읽은 갯수 1 감소
            if checkUnreadMessagesContainDeletedMessage(deletedMessage: deletedMessage,
                                                        unreadCount: unreadMessageCount) {
                newUnreadMessageCountDict[chat.targetUserID, default: 0] -= 1
            }
        }
        
        switch makeChatCase {
        // 채팅 메세지 보내는 케이스
        // 안 읽은 메세지 갯수 + 1, 현재 텍스트필드 내용과 지금 시각으로 Chat 업데이트
        case .addContent:
            newUnreadMessageCountDict[chat.targetUserID, default : 0] += 1
            newChat.lastContent = currentContent ?? ""
            newChat.lastContentDate = .now
            newChat.unreadMessageCount = newUnreadMessageCountDict

        // 삭제 메세지가 채팅방의 첫 메세지인 케이스
        // 마지막 메세지를 노크 컨텐츠로 업데이트
        case .zeroMessageAfterDeleteLastMessage:
            newChat.lastContent = chat.knockContent
            newChat.lastContentDate = chat.knockContentDate
            newChat.unreadMessageCount = newUnreadMessageCountDict
            
        // 삭제 메세지를 포함해서 메세지가 2개 이상인 케이스
        case .remainMessageAfterDeleteLastMessage:
            let endIndex = messageStore.messages.endIndex
            let preLastMessage = messageStore.messages[endIndex-2]
            let isLastMessage = messageStore.messages.last?.id == deletedMessage?.id
            
            // 삭제 메세지가 마지막 메세지면, 이전 메세지를 Chat의 마지막 내용으로 업데이트 하고 안 읽은 메세지 갯수 업데이트
            if isLastMessage {
                newChat.lastContent = preLastMessage.textContent
                newChat.lastContentDate = preLastMessage.sentDate
                newChat.unreadMessageCount = newUnreadMessageCountDict
            }
            // 삭제 메세지가 마지막 메세지가 아니면, 기존 Chat을 유지하고 안 읽은 메세지 갯수만 업데이트
            else {
                newChat.unreadMessageCount = newUnreadMessageCountDict
            }
        
        // 채팅방 입장 시, 내가 안 읽은 메세지 갯수를 0으로 초기화하는 케이스
        case .enterOrQuitChatRoom:
            var newDict: [String : Int] = chat.unreadMessageCount
            if let uid = userStore.user?.id {
                newDict[uid] = 0
            }
            newChat.unreadMessageCount = newDict
        }
        return newChat
    }
    
    // MARK: Method : Message 인스턴스를 만들어서 반환하는 함수
    private func makeMessage(currentContent: String) -> Message {
        let newMessage = Message.init(id: UUID().uuidString,
                                      senderID: Utility.loginUserID,
                                      textContent: currentContent,
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
                                 targetUserInfo: targetUserInfo,
                                 isBlocked: isChatBlocked,
                                 isNotificationReceiveEnable: isNotificationReceiveEnable ?? true)
            }
        }
    }
}


// MARK: -NotificationCenter와 UIApplication 버전 코드 Archive
struct ChatRoomViews: View {
    
    final class BackgroundManager {
        static var isQuit: Bool = false
        
        /// 매니저의 프로퍼티 하나를 수정하는 메서드를 만든다
        /// onChange로 뷰에서 해당 프로퍼티를 감지해서 채팅방 이탈 시 수행되어야하는 로직을 수행한다.
        @objc static func toggleIsQuit() {
            print("objc 시작")
            isQuit.toggle()
            print("objc 종료")
        }
    }
    
    enum MakeChatCase {
        case addContent
        case zeroMessageAfterDeleteLastMessage
        case remainMessageAfterDeleteLastMessage
        case enterOrQuitChatRoom
    }

    let chat: Chat
    let targetUserInfo: UserInfo
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var messageStore: MessageStore
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var notificationManager: PushNotificationManager
    @EnvironmentObject var tabBarRouter: GSTabBarRouter
    @StateObject private var keyboardHandler = KeyboardHandler()
    @State private var contentField: String = ""
    @State private var unreadMessageIndex: Int?
    
    var body: some View {

        VStack {
            // 채팅 메세지 스크롤 뷰
            ScrollViewReader { proxy in
                ScrollView {
                    
                    TopperProfileView(targetUserInfo: targetUserInfo)
                    
                    Divider()
                        .padding(.vertical, 20)
                     
                    Spacer()
                        .frame(height: 50)
                    
                    ChatDetailKnockSection(chat: chat)
                        .padding(.bottom, 20)
                    
                    messageCells
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    
                    Text("")
                        .id("bottom")
                    
                }
                .onTapGesture {
                    self.endTextEditing()
                }
                // MEMO : 채팅방 진입 시 수행해야하는 스크롤링이지만, proxy 값이 필요하기 때문에 task에서 unreadMessageIndex 변경 -> ScrollView Reader 내부 onChange에서 작업
                .onChange(of: unreadMessageIndex) { state in
                    DispatchQueue.main.async {
                        Task {
                            if await getUnreadCount() == 0 {
                                proxy.scrollTo("bottom", anchor: .bottomTrailing)
                            } else {
                                proxy.scrollTo("Start", anchor: .top)
                            }
                        }
                    }
                    
                }
                .onChange(of: messageStore.isMessageAdded) { state in
                    // 채팅방 진입 시 진행하는 첫 Request가 수행된 이후에만 반응하도록 하는 조건
                    if messageStore.isFetchMessagesDone {
                        proxy.scrollTo("bottom", anchor: .bottomTrailing)
                    }
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
                    GithubProfileImage(urlStr: targetUserInfo.avatar_url, size: 25)
                    GSText.CustomTextView(style: .title3, string: targetUserInfo.githubLogin)
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
            // 메세지 리스너 실행, 첫 Request가 이루어지기 전이기 때문에 .added에서 메세지를 추가하지 않음
            messageStore.addListener(chatID: chat.id)
            // 해당 채팅방의 메세지를 날짜순으로 정렬해서 Request
            await messageStore.fetchMessages(chatID: chat.id)
            // 유저가 읽지 않은 메세지의 시작 인덱스를 계산해서 할당
            unreadMessageIndex = await messageStore.messages.count - getUnreadCount()
            // 채팅방에 진입한 시점까지 받은 메세지를 모두 읽음 처리한 Chat을 새로 생성 (unreadCount 딕셔너리를 0으로 초기화)
            async let enteredChat = makeChat(makeChatCase: .enterOrQuitChatRoom,
                                             deletedMessage: nil,
                                             currentContent: nil)
            // 0으로 초기화된 Chat을 DB에 업데이트
            await chatStore.updateChat(enteredChat)
            // FIXME: 현재 기준으로 백그라운드 진입 시 해당 selector 메서드가 호출되지 않음. 직접 post 해도 호출되지 않는 부분까지 포함해서 수정 필요. By 태영
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(BackgroundManager.toggleIsQuit),
                                                   name: UIApplication.didEnterBackgroundNotification,
                                                   object: nil)
        }
        // MessageCell ContextMenu에서 삭제 버튼을 탭하면 수행되는 로직
        .onChange(of: messageStore.deletedMessage?.id) { id in
            if let id, let deletedMessage = messageStore.messages.first(where: {$0.id == id}) {
                Task {
                    await deleteContent(message: deletedMessage)
                }
            }
        }
        .task(id: BackgroundManager.isQuit) {
            print("백그라운드 시작")
            NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification,
                                            object: nil)
            await clearUnreadMessageCount()
            print("백그라운드 종료")
        }
        .onDisappear {
            Task {
                await clearUnreadMessageCount()
                messageStore.removeListener()
            }
            
            tabBarRouter.navigateToChat = false
        }
    }
    
    // MARK: View : message cells ForEach문
    private var messageCells: some View {
        ForEach(messageStore.messages.indices, id: \.self) { index in
            
            MessageCell(message: messageStore.messages[index],
                        targetUserInfo: targetUserInfo)
                .padding(.vertical, -5)
                .id(index == unreadMessageIndex ? "Start" : "")
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
            
            addContentButton
                .disabled(contentField.isEmpty)
        }
        .padding(.bottom, 15)
        .foregroundColor(.primary)
    }
    
    // MARK: Button : 메세지 추가(보내기)
    private var addContentButton : some View {
        Button {
            Task {
                // 상대방의 id로 유저를 가져옵니다.
                let sentFrom = userStore.user?.githubLogin
                async let opponentUser = userStore.requestUserInfoWithID(userID: chat.targetUserID)
                
                // TODO: - PUSH NOTIFICATION 수정 필요
                // !!!: DUE TO USERINFO MODEL UPDATE
                
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
    
    private func clearUnreadMessageCount() async {
        async let quittedChat = makeChat(makeChatCase: .enterOrQuitChatRoom,
                                      deletedMessage: nil,
                                      currentContent: nil)
        await chatStore.updateChat(quittedChat)
    }
    
    
    // MARK: Method - 메세지 전송에 대한 DB Create와 Update를 처리하는 함수
    private func addContent() async {
        // MARK: Logic : 메세지 전송 버튼 입력 시 일련의 로직 수행
        /// 임시 변수에 현재 메세지 입력 내용 저장
        /// 메세지 입력 필드 공백으로 초기화
        /// 새 메세지 셀 생성
        /// 채팅방 입장 시 가져온 Chat으로 새 Chat 생성 + 이번에 입력한 메세지 내용과 입력 시간으로 업데이트
        /// DB 메세지 Collection에 추가, Chat Collection에서 기존 Chat 업데이트
        let tempContent = contentField
        contentField = ""
        let newMessage = makeMessage(currentContent: tempContent)
        let newChat = await makeChat(makeChatCase: .addContent,
                                     deletedMessage: nil,
                                     currentContent: tempContent)
        messageStore.addMessage(newMessage, chatID: chat.id)
        await chatStore.updateChat(newChat)
    }
    
    // MARK: Method - Chat의 lastContent를 업데이트하는 함수
    private func updateChatWithLastMessage(deletedMessage: Message) async {
        let newChat: Chat
        // 삭제 메세지가 유일한 메세지였으면, Chat의 lastContent를 노크 메세지로 변경
        if messageStore.messages.count < 2 {
            newChat = await makeChat(makeChatCase: .zeroMessageAfterDeleteLastMessage,
                                     deletedMessage: deletedMessage,
                                     currentContent: nil)
        }
        // 삭제 후에도 메세지가 있으면, 마지막 메세지 직전 메세지의 내용을 Chat의 lastContent로 업데이트
        else {
            newChat = await makeChat(makeChatCase: .remainMessageAfterDeleteLastMessage,
                                     deletedMessage: deletedMessage,
                                     currentContent: nil)
        }
        await chatStore.updateChat(newChat)
    }
    
    // MARK: Method - 메세지 삭제에 대해 DB에 Chat과 Message를 반영하는 함수
    private func deleteContent(message: Message) async {
        await updateChatWithLastMessage(deletedMessage: message)
        await messageStore.removeMessage(message,
                                         chatID: chat.id)
    }
    
    // MARK: Method - 상대방이 안 읽은 메세지 갯수를 반환하는 함수
    private func getUnreadCount() async -> Int {
        let dict = await chatStore.getUnreadMessageDictionary(chatID: chat.id)
        let unreadCount = dict?[Utility.loginUserID] ?? 0
        return unreadCount
    }
    
    // MARK: Method - 삭제 대상 메세지가 상대방이 안 읽은 메세지 범위에 포함되는지 여부를 체크해서 반환하는 함수
    private func checkUnreadMessagesContainDeletedMessage(deletedMessage: Message,
                                                          unreadCount: Int) -> Bool {
        // MARK: Variables - Delete Message 케이스에서만 사용하는 변수
        // 메세지 배열의 마지막 인덱스 넘버
        let endIndex: Int = messageStore.messages.endIndex
        // 안 읽은 메세지의 index 범위 (시작, 종료)
        let unreadMessagesIndex: (start: Int, end: Int) = (endIndex - unreadCount, endIndex)
        // 삭제 메세지가 상대방이 아직 안 읽은 메세지 범위에 포함되는 메세지인지 여부
        let isContainUnreadMessages: Bool = messageStore.messages[unreadMessagesIndex.start..<unreadMessagesIndex.end]
            .map{$0.id}
            .contains(deletedMessage.id)
        return isContainUnreadMessages
    }
    
    // MARK: Method : Chat 인스턴스를 만들어서 반환하는 함수
    private func makeChat(makeChatCase: MakeChatCase, deletedMessage: Message?, currentContent: String?) async -> Chat {
        
        // 현재 시점의 초기화된 chat을 복사
        // switch문에서 Chat을 만드는 케이스에 따라 필요한 프로퍼티에 접근해서 수정 후 return
        var newChat: Chat = chat
        // 현재 기준으로 DB에서 안 읽은 메세지 갯수 dictionary를 가져옴
        var newUnreadMessageCountDict: [String : Int] = await chatStore.getUnreadMessageDictionary(chatID: chat.id) ?? [:]
        // 상대방의 안 읽은 메세지 갯수
        let unreadMessageCount: Int = newUnreadMessageCountDict[chat.targetUserID] ?? 1
        
        // 메세지 삭제에 대해서 Chat을 업데이트하는 케이스인 경우
        if let deletedMessage,
           makeChatCase == .zeroMessageAfterDeleteLastMessage || makeChatCase == .remainMessageAfterDeleteLastMessage {
            // 삭제 메세지가 상대방이 안 읽은 메세지에 포함되면 안 읽은 갯수 1 감소
            if checkUnreadMessagesContainDeletedMessage(deletedMessage: deletedMessage,
                                                        unreadCount: unreadMessageCount) {
                newUnreadMessageCountDict[chat.targetUserID, default: 0] -= 1
            }
        }
        
        switch makeChatCase {
            
        // 채팅 메세지 보내는 케이스
        // 안 읽은 메세지 갯수 + 1, 현재 텍스트필드 내용과 지금 시각으로 Chat 업데이트
        case .addContent:
            newUnreadMessageCountDict[chat.targetUserID, default : 0] += 1
            newChat.lastContent = currentContent ?? ""
            newChat.lastContentDate = .now
            newChat.unreadMessageCount = newUnreadMessageCountDict

        // 삭제 메세지가 채팅방의 첫 메세지인 케이스
        // 마지막 메세지를 노크 컨텐츠로 업데이트
        case .zeroMessageAfterDeleteLastMessage:
            newChat.lastContent = chat.knockContent
            newChat.lastContentDate = chat.knockContentDate
            newChat.unreadMessageCount = newUnreadMessageCountDict
            
            
        // 삭제 메세지를 포함해서 메세지가 2개 이상인 케이스
        case .remainMessageAfterDeleteLastMessage:
            let endIndex = messageStore.messages.endIndex
            let preLastMessage = messageStore.messages[endIndex-2]
            let isLastMessage = messageStore.messages.last?.id == deletedMessage?.id
            
            // 삭제 메세지가 마지막 메세지면, 이전 메세지를 Chat의 마지막 내용으로 업데이트 하고 안 읽은 메세지 갯수 업데이트
            if isLastMessage {
                newChat.lastContent = preLastMessage.textContent
                newChat.lastContentDate = preLastMessage.sentDate
                newChat.unreadMessageCount = newUnreadMessageCountDict
            }
            // 삭제 메세지가 마지막 메세지가 아니면, 기존 Chat을 유지하고 안 읽은 메세지 갯수만 업데이트
            else {
                newChat.unreadMessageCount = newUnreadMessageCountDict
            }
        
        // 채팅방 입장 시, 내가 안 읽은 메세지 갯수를 0으로 초기화하는 케이스
        case .enterOrQuitChatRoom:
            var newDict: [String : Int] = chat.unreadMessageCount
            if let uid = userStore.user?.id {
                newDict[uid] = 0
            }
            newChat.unreadMessageCount = newDict
        }
        return newChat
    }
    
    // MARK: Method : Message 인스턴스를 만들어서 반환하는 함수
    private func makeMessage(currentContent: String) -> Message {
        let newMessage = Message.init(id: UUID().uuidString,
                                      senderID: Utility.loginUserID,
                                      textContent: currentContent,
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
                                 targetUserInfo: targetUserInfo,
                                 isBlocked: isChatBlocked,
                                 isNotificationReceiveEnable: isNotificationReceiveEnable ?? true)
            }
        }
    }
}

