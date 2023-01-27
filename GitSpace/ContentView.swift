//
//  ContentView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authStore: AuthStore
    
    var body: some View {
        Group {
            if authStore.isLogin {
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
