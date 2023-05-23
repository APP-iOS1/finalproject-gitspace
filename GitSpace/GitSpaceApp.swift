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
		let pushNotificationManager = delegate.pushNotificationManager
		
        WindowGroup {
            // !!!: - FCM Test를 진행할 때만 각주를 해제합니다.
            // PushNotificationTestView()

            InitialView(tabBarRouter: tabBarRouter)
                .environmentObject(ChatStore())
                .environmentObject(UserStore())
                .environmentObject(MessageStore())
                .environmentObject(RepositoryViewModel(service: GitHubService()))
                .environmentObject(TagViewModel())
                .environmentObject(GitHubAuthManager())
                .environmentObject(KnockViewManager())
                .environmentObject(FollowingViewModel(service: GitHubService()))
                .environmentObject(FollowerViewModel(service: GitHubService()))
                .environmentObject(tabBarRouter)
				.environmentObject(pushNotificationManager)
                .environmentObject(BlockedUsers())
				.onAppear {
					UIApplication.shared.applicationIconBadgeNumber = 0
				}
        }
    }
}
