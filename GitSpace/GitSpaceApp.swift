//
//  GitSpaceApp.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

@main
struct GitSpaceApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // MARK: - 한호
    // TODO: - AppStorage 관련된 변수들 다른 곳에 옮기기 by.한호
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
    // MARK: -
    
    
    var body: some Scene {
		let tabBarRouter = delegate.tabBarRouter
		let notificationRouter = delegate.pushNotificationRouter
		let notificationManager = delegate.pushNotificationManager
		
        WindowGroup {
			VStack {
				PushNotificationTestView()
				
				InitialView(tabBarRouter: tabBarRouter)
					.environmentObject(ChatStore())
					.environmentObject(MessageStore())
					.environmentObject(UserStore())
					.environmentObject(RepositoryViewModel())
					.environmentObject(GitHubAuthManager())
					.environmentObject(KnockViewManager())
					.environmentObject(tabBarRouter)
					.preferredColorScheme(selectedAppearance)
			}
        }
    }
}
