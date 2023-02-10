//
//  PenpalInfoView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/18.
//

import SwiftUI

struct ChatRoomInfoView: View {
    
    let chatID: String
    let targetName: String // 음... 그러면 유저 ID나 객.......... 로그인한 유저 객체? 패치받아야되나
    @State var isBlocked: Bool // UserInfo에서 blockedUserIDs를 통해서 계산해서 init 필요
    @State var isNotificationReceiveEnable: Bool // UserDefault에서 읽어와서 할당해야 함
    
    @State private var showingBlockAlert: Bool = false
    @State private var showingUnblockAlert: Bool = false
    @State private var showingDeleteChatAlert: Bool = false
    @State private var showingBlockMessage: Bool = false
    @State private var showingDeleteMessage: Bool = false
    
    var body: some View {
        VStack {
            Section{
                TopperProfileView()
                
                Divider()
                    .padding(.horizontal, -10)
            }
            
            Section {
                
                VStack(alignment: .leading) {
                    // 알림
                    GSText.CustomTextView(style: .title2,
                                          string: "Notification")
                    
                    // 알림 일시중지
                    Toggle("Snooze notifications", isOn: $isNotificationReceiveEnable)
                }
                
                Divider()
                    .padding(.horizontal, -10)
            }
            
            Button {
                if isBlocked {
                    showingUnblockAlert.toggle()
                } else {
                    showingBlockAlert.toggle()
                }
                
            } label: {
                Text(isBlocked ? "Unblock" : "Block") +
                Text(" \(targetName)")
                    .bold()
            }
            .padding(.vertical, 20)

            Button(role: .destructive) {
                showingDeleteChatAlert.toggle()
            } label: {
                Text("Delete conversation")
                    .foregroundColor(.gsRed)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .onChange(of: isNotificationReceiveEnable, perform: { newValue in
            UserDefaults().set(newValue, forKey: Constant.AppStorageConst.CHATROOM_NOTIFICATION + chatID)
        })
        .alert("Block @\(targetName)", isPresented: $showingBlockAlert) {
            Button("Block", role: .destructive) {
                isBlocked.toggle()
                showingBlockMessage = true
            }
        } message: {
//상대방을 차단하면 상대방이 보내는 메세지를 더 이상 볼 수 없습니다. 차단하시겠습니까?
            Text("@\(targetName) will no longer be able to follow or message you, and you will not see notifications from @wontaeyoung")
        }
        .alert("Unblock @\(targetName)", isPresented: $showingUnblockAlert) {
            Button("Unblock", role: .destructive) {
                isBlocked.toggle()
                showingBlockMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showingBlockMessage = false
                }
            }
        } message: {
            // 차단을 해제하면 상대방이 보내는 메세지를 다시 받을 수 있습니다. 차단 해체하시겠습니까?
            Text("@\(targetName) will be able to follow or message you, and you will see notifications from @\(targetName)")
        }
        .alert("Delete conversation?", isPresented: $showingDeleteChatAlert) {
            Button("Delete", role: .destructive) {
                showingDeleteMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showingDeleteMessage = false
                }
            }
        } message: {
            // 대화를 삭제하면 지금까지 한 대화가 모두 사라지며 복구할 수 없습니다. 삭제하시겠습니까?
            Text("This conversation will be deleted and cannot be recovered.\nAre you sure?")
        }
    }
}

struct ChatRoomInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomInfoView(chatID: "a", targetName: "test", isBlocked: false)
        
    }
}


