//
//  ChatDetailView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

// MARK: -View : 채팅방 뷰
struct ChatDetailView : View {
    let userID : String
    
    @StateObject var messageStore : MessageStore = MessageStore()
    @State var isShowingUpdateCell : Bool = false
    @State var currentMessage : Message?
    @State private var contentField : String = ""
    
    var body: some View {
        
        VStack {
            Button {
                messageStore.addListener()
            } label: {
                Text("리스너 스타트")
            }
            Button {
                messageStore.removeListener()
            } label: {
                Text("리스너 스탑")
            }
            
            // 채팅 메세지 스크롤 뷰
            ScrollView {
                ForEach(messageStore.messages) { message in
                    
                    MessageCell(userID: userID, message: message)
                        .contextMenu {
                            
                            Button {
                                self.currentMessage = message
                                isShowingUpdateCell = true
                            } label: {
                                Text("수정하기")
                                Image(systemName: "pencil")
                            }
                            
                            Button {
                                messageStore.removeMessage(message)
                            } label: {
                                Text("삭제하기")
                                Image(systemName: "trash")
                            }
                        }
                        .sheet(isPresented: $isShowingUpdateCell) {
                            ChangeContentSheetView(isShowingUpdateCell: $isShowingUpdateCell,
                                                   messageStore: <#T##MessageStore#>,
                                                   chatID: <#T##String#>,
                                                   message: )
                        }
                }
                
            }
            // 메세지 입력 필드
            typeContentField
                .padding(20)
        }
        .onAppear {
            messageStore.fetchMessages()
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
            let newMessage = makeMessage()
            messageStore.addMessage(newMessage)
            contentField = ""
        } label: {
            Image(systemName: "paperplane.circle.fill")
        }
    }
    
    // MARK: -Method : Message 인스턴스를 만들어서 반환하는 함수
    private func makeMessage() -> Message {
        
        let date = Date().timeIntervalSince1970
        let message = Message(id: UUID().uuidString,
                                userID: userUID,
                                content: contentField,
                                date: date)
        return message
    }
}


// MARK: -View : 메세지 수정 Sheet
struct ChangeContentSheetView : View {
    @Binding var isShowingUpdateCell : Bool
    @State var changeContentField : String = ""
    @ObservedObject var messageStore : MessageStore
    let chatID : String
    let message : Message
    
    var body: some View {
        VStack(spacing : 50) {
            
            TextField(message.content, text: $changeContentField)
                .textFieldStyle(.roundedBorder)
            
            Button {
                messageStore.updateMessage(message)
                isShowingUpdateCell = false
            } label: {
                Text("수정하기")
                Image(systemName: "pencil")
            }
            
        }
    }
}
