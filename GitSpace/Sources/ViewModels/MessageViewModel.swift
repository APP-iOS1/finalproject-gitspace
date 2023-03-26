//
//  MessageViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

// TODO: 메세지 삭제 시 lastContent 업데이트 로직 체크 필요
/// 메세지 추가 시 채팅 리스트에서 lastContent를 누가 업데이트해주는지 체크 필요
/// 어느쪽 리스너 혹은 뷰모델에서 lastContent를 업데이트 하는 로직을 가져야하는지 고려 필요

import Foundation
import FirebaseCore
import FirebaseFirestore

final class MessageStore: ObservableObject {
    
    
    @Published var messages: [Message]
    @Published var isMessageAdded: Bool
    @Published var deletedMessage: Message? // 메세지 셀 삭제 시 onChange로 반응하는 대상 메세지
    @Published var isFetchMessagesDone: Bool = false
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    private let const = Constant.FirestorePathConst.self
    var currentChat: Chat? // 채팅방 입장 시, 현재 입장한 Chat 인스턴스를 할당받음. MessageStore 내부에서 Chat DB에 접근하기 위한 변수
    
    init() {
        messages = []
        isMessageAdded = false
    }
}

extension Array {
    func fromLast(count: Int) -> Self {
        let start: Int = self.count - count
        var array: Self = []
        for i in self.enumerated() {
            if i.offset >= start {
                array.append(i.element)
            }
        }
        return array
    }
}

// MARK: -Extension : Message CRUD 관련 함수를 모아둔 Extension
extension MessageStore {
    
    /**
     Firestore에 요청해서 메세지 컬렉션에서 문서들을 반환 받습니다.
     
     - Author: 태영
     
     - Since: 23.03.10
     
     - parameters:
        - chatID: Message 문서들을 가지고 있는 Chat의 문서 ID
        - unreadMessageCount: 사용자가 읽지 않은 해당 채팅방의 메세지 갯수
     
     - Returns: Chat 문서 ID 하위에 있는 Message 컬렉션의 문서들
     */
    private func getMessageDocuments(_ chatID: String, unreadMessageCount: Int) async -> QuerySnapshot? {
        do {
            let snapshot = try await db
                .collection(const.COLLECTION_CHAT)
                .document(chatID)
                .collection(const.COLLECTION_MESSAGE)
                .order(by: const.FIELD_SENT_DATE)
                .limit(toLast: 30 + unreadMessageCount)
                .getDocuments()
            return snapshot
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
        return nil
    }
    
    @MainActor
    private func writeMessages(messages: [Message]) {
        self.messages = messages
        isFetchMessagesDone = true
    }
    
    // MARK: Method : 채팅 ID를 받아서 메세지들을 불러오는 함수
    func fetchMessages(chatID: String, unreadMessageCount: Int) async {
        
        let snapshot = await getMessageDocuments(chatID, unreadMessageCount: unreadMessageCount)
        var newMessages: [Message] = []
        
        if let snapshot {
            for document in snapshot.documents {
                do {
                    let message: Message = try document.data(as: Message.self)
                    newMessages.append(message)
                } catch {
                    print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
                }
            }
        }
        await writeMessages(messages: newMessages)
    }
    
    // MARK: - Message CRUD
    func addMessage(_ message: Message, chatID: String) {
        do {
            try db
                .collection(const.COLLECTION_CHAT)
                .document(chatID)
                .collection(const.COLLECTION_MESSAGE)
                .document(message.id)
                .setData(from: message.self)
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
    }
    
    func updateMessage(_ message: Message, chatID: String) async {
        do {
            try await db
                .collection(const.COLLECTION_CHAT)
                .document(chatID)
                .collection(const.COLLECTION_MESSAGE)
                .document(message.id)
                .updateData(
                    [const.FIELD_TEXT_CONTENT : message.textContent,
                     const.FIELD_SENT_DATE : message.sentDate])
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
    }
    
    func removeMessage(_ message: Message, chatID: String) async {
        do {
            try await db
                .collection(const.COLLECTION_CHAT)
                .document(chatID)
                .collection(const.COLLECTION_MESSAGE)
                .document(message.id)
                .delete()
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
    }
}

// MARK: -Extension : Listener 관련 함수를 모아둔 익스텐션
extension MessageStore {
    
    // MARK: Method : 추가된 문서 필드에 접근하여 Message 객체를 만들어 반환하는 함수
    func fetchNewMessage(change : QueryDocumentSnapshot) -> Message? {
        do {
            let newMessage = try change.data(as: Message.self)
            return newMessage
        } catch {
            print("Error-\(#file)-\(#function) : \(error.localizedDescription)")
        }
        return nil
    }
    
    // MARK: Method : 삭제된 문서 필드에서 ID를 받아서 Local Published 메세지 배열에서 해당 메세지를 삭제하는 함수
    func removeDeletedLocalMessage(change: QueryDocumentSnapshot) {
        guard let index = messages.firstIndex(where: { $0.id == change.documentID}) else {
            return
        }
        messages.remove(at: index)
    }
    
    func addListener(chatID: String) {
        listener = db
            .collection(const.COLLECTION_CHAT)
            .document(chatID)
            .collection(const.COLLECTION_MESSAGE)
            .addSnapshotListener { snapshot, error in
                // snapshot이 비어있으면 에러 출력 후 리턴
                guard let snp = snapshot else {
                    print("Error fetching documents: \(error!.localizedDescription)")
                    return
                }
                // document 변경 사항에 대해 감지해서 작업 수행
                snp.documentChanges.forEach { diff in
                    switch diff.type {
                    case .added:
                        if let newMessage = self.fetchNewMessage(change: diff.document) {
                            self.messages.append(newMessage)
                            // 메세지 추가 시 Chat Room View 스크롤을 최하단으로 내리기 위한 트리거
                            self.isMessageAdded.toggle()
                        }
                    case .modified:
                        let _ = 1
                    case .removed:
                        self.removeDeletedLocalMessage(change: diff.document)
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

