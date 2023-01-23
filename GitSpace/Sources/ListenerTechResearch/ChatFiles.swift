//
//  ChatFiles.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/23.
//

var userUID : String = ""

import Foundation

// MARK: -Models -----------------------------------
// ChatCell Model -----------------------------------
import Foundation

struct ChatCell : Identifiable {
    let id : String
    let userID : String
    let content : String
    let date : Double
    
    var stringDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateAt = Date(timeIntervalSince1970: date)
        
        return dateFormatter.string(from: dateAt)
    }
}


// MARK: -ViewModels -----------------------------------
// ChatCell ViewModel -----------------------------------

import Foundation
import FirebaseFirestore

class ChatCellStore : ObservableObject {
    
    @Published var chatCells : [ChatCell]
    
    let database = Firestore.firestore()
    
    init() {
        chatCells = []
    }
    
    
    // MARK: -Method : 채팅 ID를 받아서 메세지들을 불러오는 함수
    func fetchChatCells() {
        self.database.collection("ChatCell").order(by: "date")
            .getDocuments { snapshot, error in
                self.chatCells.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let userID : String = docData["userID"] as? String ?? ""
                        let content : String = docData["content"] as? String ?? ""
                        let date : Double = docData["date"] as? Double ?? 0.0
                        self.chatCells.append(ChatCell(id: id, userID: userID, content: content, date: date))
                    }
                }
            }
    }
    
    
    // MARK: - ChatCell CRUD
    func addChatCell(_ chatCell: ChatCell) {
        
        database.collection("ChatCell")
            .document(chatCell.id)
            .setData(["id" : chatCell.id,
                      "userID" : chatCell.userID,
                      "content" : chatCell.content,
                      "date" : chatCell.date])
    }
    
    func updateChatCell(_ chatCell: ChatCell) {
        database.collection("ChatCell")
            .document(chatCell.id)
            .updateData(["id" : chatCell.id,
                         "userID" : chatCell.userID,
                         "content" : chatCell.content,
                         "date" : chatCell.date])
    }
    
    func removeChatCell(_ chatCell: ChatCell) {
        database.collection("ChatCell")
            .document(chatCell.id)
            .delete()
    }
    
    func fetchNewChat(newChat : QueryDocumentSnapshot) -> ChatCell {
        let id = newChat.documentID
        let data = newChat.data()
        let userID : String = data["userID"] as? String ?? ""
        let content : String = data["content"] as? String ?? ""
        let date : Double = data["date"] as? Double ?? 0.0
        let newChatCell = ChatCell(id: id, userID: userID, content: content, date: date)
        return newChatCell
    }
    
    
    //TODO: API에서 async await concurrency 지원하는지 여부 파악
    
    func addListener() {
        
        let oldChatList = self.chatCells
        
        database.collectionGroup("ChatCell").addSnapshotListener { snapshot, error in
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
                        self.chatCells.append(self.fetchNewChat(newChat: diff.document))
                        
                    case .modified:
                        print("modified")
                    case .removed:
                        print("removed")
                    }
                }
            }
        
        print("마지막")
        chatCells = oldChatList
    }
}

// ChatDetail View -----------------------------------

import SwiftUI

// MARK: -View : 채팅방 뷰
struct ChatView : View {
    @StateObject var chatCellStore : ChatCellStore = ChatCellStore()
    @State var isShowingUpdateCell : Bool = false
    @State var currentChatCell : ChatCell?
    let userID : String
    @State private var contentField : String = ""
    
    var body: some View {
        
        VStack {
            Button {
                chatCellStore.addListener()
            } label: {
                Text("리스너 스타느")
            }

            
            // 채팅 메세지 스크롤 뷰
            ScrollView {
                ForEach(chatCellStore.chatCells) { chatCell in
                    
                    ChatCellView(userID: userID, chatCell: chatCell)
                        .contextMenu {
                            
                            Button {
                                self.currentChatCell = chatCell
                                isShowingUpdateCell = true
                            } label: {
                                Text("수정하기")
                                Image(systemName: "pencil")
                            }
                            
                            Button {
                                chatCellStore.removeChatCell(chatCell)
                            } label: {
                                Text("삭제하기")
                                Image(systemName: "trash")
                            }
                        }
                }
                
            }
            // 메세지 입력 필드
            typeContentField
                .padding(20)
        }
        .onAppear {
            chatCellStore.fetchChatCells()
        }
    }
    
    // MARK: -Button : 메세지 수정
    private var updateContentButton : some View {
        Button {
            isShowingUpdateCell = true
        } label: {
            Text("수정하기")
            Image(systemName: "pencil")
        }
    }
    
    // MARK: -Button : 메세지 삭제
    private var removeContentButton : some View {
        Button {
            
        } label: {
            Text("삭제하기")
            Image(systemName: "trash")
        }
    }
    
    // MARK: -Section : 메세지 입력
    private var typeContentField : some View {
        HStack {
            TextField("",text: $contentField)
                .textFieldStyle(.roundedBorder)
            addContentButton
        }
    }
    
    // MARK: -Button : 메세지 추가(보내기)
    private var addContentButton : some View {
        Button {
            let newChatCell = makeChatCell()
            chatCellStore.addChatCell(newChatCell)
            contentField = ""
        } label: {
            Image(systemName: "paperplane.circle.fill")
        }
    }
    
    // MARK: -Method : ChatCell 인스턴스를 만들어서 반환하는 함수
    private func makeChatCell() -> ChatCell {
        
        let date = Date().timeIntervalSince1970
        let chatCell = ChatCell(id: UUID().uuidString,
                                userID: userUID,
                                content: contentField,
                                date: date)
        return chatCell
    }
}

/*
struct ChangeContentSheetView : View {
    @Binding var isShowingUpdateCell : Bool
    @State var changeContentField : String = ""
    @ObservedObject var chatCellStore : ChatCellStore
    let chatID : String
    let chatCell : ChatCell
    
    var body: some View {
        VStack(spacing : 50) {
            
            TextField(chatCell.content, text: $changeContentField)
                .textFieldStyle(.roundedBorder)
            
            Button {
                chatCellStore.updateChatCell(chatCell, chatID)
                isShowingUpdateCell = false
            } label: {
                Text("수정하기")
                Image(systemName: "pencil")
            }
            
        }
    }
}
*/
// ChatDetail View -----------------------------------

import SwiftUI

// MARK: -View : 채팅 메세지 셀
struct ChatCellView : View {
    let userID : String
    let chatCell : ChatCell
    var isMine : Bool {
        return userID == chatCell.userID
    }
    
    var body: some View {
        
        HStack(alignment: .bottom) {

            Text(chatCell.content)
                .modifier(ChatCellModifier(isMine: self.isMine))
            
        }
        .padding(isMine ? .trailing : .leading, 20)
    }
}

// MARK: -Modifier : 채팅 메세지 셀 속성
struct ChatCellModifier : ViewModifier {
    let isMine : Bool
    func body(content: Content) -> some View {
        content
            .padding()
            .padding(.vertical,-8)
            .foregroundColor(isMine ? .white : .black)
            .background(isMine ? .orange : .gray)
            .cornerRadius(22)
        
        
    }
}

// MARK: -Modifier : 채팅 메세지 보낸 시간 속성
struct ChatCellTimeModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .foregroundColor(.secondary)
    }
}

// MARK: -View :
struct ChatListView : View {
    
    @EnvironmentObject var authStore : AuthStore
    
    var body : some View {
        
        VStack(spacing : 50) {
            
            Text(authStore.currentUser?.uid ?? "")
            
            
            
            NavigationLink {
                ChatView(userID: userUID)
            } label: {
                Text("채팅방으로")
            }
            Button {
                authStore.logout()
            } label: {
                Text("로그아웃하기~")
            }

        }
        
        

    }
}
