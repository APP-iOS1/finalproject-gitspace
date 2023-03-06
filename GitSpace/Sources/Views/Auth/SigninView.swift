//
//  SigninView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/08.
//

import SwiftUI

struct SigninView: View {
    @StateObject var githubAuthManager: GitHubAuthManager
    @StateObject var tabBarRouter: GSTabBarRouter
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Image("GitSpace-Signin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
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
                tabBarRouter.currentPage = .stars
            } label: {
                Text("**GitHub Signin**")
            }
            .padding(.bottom, 30)

        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView(githubAuthManager: GitHubAuthManager(), tabBarRouter: GSTabBarRouter())
    }
}
