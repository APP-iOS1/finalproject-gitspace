//
//  MessageViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class MessageStore: ObservableObject {
    @Published var messages: [Message]
    @Published var messageAdded: Bool = false
    
    var startMessagesCounter: Int = 0
    var startMessagesRemoved: Bool = false
    var listener: ListenerRegistration?
    let database = Firestore.firestore()
    
    init() {
        messages = []
    }
}


// MARK: -Extension : Message CRUD 관련 함수를 모아둔 Extension
extension MessageStore {
    // MARK: Method : 채팅 ID를 받아서 메세지들을 불러오는 함수
    func fetchMessages(chatID: String) {
        self.database
            .collection("Chat").document(chatID)
            .collection("Message")
            .order(by: "date")
            .getDocuments { snapshot, error in
                self.messages.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let userID: String = docData["userID"] as? String ?? ""
                        let content: String = docData["content"] as? String ?? ""
                        let timeStamp: Timestamp = docData["date"] as? Timestamp ?? Timestamp()
                        let date: Date = Timestamp.dateValue(timeStamp)()
                        
                        let newMessage = Message(id: id,
                                                 userID: userID,
                                                 content: content,
                                                 date: date)
                        
                        self.messages.append(newMessage)
                    }
                }
            }
    }
    
    
    
    // MARK: - Message CRUD
    func addMessage(_ message: Message, chatID: String) {
        
        database
            .collection("Chat")
            .document(chatID)
            .collection("Message")
            .document(message.id)
            .setData(["id" : message.id,
                      "userID" : message.userID,
                      "content" : message.content,
                      "date" : message.date])
    }
    
    func updateMessage(_ message: Message, chatID: String) {
        database
            .collection("Chat")
            .document(chatID)
            .collection("Message")
            .document(message.id)
            .updateData(["content" : message.content,
                         "date" : message.date])
    }
    
    func removeMessage(_ message: Message, chatID: String) {
        database
            .collection("Chat")
            .document(chatID)
            .collection("Message")
            .document(message.id)
            .delete()
    }
}



// MARK: -Extension : Listener 관련 함수를 모아둔 익스텐션
extension MessageStore {
    // MARK: Method : AddListener 호출 시 기존 메세지들이 한번씩 불러와지는 오류를 수정하는 함수
    func removeListenerMessages() {
        if !startMessagesRemoved {
            messages.removeFirst(startMessagesCounter)
            startMessagesRemoved = true
        }
    }
    
    // MARK: Method : 추가된 문서 필드에 접근하여 Message 객체를 만들어 반환하는 함수
    func fetchNewMessage(change : QueryDocumentSnapshot) -> Message {
        let id = change.documentID
        let data = change.data()
        let userID: String = data["userID"] as? String ?? ""
        let content: String = data["content"] as? String ?? ""
        let timeStamp: Timestamp = data["date"] as? Timestamp ?? Timestamp()
        let date: Date = Timestamp.dateValue(timeStamp)()
        let newMessage = Message(id: id, userID: userID, content: content, date: date)
        return newMessage
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
        listener = database
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
                        print(diff.document.documentID)
                        let newMessage = self.fetchNewMessage(change: diff.document)
                        self.messages.append(newMessage)
                        // AddListener로 인해 추가된 배열 길이를 지우기 위해 증가시키는 숫자
                        self.startMessagesCounter += 1
                        self.messageAdded.toggle()
                    case .modified:
                        print("modified")
                        print(diff.document.documentID)
                    case .removed:
                        print("removed")
                        self.removeDeletedLocalMessage(change: diff.document)
                    }
                }
            }
    }
    
    func removeListener() {
        guard listener != nil else {
            return
        }
        listener!.remove()
    }
}

