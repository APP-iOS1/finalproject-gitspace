//
//  ChatDetailProfileSection.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/01.
//

import SwiftUI

struct ChatDetailProfileSection: View {
    
    let chat: Chat
    @Binding var targetName: String
    
    var body: some View {
        VStack {
            ProfileAsyncImage(size: 100)
                .padding(.vertical, 10)
                .padding(.top, 10)
            
            Text("@"+targetName)
                .font(.subheadline)
                .foregroundColor(.gsLightGray2)
                .padding(.bottom, 10)
            
            Text("you starred 1 repo(s) from them!")
                .font(.subheadline)
            
            Group {
                Text("Owner of") + Text("Airbnb-swift").bold()
            }
            .font(.subheadline)
            .foregroundColor(.gsLightGray2)
            
        }
    }
}


