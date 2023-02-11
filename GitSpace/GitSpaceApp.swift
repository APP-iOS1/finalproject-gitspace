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
	private let endpoint = Bundle.main.object(forInfoDictionaryKey: "PUSH_NOTIFICATION_ENDPOINT") as? String
	
    var body: some Scene {
		let tabBarRouter = delegate.tabBarRouter
		
        WindowGroup {
			PushNotificationTestView()
            ContentView(tabBarRouter: tabBarRouter)
                .environmentObject(AuthStore())
                .environmentObject(ChatStore())
                .environmentObject(MessageStore())
                .environmentObject(UserStore())
                .environmentObject(TabManager())
                .environmentObject(RepositoryStore())
        }
    }
}
