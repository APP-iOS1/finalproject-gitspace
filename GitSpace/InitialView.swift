//
//  InitialView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/08.
//

import SwiftUI

struct InitialView: View {
    @ObservedObject var githubAuthManager: GitHubAuthManager = GitHubAuthManager.shared
    let tabBarRouter: GSTabBarRouter
    
    var body: some View {
        switch githubAuthManager.state {
        case .signedIn:
            ContentView(tabBarRouter: tabBarRouter)
                .environmentObject(AuthStore())
                .environmentObject(ChatStore())
                .environmentObject(MessageStore())
                .environmentObject(UserStore())
                .environmentObject(TabManager())
                .environmentObject(RepositoryStore())
        case .signedOut:
            SigninView()
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static let tabBarRouter = GSTabBarRouter()
    static var previews: some View {
        InitialView(tabBarRouter: tabBarRouter)
    }
}
