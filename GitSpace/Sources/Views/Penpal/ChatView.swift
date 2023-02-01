//
//  ChatView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

struct ChatView: View {
    
    @EnvironmentObject var chatStore : ChatStore
    
    var body: some View {
        
        VStack {
            ChatRecommandCardSection()
				.padding()
            
            Divider()
            
            ChatListSection()
        }
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Text("GitSpace")
					.font(.title2)
					.bold()
			}
			
			ToolbarItem(placement: .navigationBarTrailing) {
				NavigationLink {
					KnockBoxView()
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



