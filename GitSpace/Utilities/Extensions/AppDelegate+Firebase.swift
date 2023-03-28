//
//  AppDelegate+Firebase.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

final class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
	public let tabBarRouter = GSTabBarRouter()
    
    @Published var isSentKnockView: Bool = false
    
    @ObservedObject public var pushNotificationManager: PushNotificationManager = PushNotificationManager(
        currentUserDeviceToken: UserDefaults.standard.string(
            forKey: Constant.PushNotification.USER_DEVICE_TOKEN)
    )
	
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
				completionHandler: { didAllow, error in
                    if didAllow {
                        print("PUSHNOTIFICATION: ALLOWED")
                    } else {
                        print("PUSHNOTIFICATION: DECLINED")
                    }
                }
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
        
		Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
	}
	
	/* 메시지 토큰 등록 실패 */
	func application(_ application: UIApplication,
					 didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("DEBUG: register Error -\(#file)-\(#function): \(error.localizedDescription)")
	}
	
	/* 메시지 FCM Device Token 등록 성공 */
	func messaging(_ messaging: Messaging,
				   didReceiveRegistrationToken fcmToken: String?) {
		guard let fcmToken else { return }
        UserDefaults.standard.set(fcmToken, forKey: Constant.PushNotification.USER_DEVICE_TOKEN)
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
		
		do {
			let pushNotificationData = try JSONSerialization.data(withJSONObject: userInfo)
			let pushNotificationInfo = try JSONDecoder().decode(GSPushNotification.self, from: pushNotificationData)
            
            print("++++ OUT SCOPE", pushNotificationInfo.viewBuildID, pushNotificationManager.currentChatRoomID)
            
			// 탭 이동 + 뷰 그릴 때 id 전달
			if pushNotificationInfo.navigateTo == "knock" {
				UIApplication.shared.applicationIconBadgeNumber += pushNotificationInfo.aps.badge
                completionHandler([.banner, .sound])
			} else if pushNotificationInfo.navigateTo == "chat" {
                // 할당된 현재의 메세지 ID와 푸시로 들어온 값의 ID가 동일하다 == 현재 유저가 푸시가 온 화면에 있다.
                if pushNotificationInfo.viewBuildID == pushNotificationManager.currentChatRoomID {
                    print("++++ OUT SCOPE", pushNotificationInfo.viewBuildID, pushNotificationManager.currentChatRoomID)
                    // 알람 비우기
                    completionHandler([])
                }
				UIApplication.shared.applicationIconBadgeNumber += pushNotificationInfo.aps.badge
                completionHandler([.banner, .sound])
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
		let userInfo = response.notification.request.content.userInfo
		
		do {
			let pushNotificationData = try JSONSerialization.data(withJSONObject: userInfo)
			let pushNotificationInfo = try JSONDecoder().decode(GSPushNotification.self, from: pushNotificationData)
			
			if pushNotificationInfo.navigateTo == "knock" {
				UIApplication.shared.applicationIconBadgeNumber -= pushNotificationInfo.aps.badge
				pushNotificationManager.assignViewBuildID(pushNotificationInfo.viewBuildID)
                if let currentUserDeviceToken = pushNotificationManager.currentUserDeviceToken {
                    if currentUserDeviceToken == pushNotificationInfo.sentDeviceToken {
                        tabBarRouter.currentPage = .knocks
                        pushNotificationManager.isNavigatedToSentKnock.toggle()
                        isSentKnockView.toggle()
                        print("didReceive ++ ", pushNotificationManager.isNavigatedToSentKnock, isSentKnockView)
                    } else if currentUserDeviceToken != pushNotificationInfo.sentDeviceToken {
                        pushNotificationManager.isNavigatedToReceivedKnock.toggle()
                    }
                }
			} else if pushNotificationInfo.navigateTo == "chat" {
				UIApplication.shared.applicationIconBadgeNumber -= pushNotificationInfo.aps.badge
				pushNotificationManager.assignViewBuildID(pushNotificationInfo.viewBuildID)
			}
		} catch {
			print("Error-\(#file)-\(#function): \(error.localizedDescription)")
		}
		
		completionHandler()
	}
}
