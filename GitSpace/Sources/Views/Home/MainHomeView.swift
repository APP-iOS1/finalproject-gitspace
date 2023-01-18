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
					withAnimation(.easeIn(duration: 0.2)) {
						tabSelection = "star"
					}
				} label: {
                    if tabSelection == "star" {
                        Text("Starred")
                            .foregroundColor(.black)
                            .font(.title2)
                            .bold()
                    } else {
                        Text("Starred")
                            .foregroundColor(Color(.systemGray))
                            .font(.title2)
                            .bold()
                    }
				}
                .frame(minWidth: 80)
				
				Button {
                    withAnimation(.easeIn(duration: 0.2)) {
                        tabSelection = "follow"
                    }
				} label: {
                    if tabSelection == "star" {
                        Text("Activity")
                            .foregroundColor(Color(.systemGray))
                            .font(.title2)
                            .bold()
                    } else {
                        Text("Activity")
                            .foregroundColor(.black)
                            .font(.title2)
                            .bold()
                    }
				}
                
                Spacer()
			}
            .padding([.horizontal, .top], 10)
			
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
                    .font(.title)
					.bold()
			}
			
			ToolbarItem(placement: .navigationBarTrailing) {
				NavigationLink {
					Text("Notifications View")
				} label: {
					Image(systemName: "bell")
                        .foregroundColor(.black)
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
