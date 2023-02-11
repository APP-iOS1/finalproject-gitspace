//
//  PenpalInfoView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/18.
//

import SwiftUI

struct ChatRoomInfoView: View {
    
    let chat: Chat
    let targetUserName: String
    @State var isBlocked: Bool // UserInfo에서 blockedUserIDs를 통해서 계산해서 init 필요
    @State var isNotificationReceiveEnable: Bool // UserDefault에서 읽어와서 할당해야 함
    @State private var showingBlockAlert: Bool = false
    @State private var showingUnblockAlert: Bool = false
    @State private var showingDeleteChatAlert: Bool = false
    @EnvironmentObject var userStore: UserStore
    
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
                                          string: "Notifications")
                    
                    // 알림 일시중지
                    Toggle("Notifications Receive Enable", isOn: $isNotificationReceiveEnable)
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
                Text(" \(targetUserName)")
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
            UserDefaults().set([chat.id : newValue],
                               forKey: Constant.AppStorageConst.CHATROOM_NOTIFICATION)
        })
        .alert("Block @\(targetUserName)", isPresented: $showingBlockAlert) {
            Button("Block", role: .destructive) {
                isBlocked.toggle()
                Task {
                    await userStore.updateIsTartgetUserBlocked(blockCase:.block, targetUserID: chat.targetID)
                }
            }
        } message: {
            //상대방을 차단하면 상대방이 보내는 메세지를 더 이상 볼 수 없습니다. 차단하시겠습니까?
            Text("@\(targetUserName) will no longer be able to follow or message you, and you will not see notifications from @wontaeyoung")
        }
        .alert("Unblock @\(targetUserName)",
               isPresented: $showingUnblockAlert) {
            Button("Unblock",
                   role: .destructive) {
                isBlocked.toggle()
                Task {
                    await userStore.updateIsTartgetUserBlocked(blockCase:.unblock, targetUserID: chat.targetID)
                }
            }
        } message: {
            // 차단을 해제하면 상대방이 보내는 메세지를 다시 받을 수 있습니다. 차단 해체하시겠습니까?
            Text("@\(targetUserName) will be able to follow or message you, and you will see notifications from @\(targetUserName)")
        }
        .alert("Delete conversation?", isPresented: $showingDeleteChatAlert) {
            Button("Delete", role: .destructive) {
                print("대화방 삭제")
            }
        } message: {
            // 대화를 삭제하면 지금까지 한 대화가 모두 사라지며 복구할 수 없습니다. 삭제하시겠습니까?
            Text("This conversation will be deleted and cannot be recovered.\nAre you sure?")
        }
    }
}


