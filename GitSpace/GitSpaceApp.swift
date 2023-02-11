//
//  GitSpaceApp.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging

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
        /*
         1. 유저가 알람을 탭하면 이 메소드가 호출된다.
         2. 심어둔 data를 꺼내서 decode 한다.
         */
        let userInfo = response.notification.request.content.userInfo
        print(#function, "+++ didReceive: userInfo: ", userInfo)
        
        do {
            let newData = try JSONSerialization.data(withJSONObject: userInfo)
            let newStruct = try JSONDecoder().decode(GSPushNotification.self, from: newData)
            //			let newStruct = try JSONDecoder().decode(GSNotification.self, from: newData)
            
            print(#function, "++++", newStruct.gsNotification)
        } catch {
            dump(error.localizedDescription)
            dump(error)
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

@main
struct GitSpaceApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let tabBarRouter = GSTabBarRouter()
    private let endpoint = Bundle.main.object(forInfoDictionaryKey: "PUSH_NOTIFICATION_ENDPOINT") as? String
    
    
    @State var selectedTab = TabIdentifier.star
    
    var body: some Scene {
        WindowGroup {
            
            VStack {
                
                if let endpoint {
                    Text("https://\(endpoint)")
                }
                Button {
                    Task {
                        let instance = PushNotificationManager()
                        await instance.sendPushNoti(url: "https://\(endpoint ?? "")")
                    }
                } label: {
                    Text("Send")
                }
            }
            
            TabView(selection: $selectedTab) {
                
                NavigationView {
                    VStack {
                        
                        if let endpoint {
                            Text("https://\(endpoint)")
                        }
                        Button {
                            Task {
                                let instance = PushNotificationManager()
                                await instance.sendPushNoti(url: "https://\(endpoint ?? "")")
                            }
                        } label: {
                            Text("Send")
                        }
                    }
                } // NaviView
                .tabItem {
                    VStack {
                        Image(systemName: "star")
                        Text("STAR")
                    }
                }
                .tag(TabIdentifier.star)
                
                NavigationView {
                    List {
                        Section {
                            NavigationLink {
                                Text("page 1")
                            } label: {
                                Text("page 1")
                            }
                            
                            NavigationLink {
                                Text("page 2")
                            } label: {
                                Text("page 2")
                            }
                            
                            NavigationLink {
                                Text("page 3")
                            } label: {
                                Text("page 3")
                            }
                        }
                    }
                } // NaviView
                .tabItem {
                    VStack {
                        Image(systemName: "message")
                        Text("CHAT")
                    }
                }
                .tag(TabIdentifier.chat)
                
                NavigationView {
                    List {
                        Section {
                            NavigationLink {
                                Text("page 4")
                            } label: {
                                Text("page 4")
                            }
                            
                            NavigationLink {
                                Text("page 5")
                            } label: {
                                Text("page 5")
                            }
                            
                            NavigationLink {
                                Text("page 6")
                            } label: {
                                Text("page 6")
                            }
                        }
                    }
                } // NaviView
                .tabItem {
                    VStack {
                        Image(systemName: "hand.raised")
                        Text("KNOCK")
                    }
                }
                .tag(TabIdentifier.knock)
            }
            .onOpenURL(perform: { url in
                // MARK: - 들어온 URL 처리
                guard let tabId = url.tabIdentifier else { return }
                selectedTab = tabId
            })
            
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

// MARK: - 어떤 탭이 선택되었는지 여부
enum TabIdentifier: Hashable {
    case star
    case chat
    case knock
    case profile
}

// MARK: - 어떤 페이지를 보여줘야 하는지
enum PageIdentifier: Hashable {
    case pageItem(id: UUID)
}

extension URL {
    
    // MARK: - Info에서 추가한 딥링크가 들어왔는지 여부
    var isDeeplink: Bool {
        return scheme == "gitspace-ios"
    }
    
    // MARK: - URL 들어오는 것으로 어떤 타입의 탭을 보여줘야 하는지 가져오기
    var tabIdentifier: TabIdentifier? {
        guard isDeeplink else { return nil }
        
        /// gitspace-ios://host
        switch host {
        case "star":
            return .star
        case "chat":
            return .chat
        case "knock":
            return .knock
        case "profile":
            return .profile
        default: return nil
        }
    }
    
    var detailPage: PageIdentifier? {
        
        /// gitspace-ios://host/detailpage
        /// -> host: pathcomponents 1개
        /// -> host/detailpage: pathcomponents 2개
        guard let tabId = tabIdentifier,
              pathComponents.count > 1,
              let uuid = UUID(uuidString: pathComponents[1])
        else { return nil }
        
        switch tabId {
        case .star:
            return .pageItem(id: uuid)
        case .chat:
            return .pageItem(id: uuid)
        case .knock:
            return .pageItem(id: uuid)
        case .profile:
            return .pageItem(id: uuid)
        default: return nil
        }
    }
}
