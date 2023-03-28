//
//  SetAccountView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetAccountView: View {
    
    @EnvironmentObject var GitHubAuthManager: GitHubAuthManager
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false
    
    var body: some View {
        List {
            // MARK: - APP MANAGEMENT
            Section {
                HStack {
                    Text("Username")
                    Spacer()
                    Text("\(GitHubAuthManager.authenticatedUser?.login ?? "")")
                        .foregroundColor(.gsLightGray2)
                }
            } header: {
                Text("ACCOUNT INFORMATION")
            } // Section
            
            // MARK: Blocked Users
            /// 차단한 유저 리스트
//            Section {
//                NavigationLink {
//
//                } label: {
//                    HStack {
//                        Text("Blocked Users")
//                        Spacer()
//                        Text("\(0)")
//                            .foregroundColor(.gsLightGray2)
//                    }
//                }
//            } // Section
            
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
                  GitHubAuthManager.signOut()
              }
        } message: {
            Text("Logout from ") + Text("@\(GitHubAuthManager.authenticatedUser?.login ?? "") ").bold() + Text("account.")
        }
        .alert("Delete Account", isPresented: $showingDeleteAccountAlert) {
              Button("Delete", role: .destructive) {
                  Task {
                      await GitHubAuthManager.deleteCurrentUser()
                      await GitHubAuthManager.withdrawal()
                  }
              }
        } message: {
            Text("@\(GitHubAuthManager.authenticatedUser?.login ?? "") ").bold() + Text("account has been deleted.")
        }
    }
}

struct SetAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SetAccountView()
    }
}
