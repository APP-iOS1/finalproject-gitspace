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
    
    var body: some View {
        /**
         현재 라우팅 하고있는 page에 따라서
         상단에는 해당 page에 대응하는 view를 보여주고
         하단에는 tabBar를 보여준다.
         */
        GeometryReader { geometry in
            NavigationView {
                VStack(spacing: -10) {
                    showCurrentTabPage()
                    showGSTabBar(geometry: geometry)
                }
                .edgesIgnoringSafeArea(.horizontal)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    /**
     현재 선택된 tabPage에 따라 탭페이지를 보여준다.
     반환되는 View의 타입이 tabPage에 따라 다르기 때문에 ViewBuilder를 사용해준다.
     - Author: 제균
     */
    @ViewBuilder private func showCurrentTabPage() -> some View {
        switch tabBarRouter.currentPage {
        case .stars:
            stars
        case .chats:
            chats
        case .knocks:
            knocks
        case .profile:
            profile
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
                .padding(.bottom, 20)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tabBarRouter: GSTabBarRouter())
            .environmentObject(ChatStore())
            .environmentObject(MessageStore())
            .environmentObject(UserStore())
            .environmentObject(RepositoryViewModel())
    }
}
