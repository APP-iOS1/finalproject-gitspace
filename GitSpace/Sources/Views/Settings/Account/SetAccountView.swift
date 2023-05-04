//
//  SetAccountView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetAccountView: View {
    
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @EnvironmentObject var blockedUsers: BlockedUsers
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false
    
    @EnvironmentObject private var chatViewModel: ChatStore
    @EnvironmentObject private var knockViewManager: KnockViewManager
    
    var body: some View {
        List {
            // MARK: - APP MANAGEMENT
            Section {
                HStack {
                    Text("Username")
                    Spacer()
                    Text("\(gitHubAuthManager.authenticatedUser?.login ?? "")")
                        .foregroundColor(.gsLightGray2)
                }
            } header: {
                Text("ACCOUNT INFORMATION")
            } // Section
            
            // MARK: Blocked Users
            /// 차단한 유저 리스트
            Section {
                NavigationLink {
                    BlockedUsersListView()
                } label: {
                    HStack {
                        Text("Blocked users")
                        Spacer()
                        Text("\(blockedUsers.blockedUserList.count)")
                            .foregroundColor(.gsLightGray2)
                    }
                }
            } // Section
            
            // MARK: Logout / Delete Account
            /// 로그아웃 / 계정 삭제
            Section {
                Button(role: .cancel) {
                    showingLogoutAlert.toggle()
                } label: {
                    Text("Logout")
                }
                
                Button(role: .destructive) {
                    showingDeleteAccountAlert.toggle()
                } label: {
                    Text("Delete Account")
                }

            } header: {
                Text("ACCOUNT MANAGEMENT")
            } // Section
            
        } // List
        .navigationBarTitle("Account", displayMode: .inline)
        .alert("Logout", isPresented: $showingLogoutAlert) {
              Button("Logout", role: .destructive) {
                  gitHubAuthManager.signOut()
              }
        } message: {
            Text("Logout from ") + Text("@\(gitHubAuthManager.authenticatedUser?.login ?? "") ").bold() + Text("account.")
        }
        .alert("Delete Account", isPresented: $showingDeleteAccountAlert) {
              Button("Delete", role: .destructive) {
                  Task {
                      await gitHubAuthManager.deleteCurrentUser()
                      await gitHubAuthManager.withdrawal()
                      reset()
                  }
              }
        } message: {
            Text("@\(gitHubAuthManager.authenticatedUser?.login ?? "") ").bold() + Text("account would be deleted.")
        }
    }
    
    private func reset() {
        chatViewModel.removeChatList()
        knockViewManager.removeKnockList()
    }
}

struct SetAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SetAccountView()
    }
}
