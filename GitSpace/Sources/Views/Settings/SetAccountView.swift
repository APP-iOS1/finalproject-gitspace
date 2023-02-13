//
//  SetAccountView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetAccountView: View {
    var body: some View {
        List {
            // MARK: - APP MANAGEMENT
            Section {
                HStack {
                    Text("Username")
                    Spacer()
                    Text("\("wontaeyoung")")
                }
            } header: {
                Text("ACCOUNT INFORMATION")
            }
            
            Section {
                // MARK: Terms of Service
                /// 이용약관
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
                    print("로그아웃;; 할거임")
                } label: {
                    Text("Logout")
                }
                
                Button(role: .destructive) {
                    print("회원탈퇴;; 할거임")
                } label: {
                    Text("Delete Account")
                }

            } header: {
                Text("ACCOUNT MANAGEMENT")
            }
            
        } // List
        .navigationBarTitle("Account", displayMode: .inline)
    }
}

struct SetAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SetAccountView()
    }
}
