//
//  ContentView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authStore: AuthStore
    @EnvironmentObject var tabManager: TabManager
    
    
    var body: some View {
        Group {
            if authStore.isLogin {
                
                TabView() {
                    NavigationView {
                        UserView()
                    }
                    .tabItem {
                        Image(systemName: "person.3.fill")
                    }
                    
                    
                    NavigationView {
                        ChatView()
                    }
                    .tabItem {
                        Image(systemName: "message.fill")
                    }
					
					NavigationView {
						MyKnockBoxView()
					}
					.tabItem {
						Image(systemName: "archivebox")
					}
                    
                    NavigationView {
                        ProfileView()
                    }
                    .tabItem {
                        Image(systemName: "gear")
                    }
                    
                }
                /* FIXME: Listener 채팅방 테스트를 위한 기존 탭뷰 주석처리 by. 예슬
                 TabView {
                    NavigationView {
                        ChatListView()
                    }
                    .tabItem {
                        Image(systemName: "house")
                    }
                    
                    
                    NavigationView {
                        PenpalListView()
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
                 */
            } else {
                NavigationView {
                    LoginView()
                }
            }
                
        }
        .task {
            if authStore.currentUser != nil {
                authStore.isLogin = true
            }
        }
        
		
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
