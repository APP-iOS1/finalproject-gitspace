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
    
    @EnvironmentObject var chatStore : ChatStore
    @EnvironmentObject var messageStore : MessageStore
    @State var isShowingUpdateCell : Bool = false
    @State var currentMessage : Message?
    @State private var contentField : String = ""
    
    
    var body: some View {
        
        VStack {
            // 채팅 메세지 스크롤 뷰
            ScrollViewReader { proxy in
                ScrollView {
                    
                    ChatDetailProfileSection(chat: chat)
                    
                    Divider()
                        .padding(.vertical, 20)
                    
                    ChatDetailKnockSection(chat: chat)
                    
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
                                    messageStore.removeMessage(message,
                                                               chatID: chat.id)
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
                    .padding(.top, 10)
                    
                    Text("")
                        .id(1)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                proxy.scrollTo(1, anchor: .bottomTrailing)
                            }
                        }
                    
                }
            }
            .padding(.horizontal, 20)
            // 메세지 입력 필드
            typeContentField
                .padding(20)
        }
        .task {
            messageStore.addListener(chatID: chat.id)
            messageStore.removeListenerMessages()
            messageStore.fetchMessages(chatID: chat.id)
            
        }
        .onDisappear {
            messageStore.removeListener()
        }
    }
    
    /// 1. 리스너로 배열에 추가를 한뒤, 로컬로 정렬하는 과정을 거친다
    /// 2. 처음 들어갔을 때는 전체 패치, addListener를 하면서 한번 더 추가된 애들은 제거한다 -> 채택
    
    // MARK: Button : 메세지 수정
    private var updateContentButton : some View {
        Button {
            isShowingUpdateCell = true
        } label: {
            Text("수정하기")
            Image(systemName: "pencil")
        }
    }
    
    // MARK: Button : 메세지 삭제
    private var removeContentButton : some View {
        Button {
            
        } label: {
            Text("삭제하기")
            Image(systemName: "trash")
        }
    }
    
    // MARK: Section : 메세지 입력
    private var typeContentField : some View {
        HStack {
            Button {
                print("이미지 첨부 버튼 탭")
            } label: {
                Image(systemName: "photo.tv")
            }
            Button {
                print("레포지토리 선택 버튼 탭")
            } label: {
                Image("RepositoryIcon")
            }
            
            TextField("Enter Message",text: $contentField)
                .textFieldStyle(.roundedBorder)
            
            addContentButton
                .disabled(contentField.isEmpty)
        }
        .foregroundColor(.primary)
    }
    
    // MARK: Button : 메세지 추가(보내기)
    private var addContentButton : some View {
        // MARK: Logic : 메세지 전송 버튼 입력 시 일련의 로직 수행
        /// 새 메세지 셀 생성
        /// 채팅방 입장 시 가져온 Chat으로 새 Chat 생성 + 이번에 입력한 메세지 내용과 입력 시간으로 업데이트
        /// DB 메세지 Collection에 추가, Chat Collection에서 기존 Chat 업데이트
        /// 메세지 입력 필드 공백으로 초기화
        Button {
            let newMessage = makeMessage()
            let newChat = Chat(id: chat.id,
                               date: chat.date,
                               users: (chat.users.senderID, chat.users.receiverID),
                               lastDate: Date(),
                               lastContent: contentField,
                               knockContent: chat.knockContent,
                               knockDate: chat.knockDate)
            messageStore.addMessage(newMessage, chatID: chat.id)
            chatStore.updateChat(newChat)
            contentField = ""
            
        } label: {
            Image(systemName: "location")
        }
    }
    
    // MARK: -Method : Message 인스턴스를 만들어서 반환하는 함수
    private func makeMessage() -> Message {
        
        let message = Message(id: UUID().uuidString,
                                userID: Utility.loginUserID,
                                content: contentField,
                                date: Date())
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
                messageStore.updateMessage(message, chatID: chatID)
                isShowingUpdateCell = false
            } label: {
                Text("수정하기")
                Image(systemName: "pencil")
            }
            
        }
        .padding(.horizontal, 20)
        .onAppear {
            changeContentField = message.content
        }
    }
}
