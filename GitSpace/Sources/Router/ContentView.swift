//
//  ContentView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    
    let stars = MainHomeView()
    let chats = MainChatView()
    let knocks = MainKnockView()
    let profile = MainProfileView()
    
    @StateObject var tabBarRouter: GSTabBarRouter
	@EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var githubAuthManager: GitHubAuthManager
	@EnvironmentObject var pushNotificationManager: PushNotificationManager
    
    var body: some View {
        /**
         현재 라우팅 하고있는 page에 따라서
         상단에는 해당 page에 대응하는 view를 보여주고
         하단에는 tabBar를 보여준다.
         */
        GeometryReader { geometry in
            NavigationView {
                
                if UIScreen().isWiderThan375pt {
                    VStack(spacing: -10) {
                        showCurrentTabPage()
                        showGSTabBar(geometry: geometry)
                    }
                    .edgesIgnoringSafeArea(.horizontal)
                    .edgesIgnoringSafeArea(.bottom)
                } else {
                    VStack(spacing: -10) {
                        showCurrentTabPage()
                        showGSTabBar(geometry: geometry)
                    }
                }
                    
                
                
            }
        }
        .task {
            // Authentication의 로그인 유저 uid를 받아와서 userStore의 유저 객체를 할당
            if let uid = githubAuthManager.authentification.currentUser?.uid {
				await userStore.updateUserDeviceToken(
					userID: uid,
					deviceToken: pushNotificationManager.currentUserDeviceToken
					?? "PUSHNOTIFICATION NOT GRANTED"
				)
				// userInfo 할당
                await userStore.requestUser(userID: uid)
				
            } else {
                print("Error-ContentView-requestUser : Authentication의 uid가 존재하지 않습니다.")
            }
        }
    }
    
    /**
     현재 선택된 tabPage에 따라 탭페이지를 보여준다.
     반환되는 View의 타입이 tabPage에 따라 다르기 때문에 ViewBuilder를 사용해준다.
     - Author: 제균
     */
    @ViewBuilder private func showCurrentTabPage() -> some View {
		if let tabPagenation = tabBarRouter.currentPage {
			switch tabPagenation {
			case .stars:
				stars
			case .chats:
				chats
			case let .pushChats(id):
				MainChatView(chatID: id)
			case .knocks:
				knocks
			case let .pushKnocks(id):
				MainKnockView(knockID: id)
			case .profile:
				profile
			}
		} else {
			stars
		}
    }
    
    /**
     탭바를 보여준다.
     */
    private func showGSTabBar(geometry: GeometryProxy) -> some View {
        return GSTabBarBackGround.CustomTabBarBackgroundView(style: .rectangle(backGroundColor: .black)) {
            GSTabBarIcon(tabBarRouter: tabBarRouter, page: .stars, geometry: geometry, isSystemImage: true, imageName: "sparkles", tabName: "Stars")
            GSTabBarIcon(tabBarRouter: tabBarRouter, page: .chats, geometry: geometry, isSystemImage: true, imageName: "bubble.left", tabName: "Chats")
            GSTabBarIcon(tabBarRouter: tabBarRouter, page: .knocks, geometry: geometry, isSystemImage: true, imageName: "door.left.hand.closed", tabName: "Knocks")
            GSTabBarIcon(tabBarRouter: tabBarRouter, page: .profile, geometry: geometry, isSystemImage: false, imageName: "avatarImage", tabName: "Profile")
        }
        .frame(width: geometry.size.width, height: 60)
//        .padding(.bottom, 20)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tabBarRouter: GSTabBarRouter())
            .environmentObject(ChatStore())
            .environmentObject(MessageStore())
            .environmentObject(UserStore())
            .environmentObject(RepositoryViewModel())
            .environmentObject(TagViewModel())
    }
}
