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
    @State var isSignedIn: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack{
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
                            githubAuthManager.signin()
                            isSignedIn = true
                            tabBarRouter.currentPage = .stars
                        } label: {
                            Text("**GitHub Signin**")
                        }
                        .padding(.bottom, 30)
                        
                    }
                }
                HStack(alignment: .top) {
                    NavigationLink {
                        TermsOfServiceView()
                    } label: {
                        Text("By signin in you accept our ")
                            .foregroundColor(.primary)
                        +
                        Text("Terms of Use and Privacy policy.")
                    }
                }
                .font(.footnote)
                .padding(20)
            } // VStack
        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView(githubAuthManager: GitHubAuthManager(), tabBarRouter: GSTabBarRouter())
    }
}
