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
    @State private var showingForceUpdateAlert: Bool = false
    
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
        VStack {
            switch githubAuthManager.state {
            case .signedIn:
                ContentView(tabBarRouter: tabBarRouter)
                    .preferredColorScheme(selectedAppearance)
            case .pending:
                LoadingProgressView()
                    .preferredColorScheme(selectedAppearance)
            case .signedOut:
                SigninView(githubAuthManager: githubAuthManager, tabBarRouter: tabBarRouter)
                    .preferredColorScheme(selectedAppearance)
            }
        }
        .alert(
            "Notice: App Update",
            isPresented: $showingForceUpdateAlert,
            actions: {
                Button {
                    UIApplication.shared.open(URL(string: "https://apps.apple.com/kr/app/gitspace/id6446034470")!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                } label: {
                    Text("OK")
                }
            }, message: {
                Text("The latest version has been released. Please update it.")
            }
        )
        .onViewDidLoad {
            Task {
                let newVersionCheckResult = await AppStoreUpdateChecker.isNewVersionAvailable()
                
                switch newVersionCheckResult {
                case .success(let isNewVersionAvailable):
                    showingForceUpdateAlert = isNewVersionAvailable
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                if githubAuthManager.authentification.currentUser != nil
                    && UserDefaults.standard.string(forKey: "AT") != nil
                    && showingForceUpdateAlert == false {
                    await githubAuthManager.reauthenticateUser()
                    githubAuthManager.state = .signedIn
                }
            }
        }
    }
}

//struct InitialView_Previews: PreviewProvider {
//    static let tabBarRouter = GSTabBarRouter()
//    static var previews: some View {
//        InitialView(tabBarRouter: tabBarRouter)
//    }
//}
