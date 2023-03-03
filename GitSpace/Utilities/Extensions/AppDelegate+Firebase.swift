//
//  AppDelegate+Firebase.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

final class AppDelegate: NSObject, UIApplicationDelegate {
	public let tabBarRouter = GSTabBarRouter()
	public var pushNotificationManager: PushNotificationManager = PushNotificationManager(currentUserDeviceToken: "Init")
	public var deviceToken = "NULL"
	
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
		
		print(#function, deviceToken)
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
		self.deviceToken = fcmToken
		
		// Save Device Token with Init PushNotificationManager
		pushNotificationManager.setCurrentUserDeviceToken(token: fcmToken)
	}
}

// MARK: - 알람 처리 메소드 구현
extension AppDelegate: UNUserNotificationCenterDelegate {
	
	/* Foreground에서만 호출되며, 탭 이후의 동작은 하단의 didReceive 메소드로 처리한다. */
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		/* 앱이 포어그라운드에서 실행될 때 도착한 알람 처리 */
		// 포어그라운드일 때 && 현재 채팅 중일때 알람 보여주지 않기 -> 열거형으로 상태 정리 필요
		// 우선 푸쉬쪽 정리 끝내고 해야할듯
		let userInfo = notification.request.content.userInfo
		print(#function, "+++ willPresent: FOREGROUND")
		
		do {
			let pushNotificationData = try JSONSerialization.data(withJSONObject: userInfo)
			let pushNotificationInfo = try JSONDecoder().decode(GSPushNotification.self, from: pushNotificationData)
			
			// 탭 이동 + 뷰 그릴 때 id 전달
			if pushNotificationInfo.navigateTo == "knock" {
				UIApplication.shared.applicationIconBadgeNumber += pushNotificationInfo.aps.badge
				completionHandler([.banner])
			} else if pushNotificationInfo.navigateTo == "chat" {
				UIApplication.shared.applicationIconBadgeNumber += pushNotificationInfo.aps.badge
				completionHandler([.banner])
			}
		} catch {
			print("Error-\(#file)-\(#function): \(error.localizedDescription)")
		}
	}

	/* 전달 알림에 대한 사용자 응답을 처리하도록 대리인에 요청 */
	/* Foreground && Background에서 호출된다. */
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		didReceive response: UNNotificationResponse,
		withCompletionHandler completionHandler: @escaping () -> Void
	) {
		/*
		 1. 유저가 백그라운드, 포어그라운드 환경에서 알람을 탭하면 이 메소드가 호출된다.
		 2. Notification에 심어둔 data를 꺼내서 decode 한다.
		 3. data의 navigateTo 에 따라 해당 뷰로 Route 한다.
		 */
		let userInfo = response.notification.request.content.userInfo
		
		do {
			let pushNotificationData = try JSONSerialization.data(withJSONObject: userInfo)
			let pushNotificationInfo = try JSONDecoder().decode(GSPushNotification.self, from: pushNotificationData)
			
			// 탭 이동 + 뷰 그릴 때 id 전달
			// 모델이 뷰를 그릴 ID 정보를 가져간 후, 탭을 이동시킨다.
			// 동시에, 모델은 ID로 fetch를 진행하고,
			// 뷰는 fetch 된 정보를 참조하여 뷰를 그린다.
			// !!!: - TABBARROUTER 이동 + Navilink active가 동시 작동할 경우 에러 발생 수정 필요.
			if pushNotificationInfo.navigateTo == "knock" {
				UIApplication.shared.applicationIconBadgeNumber -= pushNotificationInfo.aps.badge
				pushNotificationManager.assignViewBuildID(pushNotificationInfo.viewBuildID)
//				tabBarRouter.currentPage = .knocks
			} else if pushNotificationInfo.navigateTo == "chat" {
				UIApplication.shared.applicationIconBadgeNumber -= pushNotificationInfo.aps.badge
				pushNotificationManager.assignViewBuildID(pushNotificationInfo.viewBuildID)
//				tabBarRouter.currentPage = .chats
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
