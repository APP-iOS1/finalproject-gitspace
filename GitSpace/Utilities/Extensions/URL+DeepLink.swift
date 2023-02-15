//
//  URL+DeepLink.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/14.
//

import SwiftUI

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
			// MARK: - APN 테스트할 때만 각주를 해제합니다.
			PushNotificationTestView()
			//            ContentView(tabBarRouter: tabBarRouter)
			//                .environmentObject(AuthStore())
			//                .environmentObject(ChatStore())
			//                .environmentObject(MessageStore())
			//                .environmentObject(UserStore())
			//                .environmentObject(TabManager())
			//                .environmentObject(RepositoryStore())
			//				.environmentObject(notificationRouter)
		}
	}
}

// MARK: - 딥링크 뷰
//struct DeeplinkView: View {
//	private let endpoint = Bundle.main.object(forInfoDictionaryKey: "PUSH_NOTIFICATION_ENDPOINT") as? String
//	@State private var selectedTab = TabIdentifier.star
//	
//	var body: some View {
//		VStack {
//			if let endpoint {
//				Text("https://\(endpoint)")
//			}
//			Button {
//				Task {
//					let instance = PushNotificationManager()
//					await instance.sendPushNoti(url: "https://\(endpoint ?? "")")
//				}
//			} label: {
//				Text("Send")
//			}
//		}
//		
//		TabView(selection: $selectedTab) {
//			NavigationView {
//				VStack {
//					
//					if let endpoint {
//						Text("https://\(endpoint)")
//					}
//					Button {
//						Task {
//							let instance = PushNotificationManager()
//							await instance.sendPushNoti(url: "https://\(endpoint ?? "")")
//						}
//					} label: {
//						Text("Send")
//					}
//				}
//			} // NaviView
//			.tabItem {
//				VStack {
//					Image(systemName: "star")
//					Text("STAR")
//				}
//			}
//			.tag(TabIdentifier.star)
//			
//			NavigationView {
//				List {
//					Section {
//						NavigationLink {
//							Text("page 1")
//						} label: {
//							Text("page 1")
//						}
//						
//						NavigationLink {
//							Text("page 2")
//						} label: {
//							Text("page 2")
//						}
//						
//						NavigationLink {
//							Text("page 3")
//						} label: {
//							Text("page 3")
//						}
//					}
//				}
//			} // NaviView
//			.tabItem {
//				VStack {
//					Image(systemName: "message")
//					Text("CHAT")
//				}
//			}
//			.tag(TabIdentifier.chat)
//			
//			NavigationView {
//				List {
//					Section {
//						NavigationLink {
//							Text("page 4")
//						} label: {
//							Text("page 4")
//						}
//						
//						NavigationLink {
//							Text("page 5")
//						} label: {
//							Text("page 5")
//						}
//						
//						NavigationLink {
//							Text("page 6")
//						} label: {
//							Text("page 6")
//						}
//					}
//				}
//			} // NaviView
//			.tabItem {
//				VStack {
//					Image(systemName: "hand.raised")
//					Text("KNOCK")
//				}
//			}
//			.tag(TabIdentifier.knock)
//		}
//		.onOpenURL(perform: { url in
//			// MARK: - 들어온 URL 처리
//			guard let tabId = url.tabIdentifier else { return }
//			selectedTab = tabId
//		})
//	}
//}
