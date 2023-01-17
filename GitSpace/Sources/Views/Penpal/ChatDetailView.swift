//
//  ChatDetailView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/17.
//

import SwiftUI

struct ChatDetailView: View {
    var body: some View {
        VStack {
            
            Divider()
            
            AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/45925685?v=4")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width : 100)
            } placeholder: {
                Text("불러오는 중입니다...")
            }
            .padding(.vertical, 10)
            .padding(.top, 10)

            
            Text("Taeyoung Won")
                .bold()
                .padding(.vertical, 20)
            
            Text("wontaeyoung,")
            Text("starred 3 repos,")
            Text("Airbnb-swift Repository Owner")
            
            
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailView()
    }
}
