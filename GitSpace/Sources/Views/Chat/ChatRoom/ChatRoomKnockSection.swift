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
            GSText.CustomTextView(style: .sectionTitle, string: chat.stringKnockContentDate)
            HStack {
                GSText.CustomTextView(style: .caption2, string: "**KnockMessage**")
                    .padding(.leading, 20)
                    
                Spacer()
            }
            
            GSCanvas.CustomCanvasView(style: .primary) {
                HStack {
                    Spacer()
                    GSText.CustomTextView(style: .body1, string: chat.knockContent)
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            
//            Text(chat.knockContent)
//                .modifier(KnockMessageModifier())
           
        }
    }
}

