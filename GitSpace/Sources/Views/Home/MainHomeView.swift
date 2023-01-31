//
//  MainHomeView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct MainHomeView: View {
    @State private var selectedHomeTab = "Starred"
    private let starTab = "Starred"
    private let activityTab = "Activity"
	
    var body: some View {
		VStack {
            /* Starred, Activity Tab Button */
            HStack {
                GSButton.CustomButtonView(
                    style: .homeTab(
                        tabName: starTab,
                        tabSelection: $selectedHomeTab
                    )
                ) {
                    withAnimation {
                        selectedHomeTab = starTab
                    }
                } label: {
                    Text(starTab)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .bold()
                }
                .tag(starTab)
                
                GSButton.CustomButtonView(
                    style: .homeTab(
                        tabName: activityTab,
                        tabSelection: $selectedHomeTab
                    )
                ) {
                    withAnimation {
                        selectedHomeTab = activityTab
                    }
                } label: {
                    Text(activityTab)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .bold()
                }
                .tag(activityTab)
                
                Spacer()
            }
            .overlay(alignment: .bottom) {
                Divider()
                    .frame(minHeight: 0.5)
                    .overlay(Color.primary)
                    .offset(y: 3.5)
            }
            .padding(16)
            
            
//			HStack {
//				Button {
//					withAnimation(.easeIn(duration: 0.2)) {
//						tabSelection = "star"
//					}
//				} label: {
//                    if tabSelection == "star" {
//                        Text("Starred")
//                            .foregroundColor(.black)
//                            .font(.title2)
//                            .bold()
//                    } else {
//                        Text("Starred")
//                            .foregroundColor(Color(.systemGray))
//                            .font(.title2)
//                            .bold()
//                    }
//				}
//                .frame(minWidth: 80)
//
//				Button {
//                    withAnimation(.easeIn(duration: 0.2)) {
//                        tabSelection = "follow"
//                    }
//				} label: {
//                    if tabSelection == "star" {
//                        Text("Activity")
//                            .foregroundColor(Color(.systemGray))
//                            .font(.title2)
//                            .bold()
//                    } else {
//                        Text("Activity")
//                            .foregroundColor(.black)
//                            .font(.title2)
//                            .bold()
//                    }
//				}
//
//                Spacer()
//			}
//            .padding([.horizontal, .top], 10)
			
			TabView(selection: $selectedHomeTab) {
				StarredView()
					.tag("Starred")
				FollowingView()
					.tag("Activity")
			}
			.tabViewStyle(.page)
		}
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Text("GitSpace")
                    .font(.title2)
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
        NavigationView {
            MainHomeView()
        }
    }
}
