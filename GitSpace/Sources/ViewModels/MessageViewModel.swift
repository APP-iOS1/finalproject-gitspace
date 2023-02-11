//
//  MessageViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class MessageStore: ObservableObject {
    @Published var messages: [Message]
    @Published var isMessageAdded: Bool
    
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    init() {
        messages = []
        isMessageAdded = false
    }
}

// MARK: -Extension : Message CRUD 관련 함수를 모아둔 Extension
extension MessageStore {
    
    private func getMessageDocuments(_ chatID: String) async -> QuerySnapshot? {
        do {
            let snapshot = try await db.collection("Chat").document(chatID).collection("Message").order(by: "date").getDocuments()
            return snapshot
        } catch {
            print("Get Message Documents Error : \(error)")
        }
        return nil
    }
    
    @MainActor
    // MARK: Method : 채팅 ID를 받아서 메세지들을 불러오는 함수
    func fetchMessages(chatID: String) async {
        
        let snapshot = await getMessageDocuments(chatID)
        var newMessages: [Message] = []
        
        if let snapshot {
            for document in snapshot.documents {
                do {
                    let message: Message = try document.data(as: Message.self)
                    newMessages.append(message)
                } catch {
                    print("fetch Messages Error : \(error)")
                }
            }
        }
        messages = newMessages
    }
    
    // MARK: - Message CRUD
    func addMessage(_ message: Message, chatID: String) {
        do {
            try db
                .collection("Chat")
                .document(chatID)
                .collection("Message")
                .document(message.id)
                .setData(from: message.self)
        } catch {
            print("Add Message Error : \(error)")
        }
    }
    
    func updateMessage(_ message: Message, chatID: String) {
        db
            .collection("Chat")
            .document(chatID)
            .collection("Message")
            .document(message.id)
            .updateData(
                ["content" : message.content,
                         "date" : message.date]
            )
    }
    
    func removeMessage(_ message: Message, chatID: String) {
        db
            .collection("Chat")
            .document(chatID)
            .collection("Message")
            .document(message.id)
            .delete()
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
            print("Fetch New Message in Message Listener Error : \(error)")
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
    
    //TODO: API에서 async await concurrency 지원하는지 여부 파악
    func addListener(chatID: String) {
        listener = db
            .collection("Chat")
            .document(chatID)
            .collection("Message")
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
                        let newMessage = self.fetchNewMessage(change: diff.document)
                        if let newMessage {
                            self.messages.append(newMessage)
                            // 메세지 추가 시 Chat Room View 스크롤을 최하단으로 내리기 위한 트리거
                            self.isMessageAdded.toggle()
                        }
                    case .modified:
                        print("modified")
                    case .removed:
                        print("removed")
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

