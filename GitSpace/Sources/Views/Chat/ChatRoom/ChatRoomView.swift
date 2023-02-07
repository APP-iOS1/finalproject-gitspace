//
//  ChatDetailView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

// MARK: -View : 채팅방 뷰
struct ChatRoomView: View {
    
    let chat: Chat
    
    @EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var messageStore: MessageStore
    @State var isShowingUpdateCell: Bool = false
    @State private var contentField: String = ""
    @State private var targetName: String = ""
    
    var body: some View {
        
        VStack {
            // 채팅 메세지 스크롤 뷰
            ScrollViewReader { proxy in
                ScrollView {
                    
                    TopperProfileView()
                    
                    Divider()
                        .padding(.vertical, 20)
                    
                    ChatDetailKnockSection(chat: chat)
                    
                    messageCells
                        .padding(.top, 10)
                        .padding(.horizontal, 10)
                    
                    Text("")
                        .id("bottom")
                        
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        proxy.scrollTo("bottom", anchor: .bottomTrailing)
                    }
                }
                .onChange(of: messageStore.messageAdded) { state in
                    proxy.scrollTo("bottom", anchor: .bottomTrailing)
                }
            }
            // 메세지 입력 필드
            typeContentField
                .padding(20)
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                HStack(spacing: 10) {
                    ProfileAsyncImage(size: 30)
                    Text(targetName)
                        .bold()
                        .padding(.horizontal, -8)
                }
            }
        }
        .task {
            messageStore.addListener(chatID: chat.id)
            messageStore.removeListenerMessages()
            messageStore.fetchMessages(chatID: chat.id)
            targetName = await chat.targetUserName
        }
        .onDisappear {
            messageStore.removeListener()
        }
    }
    
    // MARK: View : message cells ForEach문
    private var messageCells: some View {
        ForEach(messageStore.messages) { message in
            MessageCell(message: message, targetName: targetName)
                .contextMenu {
                    /* FIXME: 업데이트 sheet에서 타겟 Message를 정확하게 받아오지 못하는 이슈가 있어서 주석처리 By.태영
                    Button {
                        self.currentMessage = message
                        isShowingUpdateCell = true
                    } label: {
                        Text("수정하기")
                        Image(systemName: "pencil")
                    }
                     */
                    
                    Button {
                        messageStore.removeMessage(message,
                                                   chatID: chat.id)
                    } label: {
                        Text("삭제하기")
                        Image(systemName: "trash")
                    }
                }
            /* FIXME: 업데이트 sheet에서 타겟 Message를 정확하게 받아오지 못하는 이슈가 있어서 주석처리 By.태영
                .sheet(isPresented: $isShowingUpdateCell) {
                    ChangeContentSheetView(isShowingUpdateCell: $isShowingUpdateCell,
                                           chatID: chat.id,
                                           message: message)
                }
             */
        }
    }
    
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
        HStack(spacing: 10) {
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
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .onSubmit {
                    addContent()
                }
            
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
            addContent()
        } label: {
            Image(systemName: "location")
        }
    }
    
    // MARK: -Methods
    // MARK: Method : 메세지 전송에 대한 DB Create와 Update를 처리하는 함수
    private func addContent() {
        let newMessage = makeMessage()
        let newChat = makeChat()
        messageStore.addMessage(newMessage, chatID: chat.id)
        Task{
            await chatStore.updateChat(newChat)
        }
        contentField = ""
    }
    
    // MARK: Method : Chat 인스턴스를 만들어서 반환하는 함수
    private func makeChat() -> Chat {
        
        let chat = Chat(id: chat.id,
                        date: chat.date,
                        senderID: chat.senderID,
                        receiverID: chat.receiverID,
                        lastDate: Date(),
                        lastContent: contentField,
                        knockContent: chat.knockContent,
                        knockDate: chat.knockDate)
        return chat
    }
    
    // MARK: Method : Message 인스턴스를 만들어서 반환하는 함수
    private func makeMessage() -> Message {
        
        let message = Message(id: UUID().uuidString,
                                userID: Utility.loginUserID,
                                content: contentField,
                                date: Date())
        return message
    }
}



