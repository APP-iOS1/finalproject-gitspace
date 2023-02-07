//
//  ActivityGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/08.
//

import SwiftUI

struct ActivityGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Follow한 유저의 활동을 볼 수 있어요!")
                            .font(.system(size: 22, weight: .light))
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text(
"""
한 번 보고, 두 번 보고, 자꾸만 보고 싶은 레포지토리! Star하여 두고두고 계속 봅시다! Star에 대해 궁금한 점이 생기거나 팁이 필요할 때 언제든지 자유롭게 참고하세요.
""")
                    .padding(.vertical)
                    
                    Text("Star하기")
                        .font(.title2)
                        .bold()
                    
                    Text(
"""
1. 레포지토리 우측 상단의 별 모양 아이콘을 눌러주세요.
""")
                    
                    Text("UnStar하기")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    Text(
"""
1. 레포지토리 우측 상단의 별 모양 아이콘을 눌러주세요.
""")
                    
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("Star")
    } // body
}

struct ActivityGuideView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGuideView()
    }
}
