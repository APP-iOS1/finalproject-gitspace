//
//  SigninView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/08.
//

import SwiftUI

struct SigninView: View {
//    @Environment(\.dismiss) var dismiss
    @StateObject var githubAuthManager: GitHubAuthManager
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image("GitSpace-Activity")
                    .padding(.top, 20)
                GSText.CustomTextView(style: .title1, string: "Hello, GitSpacer!")
                GSText.CustomTextView(style: .body1, string: "Welcome to GitSpace.")
                    .padding(5)
            }
            
            Spacer()
            
            GSButton.CustomButtonView(
                style: .primary(isDisabled: false)
            ) {
                print("signin button tapped")
                githubAuthManager.signIn()
//                githubAuthManager.state = .signedIn
            } label: {
                Text("**GitHub Signin**")
            }
            .padding()

        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView(githubAuthManager: GitHubAuthManager())
    }
}
