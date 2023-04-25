//
//  BlockedUsersListView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/04/20.
//

import SwiftUI

struct BlockedUsersListView: View {
    var body: some View {
    func convertUserInfo() async {
        
        withAnimation(.easeInOut) {
            isLoaded = false
        }
        
        ScrollView {
        if let currentUser = await userInfoManager.requestUserInfoWithID(userID: userInfoManager.currentUser?.id ?? "") {
            
            for someUser in currentUser.blockedUserIDs {
                if let userInfo = await UserStore.requestAndReturnUser(userID: someUser) {
                    let gitHubUser = gitHubAuthManager.getGithubUser(FBUser: userInfo)
                    let blockedUser: (userInfo: UserInfo, gitHubUser: GithubUser) = (userInfo, gitHubUser)
                    
                    if !blockedUsers.blockedUserList.contains(where: { $0.userInfo.id == userInfo.id }) {
                        blockedUsers.blockedUserList.append(blockedUser)
                    }
                }
            }
        }
        
        withAnimation(.easeInOut) {
            isLoaded = true
        }
    }
}

struct BlockedUsersListView_Previews: PreviewProvider {
    static var previews: some View {
        BlockedUsersListView()
    }
}
