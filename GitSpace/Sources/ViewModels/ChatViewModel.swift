// TODO: -해야할 거
/// 1. snapshotListener에서 단일로 Cell을 추가하거나 삭제하는 것이 가능한지
/// 2. 업데이트 된 단일 Cell이 View에 반영되는지
/// 3. remove할 때 인덱스 번호로 찾아가서 걔만 지울 수 있는지

import Foundation
import FirebaseFirestore

class ChatStore: ObservableObject {
    @Published var targetUserID: [String]
    @Published var chats: [Chat]
    
    let db = Firestore.firestore()
    
    init() {
        chats = []
        targetUserID = []
    }
    
    func fetchChats() {
        db.collection("Chat").order(by: "lastDate", descending: true)
            .getDocuments { (snapshot, error) in
                self.chats.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let date: Date = docData["date"] as? Date ?? Date()
                        let users: [String: String] = docData["users"] as? [String: String] ?? [:]
                        let lastTimeStamp: Timestamp = docData["lastDate"] as? Timestamp ?? Timestamp()
                        let lastDate: Date = Timestamp.dateValue(lastTimeStamp)()
                        let lastContent: String = docData["lastContent"] as? String ?? ""
                        let knockTimeStamp: Timestamp = docData["knockDate"] as? Timestamp ?? Timestamp()
                        let knockDate: Date = Timestamp.dateValue(knockTimeStamp)()
                        let knockContent: String = docData["knockContent"] as? String ?? ""
                        
                        
                        
                        let userIDs : (String, String)
                        
                        // DB에 Array로 저장한 userIDs를 Tuple로 변환
                        // 할당에 성공한 경우에만 Chat 구조체 추가
                        if let senderID = users["senderID"], let receiverID = users["receiverID"] {
                            userIDs = (senderID, receiverID)
                            let targetID = Utility.loginUserID == senderID ? receiverID : senderID
                            let chat = Chat(id: id,
                                            date: date,
                                            users: userIDs,
                                            lastDate: lastDate,
                                            lastContent: lastContent,
                                            knockContent: knockContent,
                                            knockDate: knockDate)
                            self.chats.append(chat)
                            self.targetUserID.append(targetID)
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
                      "users" : [chat.users.senderID, chat.users.receiverID],
                      "lastDate" : chat.lastDate,
                      "lastContent" : chat.lastContent,
                      "knockContent" : chat.knockContent,
                      "knockDate" : chat.knockDate])
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
}
    
    

//MARK: - 이전 리스너 기술 검증을 위해 썼던 코드로, 이후 참고할 수도 있어서 주석으로 남겨놓았습니다. by. 예슬
    // MARK: -Method : 유저 리스트를 통해서 채팅방을 Request해서 채팅방 객체를 Published 변수에 할당하는 함수
//    func requestChatFromUserList(userIDs : [String]) {
//
//        db.collection("Chat")
//            .whereField("users", arrayContainsAny: userIDs)
//            .getDocuments { (snapshot, error) in
//
//                // MARK: -Logic : userIDs에 해당하는 (내 ID와 상대방 ID로 만들어진 채팅방이 이미 존재하면) 해당 채팅방을 return, 없으면 신규 채팅방을 add하고 해당 채팅방을 return.
//                if let snapshot {
//                    if snapshot.documents.isEmpty {
//                        print("documents is Empty")
//                        let date = Date()
//                        if let open = chat.users.senderID, let join = chat.users.receiverID {
//
//                            let newChat = Chat(id: UUID().uuidString,
//                                               date: date,
//                                               userIDs: (open, join),
//                                               lastDate: date,
//                                               lastContent: "")
//                            self.addChat(newChat)
//                            self.targetChat = newChat
//                        }
//                    } else {
//                        for document in snapshot.documents {
//                            let id: String = document.documentID
//                            let docData = document.data()
//                            let date = docData["date"] as? Double ?? 0.0
//                            let userIDList = docData["userIDs"] as? [String] ?? []
//                            let lastDate = docData["lastDate"] as? Double ?? 0.0
//                            let lastContent = docData["lastContent"] as? String ?? ""
//
//                            let userIDs : (String, String)
//
//                            // DB에 Array로 저장한 userIDs를 Tuple로 변환
//                            // 할당에 성공한 경우에만 Chat 구조체 추가
//                            if let open = userIDList.first, let join = userIDList.last {
//                                userIDs = (open, join)
//                                let chat = Chat(id: id,
//                                                date: date,
//                                                userIDs: userIDs,
//                                                lastDate: lastDate,
//                                                lastContent: lastContent)
//                                self.targetChat = chat
//                            }
//                        }
//                    }
//                }
//            }
//    }
