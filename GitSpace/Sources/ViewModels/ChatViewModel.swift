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
/// 1. ChatRoomInfoView 구현
/// 2. remove에 대한 lastContent 업데이트 분기 처리
/// 3. ScrollView Reader 완성 (개어려움)
/// 4. 메세지 인앱 알림 처리
/// 5. TextEditor 로직 구현 + 이미지 디자인 시스템 구현 (영이꺼)
/// 6. 안읽은 메시지 (리스트에선 갯수, chat room에선 스크롤 시작 위치)

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ChatStore: ObservableObject {
    
    var targetNameDict: [String : String]
    @Published var chats: [Chat]
    @Published var isDoneFetch: Bool // 스켈레톤 UI를 종료하기 위한 변수
    @Published var isListenerModified: Bool
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    init() {
        chats = []
        targetNameDict = [:]
        isDoneFetch = false
        isListenerModified = false
    }
}

// MARK: -Extension : Chat Listener 관련 메서드를 모아둔 익스텐션
extension ChatStore {
    
    // MARK: Method : chat 리스트를 마지막 메세지 시간 최신순으로 정렬
    private func sortChats() {
        chats.sort {
            $0.lastDate > $1.lastDate
        }
    }
    
    // MARK: Method : 추가된 문서 필드에 접근하여 Chat 객체를 만들어 반환하는 메서드
    private func decodeNewChat(change: QueryDocumentSnapshot) -> Chat? {
        do {
            let newChat = try change.data(as: Chat.self)
            return newChat
        } catch {
            print("Fetch New Chat in Chat Listener Error : \(error)")
        }
        return nil
    }
    
    // MARK: Chat Listener에서 Added가 감지되었을 때, Chat을 로컬 Chat 리스트에 추가하고 재정렬하는 메서드
    private func listenerAddChat(change: QueryDocumentSnapshot) {
        let newChat = decodeNewChat(change: change)
        if let newChat {
            chats.append(newChat)
            sortChats()
        }
    }
    
    // MARK: 새로운 메시지가 추가되었을 때 lastContent 등 업데이트 시키고 채팅방 재정렬.
    /// 변경을 감지해서 lastContent를 뽑아서 로컬 배열에서 채팅방을 찾으러 감(채팅방 ID 필요)
    ///  그 배열에서 해당 채팅방의 lastContent를 수정
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
            .collection("Chat")
            .whereField("joinUserIDs", arrayContains: Utility.loginUserID)
            .addSnapshotListener { snapshot, error in
                // snapshot이 비어있으면 에러 출력 후 리턴
                guard let snp = snapshot else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                // document 변경 사항에 대해 감지해서 작업 수행
                snp.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        print("added")
                        self.listenerAddChat(change: diff.document)
                        
                    case .modified:
                        print("modified")
                        self.listenerUpdateChat(change: diff.document)
                        self.isListenerModified.toggle()
                        
                    case .removed:
                        print("removed")
                        
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
                .collection("Chat")
                .whereField("joinUserIDs", arrayContains: Utility.loginUserID)
                .order(by: "lastDate", descending: true)
                .getDocuments()
            return snapshot
        } catch {
            print("Get Chat Documents Error : \(error)")
        }
        return nil
    }
    
    
    @MainActor
    func fetchChats() async {
        let snapshot = await getChatDocuments()
        // MARK: Memo - 함수 내부 배열에 추가 -> Published에 덮어쓰기 로직으로 removeAll 없이 정상 작동함 by.태영
        var newChats: [Chat] = []
        
        if let snapshot {
            for document in snapshot.documents {
                do {
                    let chat: Chat = try document.data(as: Chat.self)
                    let targetUserName: String = await chat.targetUserName
                    newChats.append(chat)
                    targetNameDict[chat.id] = targetUserName
                } catch {
                    print("Fetch Chat Error : \(error)")
                }
            }
        }
        
        // MARK: Memo - Published에 관여하는 파트만 main thread를 사용하기 위해 @MainActor를 삭제하고 부분적으로 main thread 사용 by. 태영
        // 230207 추가 : 동시성 코드에서 변경할 수 없는 프로퍼티 혹은 인스턴스를 변경하는 것은 불가. MainActor로 다시 교체
        chats = newChats
        self.isDoneFetch = true
    }
    
    // MARK: -Chat CRUD
    func addChat(_ chat: Chat) {
        do {
            try db.collection("Chat")
                .document(chat.id)
                .setData(from: chat.self)
        } catch {
            print("Add Chat Error : \(error.localizedDescription)")
        }
    }
    
    func updateChat(_ chat: Chat) async {
        do {
            try await db.collection("Chat")
                .document(chat.id)
                .updateData(["lastDate" : chat.lastDate,
                             "lastContent" : chat.lastContent])
        } catch {
            print("Update Chat Error : \(error.localizedDescription)")
        }
        
    }
    
    func removeChat(_ chat: Chat) async {
        do {
            try await db.collection("Chat")
                .document(chat.id)
                .delete()
        } catch {
            print("Remove Chat Error : \(error.localizedDescription)")
        }
    }
}
