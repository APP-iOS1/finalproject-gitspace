//
//  ChatViewModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation
import FirebaseFirestore

class ChatStore: ObservableObject {
    @Published var targetChat : Chat?
    @Published var chats: [Chat]
    
    let db = Firestore.firestore()
    
    init() {
        chats = []
    }
    
    func fetchChats() {
        db.collection("Chat").order(by: "lastDate", descending: true)
            .getDocuments { (snapshot, error) in
                self.chats.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let date = docData["date"] as? Double ?? 0.0
                        let userIDList = docData["userIDs"] as? [String] ?? []
                        let lastDate = docData["lastDate"] as? Double ?? 0.0
                        let lastContent = docData["lastContent"] as? String ?? ""
                        
                        let userIDs : (String, String)
                        
                        // DB에 Array로 저장한 userIDs를 Tuple로 변환
                        // 할당에 성공한 경우에만 Chat 구조체 추가
                        if let open = userIDList.first, let join = userIDList.last {
                            userIDs = (open, join)
                            let chat = Chat(id: id,
                                            date: date,
                                            userIDs: userIDs,
                                            lastDate: lastDate,
                                            lastContent: lastContent)
                            self.chats.append(chat)
                        }
                    }
                }
            }
    }
    
    // MARK: -Chat CRUD
    func addChat(_ chat: Chat) {
        db.collection("Chat")
            .document(chat.id)
            .setData(["id" : chat.id,
                      "date" : chat.date,
                      "userIDs" : [chat.userIDs.open, chat.userIDs.join],
                      "lastDate" : chat.lastDate,
                      "lastContent" : chat.lastContent])
        fetchChats()
    }
    
    func updateChat(_ chat: Chat) {
        db.collection("Chat")
            .document(chat.id)
            .updateData(["lastDate" : chat.lastDate,
                         "lastContent" : chat.lastContent])
        fetchChats()
    }
    
    func removeChat(_ chat: Chat) {
        db.collection("Chat")
            .document(chat.id).delete()
        
        fetchChats()
    }
    
    // MARK: -Method : 유저 리스트를 통해서 채팅방을 Request해서 채팅방 객체를 Published 변수에 할당하는 함수
    func requestChatFromUserList(userIDs : [String]) {
        
        db.collection("Chat")
            .whereField("userIDs", arrayContainsAny: userIDs)
            .getDocuments { (snapshot, error) in
                
                // MARK: -Logic : userIDs에 해당하는 (내 ID와 상대방 ID로 만들어진 채팅방이 이미 존재하면) 해당 채팅방을 return, 없으면 신규 채팅방을 add하고 해당 채팅방을 return.
                if let snapshot {
                    if snapshot.documents.isEmpty {
                        print("documents is Empty")
                        let date = Date().timeIntervalSince1970
                        if let open = userIDs.first, let join = userIDs.last {
                            
                            let newChat = Chat(id: UUID().uuidString,
                                               date: date,
                                               userIDs: (open, join),
                                               lastDate: date,
                                               lastContent: "")
                            self.addChat(newChat)
                            self.targetChat = newChat
                        }
                    } else {
                        for document in snapshot.documents {
                            let id: String = document.documentID
                            let docData = document.data()
                            let date = docData["date"] as? Double ?? 0.0
                            let userIDList = docData["userIDs"] as? [String] ?? []
                            let lastDate = docData["lastDate"] as? Double ?? 0.0
                            let lastContent = docData["lastContent"] as? String ?? ""
                            
                            let userIDs : (String, String)
                            
                            // DB에 Array로 저장한 userIDs를 Tuple로 변환
                            // 할당에 성공한 경우에만 Chat 구조체 추가
                            if let open = userIDList.first, let join = userIDList.last {
                                userIDs = (open, join)
                                let chat = Chat(id: id,
                                                date: date,
                                                userIDs: userIDs,
                                                lastDate: lastDate,
                                                lastContent: lastContent)
                                self.targetChat = chat
                            }
                        }
                    }
                }
            }
    }
}
