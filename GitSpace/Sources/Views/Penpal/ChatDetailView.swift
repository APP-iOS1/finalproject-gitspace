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
            Section {
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
            
            
            Section {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: UIScreen.main.bounds.width - 60, height: 5)
                    .foregroundColor(Color(.systemGray5))
                    .padding(.vertical, 15)
                
                Text("오늘")
                    .foregroundColor(Color(uiColor: .systemGray4))
                    .padding(.bottom, 15)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 250, height: 80)
                    .foregroundColor(Color(uiColor: .systemGray3))
                    .overlay(alignment : .bottomTrailing) {
                        Text("17:53")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .offset(x: 35)
                    }
                    .offset(x: -40)
                    .padding(.bottom, 20)
                    
                    
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 250, height: 80)
                    .foregroundColor(.yellow)
                    .overlay(alignment : .bottomLeading) {
                        VStack {
                            Text("5분 전에 읽음")
                                .offset(x: -15)
                            Text("17:54")
                                
                        }
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .offset(x: -50)
                            
                    }
                    .offset(x: 40)
                    .padding(.bottom, 20)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 250, height: 80)
                    .foregroundColor(.yellow)
                    .overlay(alignment : .bottomLeading) {
                        Text("18:01")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .offset(x: -35)
                    }
                    .offset(x: 40)
                    .padding(.bottom, 20)
                
            }
            
            Spacer()
            
            
        }
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChatDetailView()
    }
}
