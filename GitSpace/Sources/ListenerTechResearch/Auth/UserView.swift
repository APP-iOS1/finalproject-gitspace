//
//  UserView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

struct UserView: View {
    
    @EnvironmentObject var userStore : UserStore
    @EnvironmentObject var chatStore : ChatStore
    
    var body: some View {
        
        ScrollView {
            ForEach(userStore.users) { user in
                NavigationLink {
                    ChatDetailView()
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
