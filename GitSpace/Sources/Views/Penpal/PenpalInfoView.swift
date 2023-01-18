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
                    Text("알림")
                        .font(.title3)
                        .bold()
                    
                    Toggle("알림 일시중지", isOn: $notificationStop)
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
                Text("@wontaeyoung \(isBlocked ? "차단 해제하기" : "차단하기")")
            }
            .padding(.vertical, 20)

            Button(role: .destructive) {
                showingDeleteChatAlert.toggle()
            } label: {
                Text("대화 삭제")
            }

            Spacer()
        }
        .overlay(alignment: .bottom) {
            if showingBlockMessage {
                Text(isBlocked ? "차단되었습니다" : "차단이 해제되었습니다")
                    .font(.largeTitle.bold())
            } else if showingDeleteMessage {
                Text("대화가 삭제되었습니다")
                    .font(.largeTitle.bold())
            }
        }
        .padding(.horizontal, 20)
        .alert("차단", isPresented: $showingBlockAlert) {
            Button("차단하기", role: .destructive) {
                isBlocked.toggle()
                showingBlockMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showingBlockMessage = false
                }
            }
        } message: {
            Text("상대방을 차단하면 상대방이 보내는 메세지를 더 이상 볼 수 없습니다.\n차단하시겠습니까?")
        }
        .alert("차단 해제", isPresented: $showingUnblockAlert) {
            Button("해제하기", role: .destructive) {
                isBlocked.toggle()
                showingBlockMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showingBlockMessage = false
                }
            }
        } message: {
            Text("차단을 해제하면 상대방이 보내는 메세지를 다시 받을 수 있습니다.\n차단 해제하시겠습니까?")
        }
        .alert("대화 삭제", isPresented: $showingDeleteChatAlert) {
            Button("삭제하기", role: .destructive) {
                showingDeleteMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showingDeleteMessage = false
                }
            }
        } message: {
            Text("대화를 삭제하면 지금까지 한 대화가 모두 사라지며 복구할 수 없습니다.\n삭제하시겠습니까?")
        }
    }
}

struct PenpalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PenpalInfoView()
    }
}
