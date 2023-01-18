//
//  ContentView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		TabView {
			NavigationView {
					MainHomeView()
			}
			.tabItem {
				Image(systemName: "house")
			}
			
			NavigationView {
				MainPenpalView()
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
