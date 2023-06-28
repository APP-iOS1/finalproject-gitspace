//
//  ChatDetailKnockSection.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/01.
//

import SwiftUI

struct ChatDetailKnockSection: View {
    
    @Environment(\.colorScheme) var colorScheme
    let chat: Chat
    
    var body: some View {
        VStack(spacing: 10) {
            GSText.CustomTextView(style: .sectionTitle, string: chat.knockContentDateAsString)
                .padding(.bottom, 10)
            
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 3, height: 15)
                    .foregroundColor(
                        colorScheme == .light
                        ? .gsGreenPrimary
                        : .gsYellowPrimary
                    )
                Text("Knock Message")
                    .font(.footnote)
                    .foregroundColor(.gsLightGray1)
                    .bold()
                
                Spacer()
            }
            .padding(.leading, 20)
            
            GSCanvas.CustomCanvasView(style: .primary) {
                HStack {
                    Spacer()
                    GSText.CustomTextView(style: .body1, string: chat.knockContent)
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

