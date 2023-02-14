//
//  AppDelegate+Firebase.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
	public var pushNotificationManager: PushNotificationManager? = nil
	public let tabBarRouter = GSTabBarRouter()
	
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
		
		//		/*
		//		 1. Launch Option을 제공
		//		 */
		//		let notificationOption = launchOptions?[.remoteNotification]
		//		if let notification = notificationOption as? [String: AnyObject],
		//		   let aps = notification["aps"] as? [String: AnyObject] {
		//			print(#function, "+++++++", aps)
		//		}
		
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
		print("DEBUG: register Error -\(#file)-\(#function): \(error.localizedDescription)")
	}
	
	/* 메시지 토큰 등록 성공 */
	func messaging(_ messaging: Messaging,
				   didReceiveRegistrationToken fcmToken: String?) {
		guard let fcmToken else { return }
		
		// Save Device Token with Init PushNotificationManager
		pushNotificationManager = PushNotificationManager(
			currentUserDeviceToken: fcmToken
		)
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
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		/*
		 1. 유저가 알람을 탭하면 이 메소드가 호출된다.
		 2. 심어둔 data를 꺼내서 decode 한다.
		 3. data의 navigateTo 에 따라 뷰를 open 한다.
		 */
		let userInfo = response.notification.request.content.userInfo
		
		do {
			let pushNotificationData = try JSONSerialization.data(withJSONObject: userInfo)
			let pushNotificationInfo = try JSONDecoder().decode(GSPushNotification.self, from: pushNotificationData)
			
			// 탭 이동 + 뷰 그릴 때 id 전달
			if pushNotificationInfo.navigateTo == "knock" {
				tabBarRouter.currentPage = .pushKnocks(id: pushNotificationInfo.viewBuildID)
			} else if pushNotificationInfo.navigateTo == "chat" {
				tabBarRouter.currentPage = .pushChats(id: pushNotificationInfo.viewBuildID)
			}
		} catch {
			print("Error-\(#file)-\(#function): \(error.localizedDescription)")
		}
		
		completionHandler()
	}
	
	//	/* Push Notification의 data Field를 받아오는 메소드 */
	//	func application(
	//		_ application: UIApplication,
	//		didReceiveRemoteNotification userInfo: [AnyHashable : Any],
	//		fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
	//	) {
	//		print(userInfo)
	//
	//		completionHandler(UIBackgroundFetchResult.newData)
	//	}
}
