// TODO: -해야할 거
/// 1. snapshotListener에서 단일로 Cell을 추가하거나 삭제하는 것이 가능한지
/// 2. 업데이트 된 단일 Cell이 View에 반영되는지
/// 3. remove할 때 인덱스 번호로 찾아가서 걔만 지울 수 있는지
///
// TODO: 채팅 관련 작업
// 1. 채팅방 전역으로 알림 띄우기
// 2. ScrollView == 카카오톡
// 3. 채팅방 데이터 추가하고 채팅 리스트 Listener 테스트하기

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ChatStore: ObservableObject {
    
    @Published var targetUserNames: [String]
    @Published var chats: [Chat]
    @Published var isFetchFinished: Bool
    
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    init() {
        chats = []
        targetUserNames = []
        isFetchFinished = false
    }
}

// MARK: -Extension : Chat Listener 관련 메서드를 모아둔 익스텐션
extension ChatStore {
    
}


// MARK: -Extension : Chat CRUD 관련 메서드를 모아둔 익스텐션
extension ChatStore {
    
    // MARK: -Methods
    // MARK: Method - Chat Documents
    private func getChatDocuments() async -> QuerySnapshot? {
        do {
            let snapshot = try await db.collection("Chat").order(by: "lastDate", descending: true).getDocuments()
            return snapshot
        } catch { }
        return nil
    }
    

    @MainActor
    func fetchChats() async {
        let snapshot = await getChatDocuments()
        // MARK: Memo - 함수 내부 배열에 추가 -> Published에 덮어쓰기 로직으로 removeAll 없이 정상 작동함 by.태영
        var newChats: [Chat] = []
        var newTargetUserNames: [String] = []
        
        if let snapshot {
            for document in snapshot.documents {
                do {
                    let chat: Chat = try document.data(as: Chat.self)
                    let targetUserName: String = await chat.targetUserName
                    newChats.append(chat)
                    newTargetUserNames.append(targetUserName)
                } catch { }
            }
        }
        
        // MARK: Memo - Published에 관여하는 파트만 main thread를 사용하기 위해 @MainActor를 삭제하고 부분적으로 main thread 사용 by. 태영
        // 230207 추가 : 동시성 코드에서 변경할 수 없는 프로퍼티 혹은 인스턴스를 변경하는 것은 불가. MainActor로 다시 교체
        chats = newChats
        targetUserNames = newTargetUserNames
        self.isFetchFinished = true
    }
    
    // MARK: -Chat CRUD
    func addChat(_ chat: Chat) async {
        do {
            try db.collection("Chat")
                .document(chat.id)
                .setData(from: chat.self)
            await fetchChats()
        } catch { }
    }
    
    func updateChat(_ chat: Chat) async {
        do {
            try await db.collection("Chat")
                .document(chat.id)
                .updateData(["lastDate" : chat.lastDate,
                             "lastContent" : chat.lastContent])
            await fetchChats()
        } catch { }
    }
    
    func removeChat(_ chat: Chat) async {
        do {
            try await db.collection("Chat")
                .document(chat.id).delete()
            await fetchChats()
        } catch { }
    }
}
