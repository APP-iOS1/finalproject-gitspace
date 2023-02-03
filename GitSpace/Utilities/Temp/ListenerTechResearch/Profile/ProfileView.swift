//
//  ProfileView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/28.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authStore : AuthStore
    var body: some View {
        Button {
            authStore.logout()
        } label: {
            Text("로그아웃 하기")
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
