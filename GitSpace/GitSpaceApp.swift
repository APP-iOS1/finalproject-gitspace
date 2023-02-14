//
//  GitSpaceApp.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

@main
struct GitSpaceApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let tabBarRouter = GSTabBarRouter()    
    

    var body: some Scene {
		let tabBarRouter = delegate.tabBarRouter
		let notificationRouter = delegate.pushNotificationRouter
		
        WindowGroup {
			VStack {
				Text("")
			}
            //            ContentView(tabBarRouter: tabBarRouter)
            //                .environmentObject(AuthStore())
            //                .environmentObject(ChatStore())
            //                .environmentObject(MessageStore())
            //                .environmentObject(UserStore())
            //                .environmentObject(TabManager())
            //                .environmentObject(RepositoryStore())
        }
    }
}
