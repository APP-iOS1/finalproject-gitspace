//
//  PenpalInfoView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/18.
//

import SwiftUI

struct PenpalInfoView: View {
    
    @State private var notificationStop : Bool = false
    @State private var isBlocked : Bool = false
    @State private var showingBlockAlert : Bool = false
    @State private var showingUnblockAlert : Bool = false
    @State private var showingDeleteChatAlert : Bool = false
    @State private var showingBlockMessage : Bool = false
    @State private var showingDeleteMessage : Bool = false
    
    var body: some View {
        VStack {
            Section{
                AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/45925685?v=4")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 80)
                } placeholder: {
                    ProgressView()
                }
                Text("Taeyoung Won")
                    .bold()
                    .padding(.horizontal, -8)
                
                Text("@wontaeyoung")
                    .foregroundColor(Color(uiColor: .systemGray))
                
                Divider()
                    .padding(.horizontal, -10)
            }
            
            Section {
                
                VStack(alignment: .leading) {
                    // 알림
                    Text("Notifications")
                        .font(.title3)
                        .bold()
                    
                    // 알림 일시중지
                    Toggle("Snooze notifications", isOn: $notificationStop)
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
                Text("\(isBlocked ? "Unblock" : "Block") @wontaeyoung")
            }
            .padding(.vertical, 20)

            Button(role: .destructive) {
                showingDeleteChatAlert.toggle()
            } label: {
                Text("Delete conversation")
            }

            Spacer()
        }
        .overlay(alignment: .bottom) {
            if showingBlockMessage {
                Text(isBlocked ? "Blocked" : "Unblocked")
                    .font(.largeTitle.bold())
            } else if showingDeleteMessage {
                Text("Conversation has been deleted.")
                    .font(.largeTitle.bold())
            }
        }
        .padding(.horizontal, 20)
        .alert("Block @wontaeyoung", isPresented: $showingBlockAlert) {
            Button("Block", role: .destructive) {
                isBlocked.toggle()
                showingBlockMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showingBlockMessage = false
                }
            }
        } message: {
//상대방을 차단하면 상대방이 보내는 메세지를 더 이상 볼 수 없습니다. 차단하시겠습니까?
            Text("@wontaeyoung will no longer be able to follow or message you, and you will not see notificatinos from @wontaeyoung")
        }
        .alert("Unblock @wontaeyoung", isPresented: $showingUnblockAlert) {
            Button("Unblock", role: .destructive) {
                isBlocked.toggle()
                showingBlockMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showingBlockMessage = false
                }
            }
        } message: {
            // 차단을 해제하면 상대방이 보내는 메세지를 다시 받을 수 있습니다. 차단 해체하시겠습니까?
            Text("@wontaeyoung will be able to follow or message you, and you will see notificatinos from @wontaeyoung")
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

struct PenpalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PenpalInfoView()
    }
}
