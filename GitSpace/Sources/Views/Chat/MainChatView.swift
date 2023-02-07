//
//  ChatView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

struct MainChatView: View {
    
    @EnvironmentObject var chatStore : ChatStore
    
    var body: some View {
        
        ScrollView {
            ChatUserRecommendationSection()
				.padding()
            
            Divider()
            
            ChatListSection()
        }
        // FIXME: - 추후 네비게이션 타이틀 지정 (작성자: 제균)
        .navigationTitle("")
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Text("GitSpace")
					.font(.title2)
					.bold()
			}
			
			ToolbarItem(placement: .navigationBarTrailing) {
				NavigationLink {
					MainKnockView()
				} label: {
					Image(systemName: "archivebox")
						.foregroundColor(.primary)
				}
			}
			
//			ToolbarItem(placement: .navigationBarTrailing) {
//				NavigationLink {
//					NewKnockView()
//				} label: {
//					Image(systemName: "plus.message")
//						.foregroundColor(.primary)
//				}
//			}
		}
        
    }
}



