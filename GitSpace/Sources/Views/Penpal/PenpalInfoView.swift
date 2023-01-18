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
    @Binding var naviIsActive: Bool
    
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

            Button(role: .destructive) {
                showingDeleteChatAlert.toggle()
            } label: {
                Text("대화 삭제")
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .alert("차단하기", isPresented: $showingBlockAlert) {
            Button("차단", role: .destructive) {
                
            }
        } message: {
            Text("메세지를 삭제하면 상대방과 나 모두 이 메세지를 볼 수 없습니다. 삭제하시겠습니까?")
        }
    }
}

struct PenpalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PenpalInfoView(naviIsActive: .constant(false))
    }
}
