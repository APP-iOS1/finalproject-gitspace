//
//  ChatDetailKnockSection.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/01.
//

import SwiftUI

struct ChatDetailKnockSection: View {
    
    let chat: Chat
    
    var body: some View {
        VStack(spacing: 20) {
            Text(chat.stringKnockDate)
                .font(.caption)
                .foregroundColor(.gsLightGray2)
            HStack {
                Text("Knock Message")
                    .font(.caption)
                    .foregroundColor(.gsLightGray2)
                    .bold()
                Spacer()
            }
            
            Text("Hi! This is Gildong from South Korea who’s currently studying Web programming. Would you mind giving me some time and advising me on my future career path? Thank you so much for your help!")
                .modifier(KnockMessageModifier())
            
        }
    }
}

