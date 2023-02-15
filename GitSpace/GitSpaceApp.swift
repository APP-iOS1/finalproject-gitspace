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
        
    var body: some Scene {
		let tabBarRouter = delegate.tabBarRouter
		let notificationManager = delegate.pushNotificationManager
		
        WindowGroup {
            // !!!: - FCM Test를 진행할 때만 각주를 해제합니다.
            // PushNotificationTestView()

            InitialView(tabBarRouter: tabBarRouter)
                .environmentObject(ChatStore())
                .environmentObject(MessageStore())
                .environmentObject(UserStore())
                .environmentObject(RepositoryViewModel())
                .environmentObject(TagViewModel())
                .environmentObject(GitHubAuthManager())
                .environmentObject(KnockViewManager())
                .environmentObject(tabBarRouter)
				.environmentObject(notificationManager)
				.onAppear {
					UIApplication.shared.applicationIconBadgeNumber = 0
				}
        }
    }
}
