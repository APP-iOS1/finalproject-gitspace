// TODO: -해야할 거
/// 1. snapshotListener에서 단일로 Cell을 추가하거나 삭제하는 것이 가능한지
/// 2. 업데이트 된 단일 Cell이 View에 반영되는지
/// 3. remove할 때 인덱스 번호로 찾아가서 걔만 지울 수 있는지
///
// TODO: 채팅 관련 작업
// 1. 채팅방 전역으로 알림 띄우기 : 쥬니네 FCM 기술연구 후에..
// 2. ScrollView == 카카오톡
// 3. 채팅방 데이터 추가하고 채팅 리스트 Listener 테스트하기 : 완~

// MEMO: Chat List Listener 단일 패치와 노크 승인 시점에 대한 논의
/// 1. 노크 승인에 의해 새로운 채팅방이 개설되었을 때, .added에 의해서 해당 채팅방 하나만 로컬 배열에 추가하고, 로컬에서 정렬한다.
/// 2. lastContent가 변경되었을 때, .modified에 의해 로컬에서 해당 Chat 모델의 lastContent를 업데이트 하고, 로컬에서 정렬한다.
/// 3. 채팅방이 있고 메세지가 0개일 때, 노크 메세지를 채팅방 Cell에 띄울 수 있는 방법을 논의해야함
/// 3-1. Knock 쪽에서 승인 시점에 Knock 메세지를 Chat 모델 lastContent에 업데이트 해주는 방법
/// 3-2. lastContent가 ""일 때 혹은 메세지 배열이 empty일 때, knock message를 View에서 표시

// TODO: 230210 기준 남은 작업 리스트
/// 1. ChatRoomInfoView 구현 [완료]
/// 2. Chat Listener 관련 메서드 구현 및 뷰 연결 [완료]
/// 3. remove에 대한 lastContent 업데이트 분기 처리 [완료]
/// 4. ScrollView Reader 완성 [진행 중]
///     4-1 상단 끝에 닿았을 때 fetch
///     4-2 현재 위치 읽어서 자동 스크롤링 처리
///     4-3 이전 메세지 읽고 있으면 하단에 팝업 띄워주기
///     4-4 안 읽은 메세지에서 스크롤 위치 시작하게 하는 거
/// 5. 메세지 인앱 알림 처리 [승준 FCM 구현으로 완료]
/// 6. TextEditor 로직 구현 + 이미지 디자인 시스템 구현 (영이꺼) [완료]
/// 7. 안읽은 메시지 (리스트에선 갯수, chat room에선 스크롤 시작 위치) [완료]
/// 8. Github API 프로필 Image 캐시 처리 [완료]
/// 9. UserInfo 모델링 + Github OAuth 로직 연결 [완료]
/// 10. Github User - Firebase UserInfo 병합 [완료]

// TODO: 공통 작업
/// 1. 스유 컴포넌트 -> 디자인 시스템 적용
/// 2. 고정값 String -> 전역 상수 교체
/// 3. Chat관련 ViewModel 메서드 정리
/// 4. 데이터 모델링 회의 내용 반영 [완료]

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ChatStore: ObservableObject {
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    private let const = Constant.FirestorePathConst.self
	
    var targetUserInfoDict: [String: UserInfo]
    
	@Published var newChat: Chat
    @Published var chats: [Chat]
    @Published var isDoneFetch: Bool // 스켈레톤 UI 종료 + 패치를 한 번만 수행하기 위한 변수
    
    init() {
        targetUserInfoDict = [:]
        chats = []
        isDoneFetch = false
        newChat = Chat.emptyChat()
		targetUserInfoDict = [:]
    }
    
}

// MARK: -Extension : Chat Listener 관련 메서드를 모아둔 익스텐션
extension ChatStore {
    
    // MARK: Method : chat 리스트를 마지막 메세지 시간 최신순으로 정렬
    private func sortChats() {
        chats.sort {
            $0.lastContentDate > $1.lastContentDate
        }
    }
    
    // MARK: Method : 추가된 문서 필드에 접근하여 Chat 객체를 만들어 반환하는 메서드
    private func decodeNewChat(change: QueryDocumentSnapshot) -> Chat? {
        do {
            let newChat = try change.data(as: Chat.self)
            return newChat
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
        return nil
    }
    
    // MARK: Chat Listener에서 Added가 감지되었을 때, Chat을 로컬 Chat 리스트에 추가하고 재정렬하는 메서드
    private func listenerAddChat(change: QueryDocumentSnapshot) async {
        let newChat = decodeNewChat(change: change)
        
        if
            let newChat,
            let targetUserInfo = await UserStore.requestAndReturnUser(userID: newChat.targetUserID) {
            targetUserInfoDict[newChat.id] = targetUserInfo
            await appendAndSortChats(newChat: newChat)
        }
    }
    
    @MainActor
    private func appendAndSortChats(newChat: Chat) {
        chats.append(newChat)
        sortChats()
    }
    
    // MARK: 새로운 메시지가 추가되었을 때 lastContent 등 업데이트 시키고 채팅방 재정렬.
    /// 변경을 감지해서 lastContent를 뽑아서 로컬 배열에서 채팅방을 찾으러 감(채팅방 ID 필요)
    /// 그 배열에서 해당 채팅방의 lastContent를 수정
    private func updateLocalChat(change: QueryDocumentSnapshot) {
        guard let index = chats.firstIndex(where: { $0.id == change.documentID}) else {
            return
        }
        let newChat = decodeNewChat(change: change)
        if let newChat {
            chats[index] = newChat
        }
    }
    
    private func listenerUpdateChat(change: QueryDocumentSnapshot) {
        updateLocalChat(change: change)
        sortChats()
    }
    
    //TODO: API에서 async await concurrency 지원하는지 여부 파악
    func addListener() {
        listener = db
            .collection(const.COLLECTION_CHAT)
            .whereField(const.FIELD_JOINED_MEMBER_IDS, arrayContains: Utility.loginUserID)
            .addSnapshotListener { snapshot, error in
                
                guard let snapshot else { return }
                
                snapshot.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        if self.isDoneFetch {
                            Task {
                                await self.listenerAddChat(change: diff.document)
                            }
                        }
                    case .modified:
                        self.listenerUpdateChat(change: diff.document)
                    case .removed:
                        let _ = 1
                    }
                }
            }
    }
    
    func removeListener() {
        guard let listener else {
            return
        }
        listener.remove()
    }
}

// MARK: -Extension : Chat CRUD 관련 메서드를 모아둔 익스텐션
extension ChatStore {
    
    // MARK: -Methods
    // MARK: Method - Chat Documents
    private func getChatDocuments() async -> QuerySnapshot? {
        do {
            let snapshot = try await db
                .collection(const.COLLECTION_CHAT)
                .whereField(const.FIELD_JOINED_MEMBER_IDS,
                            arrayContains: Utility.loginUserID)
                .order(by: const.FIELD_LAST_CONTENT_DATE,
                       descending: true)
                .getDocuments()
            return snapshot
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
        return nil
    }
    
    @MainActor
    private func writeChats(chats: [Chat]) {
        self.chats = chats
        self.isDoneFetch = true
    }
    
    func fetchChats() async {
        let snapshot = await getChatDocuments()
        // MARK: Memo - 함수 내부 배열에 추가 -> Published에 덮어쓰기 로직으로 removeAll 없이 정상 작동함 by.태영
        var newChats: [Chat] = []
        
        if let snapshot {
            for document in snapshot.documents {
                do {
                    let chat: Chat = try document.data(as: Chat.self)
                    if let targetUserInfo = await UserStore.requestAndReturnUser(userID: chat.targetUserID) {
                        newChats.append(chat)
                        targetUserInfoDict[chat.id] = targetUserInfo
                    }
                } catch {
                    print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
                }
            }
        }

        await writeChats(chats: newChats)
    }
	
	// MARK: - PUSHED CHAT GENERATOR
	public func requestPushedChat(chatID: String) async -> Chat? {
        let doc = db.collection(const.COLLECTION_CHAT).document(chatID)
		do {
			let pushedChat = try await doc.getDocument(as: Chat.self)
            // FIXME: Chat의 targetUserName을 사용하지 않기 위해 UserStore의 UserInfo 요청 메서드 구현. 해당 메서드로 로직 대체 By. 태영

            if let targetUserInfo = await UserStore.requestAndReturnUser(userID: pushedChat.targetUserID) {
                targetUserInfoDict[pushedChat.id] = targetUserInfo
                return pushedChat
            }
            return nil
		} catch {
			dump("DEBUG: \(#file)-\(#function): get pushed Chat FALIED")
			return nil
		}
	}
    
    // MARK: -Chat CRUD
    func addChat(_ chat: Chat) async {
        do {
            try db.collection(const.COLLECTION_CHAT)
                .document(chat.id)
                .setData(from: chat.self)
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
    }
    
    func updateChat(_ chat: Chat) async {
        do {
            try await db.collection(const.COLLECTION_CHAT)
                .document(chat.id)
                .updateData([const.FIELD_LAST_CONTENT_DATE : chat.lastContentDate,
                             const.FIELD_LAST_CONTENT : chat.lastContent,
                             const.FIELD_UNREAD_MESSAGE_COUNT : chat.unreadMessageCount])
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
    }
    
    func removeChat(_ chat: Chat) async {
        do {
            try await db.collection(const.COLLECTION_CHAT)
                .document(chat.id)
                .delete()
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
    }
    
    func getUnreadMessageDictionary(chatID: String) async -> [String : Int]? {
        do {
            let snapshot = try await db.collection(const.COLLECTION_CHAT)
                .document(chatID)
                .getDocument()
            
            if let data = snapshot.data() {
                let dict = data[const.FIELD_UNREAD_MESSAGE_COUNT] as? [String : Int] ?? ["no one" : 0]
                return dict
            }
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
        return nil
    }
}
