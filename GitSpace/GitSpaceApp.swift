//
//  GitSpaceApp.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
		
		// 메세징 델리겟
		Messaging.messaging().delegate = self
		
		// 원격 알림 등록
		if #available(iOS 10.0, *) {
			// For iOS 10 display notification (sent via APNS)
			UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
			
			let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
			
			UNUserNotificationCenter.current().requestAuthorization(
				options: authOptions,
				completionHandler: { _, _ in }
			)
		} else {
			let settings: UIUserNotificationSettings =
			UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
			application.registerUserNotificationSettings(settings)
		}
		
		application.registerForRemoteNotifications()
		
		// 푸시 포그라운드 설정
		UNUserNotificationCenter.current().delegate = self
        return true
    }
}

// MARK: - FCM 메시지 및 토큰 관리
extension AppDelegate: MessagingDelegate {
	/* 메시지 토큰 등록 완료 */
	func application(_ application: UIApplication,
					 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		print(#function, "+++ didRegister Success", deviceToken)
//		Messaging.messaging().apnsToken = deviceToken
		Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
	}
	
	/* 메시지 토큰 등록 실패 */
	func application(_ application: UIApplication,
					 didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print(#function, "DEBUG: +++ register error: \(error.localizedDescription)")
	}
	
	func messaging(_ messaging: Messaging,
				   didReceiveRegistrationToken fcmToken: String?) {
		print(#function, "Messaging")
		let deviceToken: [String: String] = ["token" : fcmToken ?? ""]
		print(#function, "+++ Device Test Token", deviceToken)
		
	}
}

// MARK: - 알람 처리 메소드 구현
extension AppDelegate: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								willPresent notification: UNNotification,
								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		/* 앱이 포어그라운드에서 실행될 때 도착한 알람 처리 */
		let userInfo = notification.request.content.userInfo
		
		print(#function, "+++ willPresent: userInfo: ", userInfo)
		
		completionHandler([.banner, .sound, .badge])
	}
	
	/* 전달 알림에 대한 사용자 응답을 처리하도록 대리인에 요청 */
	func userNotificationCenter(_ center: UNUserNotificationCenter,
								didReceive response: UNNotificationResponse,
								withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
		print(#function, "+++ didReceive: userInfo: ", userInfo)
		completionHandler()
	}
}

@main
struct GitSpaceApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let tabBarRouter = GSTabBarRouter()
    
    
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
        WindowGroup {
            InitialView(tabBarRouter: tabBarRouter)
                .environmentObject(ChatStore())
                .environmentObject(MessageStore())
                .environmentObject(UserStore())
                .environmentObject(RepositoryViewModel())
                .environmentObject(GitHubAuthManager())
                .preferredColorScheme(selectedAppearance)
        }
    }
}
