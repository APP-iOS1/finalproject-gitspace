//
//  ChatRoomScrollFeatView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/16.
//


import SwiftUI

struct ChatRoomScrollFeatView: View {
    
    let user1 = "A"
    let user2 = "B"
    let chat = Chat.init(id: "1", createdDate: Date.now, joinedMemberIDs: ["A","B"], lastContent: "50", lastContentDate: Date.init(timeIntervalSince1970: 50), knockContent: "처음 뵙겠습니다. A입니다.", knockContentDate: Date.init(timeIntervalSince1970: 1) , unreadMessageCount: ["A" : 15, "B" : 0])
    
    @State var messages: [Message] = []
    @State private var contentField: String = ""
    @State private var isMessageAdded: Bool = false
    @State private var unreadFirstIndex: Int = 0
    @State private var isMessageFetchDone: Bool = false
    
    
    var body: some View {
        NavigationView {
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
                    .task {
                        for i in 1...50 {
                            let newMessage: Message = .init(id: String(i), senderID: "B", textContent: String(i), imageContent: nil, sentDate: Date.init(timeIntervalSince1970: Double(i)), isRead: false)
                            messages.append(newMessage)
                            print(i)
                            if i == 50 {
                                isMessageFetchDone = true
                            }
                        }
                        unreadFirstIndex = getFirstIndexOfUnreadMessages()
                        
                    }
                    .onChange(of: isMessageFetchDone) { isDone in
                        proxy.scrollTo("Start", anchor: .top)
                    }
                    .onChange(of: isMessageAdded) { state in
                        proxy.scrollTo("bottom", anchor: .bottomTrailing)
                    }
                }
                
                Divider()
                    .padding(.vertical, -8)
                
                // 메세지 입력 필드
                typeContentField
                    .padding(.vertical, -3)
                    .padding(.horizontal, 15)
            }
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    HStack(spacing: 15) {
                        ProfileAsyncImage(size: 25)
                        Text("B")
                            .bold()
                            .padding(.horizontal, -8)
                    }
                }
            }
        }
    }
    
    // MARK: View : message cells ForEach문
    private var messageCells: some View {
        ForEach(messages.indices, id: \.self) { index in
            if index == unreadFirstIndex {
                MessageCell(message: messages[index], targetName: "B")
                    .padding(.vertical, -5)
                    .id("Start")
            } else {
                MessageCell(message: messages[index], targetName: "B")
                    .padding(.vertical, -5)
            }
                
        }
    }
    
    // MARK: Section : 메세지 입력
    private var typeContentField : some View {
        HStack(spacing: 10) {
            Button {
                print("이미지 첨부 버튼 탭")
            } label: {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 30)
            }
            Button {
                print("레포지토리 선택 버튼 탭")
            } label: {
                Image("RepositoryIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 23)
            }
            
            GSTextEditor.CustomTextEditorView(style: .message, text: $contentField)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            addContentButton
                .disabled(contentField.isEmpty)
        }
        .foregroundColor(.primary)
    }
    
    // MARK: Button : 메세지 추가(보내기)
    private var addContentButton : some View {
        Button {
            Task {
                await addContent()
            }
        } label: {
            Image(systemName: contentField.isEmpty ? "paperplane" : "paperplane.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundColor(contentField.isEmpty ? .gsGray2 : .primary)
        }
    }
    
    // MARK: -Methods
    // MARK: Method - 메세지 전송에 대한 DB Create와 Update를 처리하는 함수
    private func addContent() async {
        // MARK: Logic : 메세지 전송 버튼 입력 시 일련의 로직 수행
        /// 새 메세지 셀 생성
        /// 채팅방 입장 시 가져온 Chat으로 새 Chat 생성 + 이번에 입력한 메세지 내용과 입력 시간으로 업데이트
        /// DB 메세지 Collection에 추가, Chat Collection에서 기존 Chat 업데이트
        /// 메세지 입력 필드 공백으로 초기화
        let newMessage = makeMessage()
        messages.append(newMessage)
        contentField = ""
    }
    
    private func getFirstIndexOfUnreadMessages() -> Int {
        let messagesCount = messages.count
        let firstIndex = messagesCount - (chat.unreadMessageCount["A"] ?? 0)
        
        return firstIndex
    }
    
    // MARK: Method : Message 인스턴스를 만들어서 반환하는 함수
    private func makeMessage() -> Message {
        
        let newMessage = Message.init(id: UUID().uuidString,
                                      senderID: Utility.loginUserID,
                                      textContent: contentField,
                                      imageContent: nil,
                                      sentDate: Date.now,
                                      isRead: false)
        return newMessage
    }
}

struct ChatRoomScrollFeatView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatRoomScrollFeatView()
    }
}

