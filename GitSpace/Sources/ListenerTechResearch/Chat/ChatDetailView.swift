//
//  ChatDetailView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

// MARK: -View : 채팅방 뷰
struct ChatDetailView : View {
    
    let chat : Chat
    let isFromUserList : Bool
    
    @EnvironmentObject var chatStore : ChatStore
    @EnvironmentObject var messageStore : MessageStore
    
    @State var isShowingUpdateCell : Bool = false
    @State var currentMessage : Message?
    @State private var contentField : String = ""
    
    var body: some View {
        
        VStack {
            Button {
                messageStore.addListener(chatID: chat.id)
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
                    
                    MessageCell(message: message)
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
                                                   chatID: chat.id,
                                                   message: message)
                        }
                }
                
            }
            // 메세지 입력 필드
            typeContentField
                .padding(20)
        }
        .task {
            if isFromUserList {
                if let targetChat = chatStore.targetChat{
                    chatStore.requestChatFromUserList(userIDs: chat.userIDList)
                    messageStore.fetchMessages(chatID: targetChat.id)
                }
            } else {
                messageStore.fetchMessages(chatID: chat.id)
            }
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
        // MARK: -Logic : 메세지 전송 버튼 입력 시 일련의 로직 수행
        /// 새 메세지 셀 생성
        /// 채팅방 입장 시 가져온 Chat으로 새 Chat 생성 + 이번에 입력한 메세지 내용과 입력 시간으로 업데이트
        /// DB 메세지 Collection에 추가, Chat Collection에서 기존 Chat 업데이트
        /// 메세지 입력 필드 공백으로 초기화
        Button {
            let newMessage = makeMessage()
            let newChat = Chat(id: chat.id,
                               date: chat.date,
                               userIDs: (chat.userIDs.open, chat.userIDs.join),
                               lastDate: Date().timeIntervalSince1970,
                               lastContent: contentField)
            messageStore.addMessage(newMessage, chatID: chat.id)
            chatStore.updateChat(newChat)
            contentField = ""
            
        } label: {
            Image(systemName: "paperplane.circle.fill")
        }
    }
    
    // MARK: -Method : Message 인스턴스를 만들어서 반환하는 함수
    private func makeMessage() -> Message {
        
        let date = Date().timeIntervalSince1970
        let message = Message(id: UUID().uuidString,
                                userID: Utility.loginUserID,
                                content: contentField,
                                date: date)
        return message
    }
}


// MARK: -View : 메세지 수정 Sheet
struct ChangeContentSheetView : View {
    @Binding var isShowingUpdateCell : Bool
    @State var changeContentField : String = ""
    @EnvironmentObject var messageStore : MessageStore
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
