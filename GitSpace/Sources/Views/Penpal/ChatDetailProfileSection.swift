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
            AsyncImage(url: URL(string: "https://w.namu.la/s/fb074c9e538edb0b41d818df3cb7b5499a844aeb5e8becc3ce1664468c885d883e8a8243a33eefc11e107b8d7dbbf77a410d78675770117a6654984ebe73f2f2eb846d97e660cdc8ab76067ddad22f9574647c8b25eaf5022f4f481b458094b9")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width : 100)
            } placeholder: {
                // 불러오는 중입니다...
                Text("Loading...")
            }
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
