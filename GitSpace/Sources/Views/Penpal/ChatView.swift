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
            
            Divider()
            
            ChatListSection()
        }
        
    }
}



