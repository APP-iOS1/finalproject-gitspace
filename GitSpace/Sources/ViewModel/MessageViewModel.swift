//
//  MessageViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import FirebaseFirestore

class MessageStore : ObservableObject {
    @Published var messages : [Message]
    var listener : ListenerRegistration?
    
    let database = Firestore.firestore()
    
    init() {
        messages = []
    }
    
    
    // MARK: -Method : 채팅 ID를 받아서 메세지들을 불러오는 함수
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
                        let date: Date = docData["date"] as? Date ?? Date()
                        
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
    func addMessage(_ message: Message, chatID : String) {
        
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
    
    func updateMessage(_ message: Message) {
        database
            .collection("Message")
            .document(message.id)
            .updateData(["id" : message.id,
                         "userID" : message.userID,
                         "content" : message.content,
                         "date" : message.date])
    }
    
    func removeMessage(_ message: Message) {
        database.collection("Message")
            .document(message.id)
            .delete()
    }
    
    // MARK: Method : 추가된 문서 필드에 접근하여 Message 객체를 만들어 반환하는 함수
    func fetchNewMessage(change : QueryDocumentSnapshot) -> Message {
        let id = change.documentID
        let data = change.data()
        let userID: String = data["userID"] as? String ?? ""
        let content: String = data["content"] as? String ?? ""
        let date: Date = data["date"] as? Date ?? Date()
        let newMessage = Message(id: id, userID: userID, content: content, date: date)
        return newMessage
    }
    
    //TODO: API에서 async await concurrency 지원하는지 여부 파악 
    
    func addListener(chatID : String) {
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
                        let newMessage = self.fetchNewMessage(change: diff.document)
                        self.messages.append(newMessage)
                    case .modified:
                        print("modified")
                    case .removed:
                        print("removed")
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
