//
//  InitialView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/08.
//

import SwiftUI

struct InitialView: View {
    @EnvironmentObject var githubAuthManager: GitHubAuthManager
    let tabBarRouter: GSTabBarRouter
    
    var body: some View {
        switch githubAuthManager.state {
        case .signedIn:
            ContentView(tabBarRouter: tabBarRouter)
        case .signedOut:
            SigninView(githubAuthManager: githubAuthManager)
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static let tabBarRouter = GSTabBarRouter()
    static var previews: some View {
        InitialView(tabBarRouter: tabBarRouter)
    }
}
