//
//  ContentView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // FIXME: Listener 채팅방 테스트를 위한 기존 탭뷰 주석처리 by. 예슬
         TabView {
            NavigationView {
                MainHomeView()
            }
            .tabItem {
                Image(systemName: "house")
            }
            
            NavigationView {
                ChatView()
            }
            .tabItem {
                Image(systemName: "bubble.right")
            }
            
            NavigationView {
                MainProfileView()
            }
            .tabItem {
                Image(systemName: "person")
                //Image("그사람프사")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
