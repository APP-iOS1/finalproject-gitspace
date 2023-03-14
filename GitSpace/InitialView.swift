//
//  InitialView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/08.
//

import SwiftUI
import FirebaseAuth

struct InitialView: View {
    @EnvironmentObject var githubAuthManager: GitHubAuthManager
    @EnvironmentObject var pushNotificationManager: PushNotificationManager
    let tabBarRouter: GSTabBarRouter
    
    // MARK: - 한호
    @AppStorage("systemAppearance") private var systemAppearance: Int = AppearanceType.allCases.first!.rawValue

    var selectedAppearance: ColorScheme? {
        guard let appearance = AppearanceType(rawValue: systemAppearance) else { return nil }
        
        switch appearance {
        case .light:
            return .light
        case .dark:
            return .dark
        default:
            return nil
        }
    }
    
    var body: some View {
        switch githubAuthManager.state {
        case .signedIn:
            ContentView(tabBarRouter: tabBarRouter)
                .preferredColorScheme(selectedAppearance)
				.environmentObject(UserStore(currentUserID: Auth.auth().currentUser?.uid ?? ""))
        case .signedOut:
            SigninView(githubAuthManager: githubAuthManager, tabBarRouter: tabBarRouter)
                .preferredColorScheme(selectedAppearance)
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static let tabBarRouter = GSTabBarRouter()
    static var previews: some View {
        InitialView(tabBarRouter: tabBarRouter)
    }
}
