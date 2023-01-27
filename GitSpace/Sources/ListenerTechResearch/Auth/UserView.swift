//
//  UserView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

// TODO: 이거 얘기해야 됨
/// 1. userList에서 타겟 채팅방 체크를 언제할지. 이거 ChatDetailView에서 Chat을 옵셔널로 할지도 고려!!
///

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var userStore : UserStore
    @EnvironmentObject var chatStore : ChatStore
    
    var body: some View {
        
        ScrollView {
            ForEach(userStore.users) { user in
                NavigationLink {
                    ChatDetailView(chat : chatStore.)
                } label: {
                    <#code#>
                }
            }
        }
        .task
        
        

    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
