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
            }
            
            Section {
                // MARK: Blocked Users
                /// 차단한 유저 리스트
                NavigationLink {
                    
                } label: {
                    HStack {
                        Text("Blocked Users")
                        Spacer()
                        Text("\(0)")
                    }
                }
            }
            
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
            }
            
        } // List
        .navigationBarTitle("Account", displayMode: .inline)
        .alert("Logout", isPresented: $showingLogoutAlert) {
              Button("Logout", role: .destructive) {
                  print("[System] \(GitHubAuthManager.authenticatedUser?.login ?? "") 계정에서 로그아웃 합니다.")
                  GitHubAuthManager.signOut()
              }
        } message: {
            Text("Logout from ") + Text("\(GitHubAuthManager.authenticatedUser?.login ?? "") ").bold() + Text("account.")
        }
        .alert("메시지", isPresented: $showingDeleteAccountAlert) {
              Button("Delete", role: .destructive) {
                  print("[System] \(GitHubAuthManager.authenticatedUser?.login ?? "") 계정이 탈퇴 되었습니다.")
                  Task {
                      await GitHubAuthManager.deleteCurrentUser()
                      await GitHubAuthManager.withdrawal()
                  }
              }
        } message: {
            Text("\(GitHubAuthManager.authenticatedUser?.login ?? "")").bold() + Text("account has been deleted.")
        }
    }
}

struct SetAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SetAccountView()
    }
}
