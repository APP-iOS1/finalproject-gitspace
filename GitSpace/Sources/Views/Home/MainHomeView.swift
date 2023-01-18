//
//  MainHomeView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct MainHomeView: View {
	@State private var tabSelection = "star"
	
    var body: some View {
		VStack {
			HStack {
				Button {
					tabSelection = "star"
				} label: {
					Text("star")
				}
				
				Button {
					tabSelection = "follow"
				} label: {
					Text("follow")
				}
			}
			
			TabView(selection: $tabSelection) {
				StarredView()
					.tag("star")
				FollowingView()
					.tag("follow")
			}
			.tabViewStyle(.page)
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Text("GitSpace")
					.bold()
			}
			
			ToolbarItem(placement: .navigationBarTrailing) {
				NavigationLink {
					Text("알람뷰")
				} label: {
					Image(systemName: "bell")
				}
			}
		}
    }
}

struct MainHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MainHomeView()
    }
}
