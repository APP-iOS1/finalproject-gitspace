//
//  LoadingProgressView.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/03/09.
//

import SwiftUI
import Lottie

struct LoadingProgressView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    /// 로그인 프로세스 동안 띄워 줄 로딩 뷰.
    /// 화면 전체에 overlay로 덮어 버튼 클릭을 막을 수 있다.
    /// 위에 올릴 View가 이 LoadingProgressView.swift 이다.
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                if colorScheme == .light {
                    LottieView(jsonName: "LoadingDots.json")
                        .padding(.top, 85)
                        .scaleEffect(1.3)
                        .background(.white)
                } else {
                    LottieView(jsonName: "LoadingDotsDark.json")
                        .padding(.top, 85)
                        .scaleEffect(1.3)
                        .background(.black)
                }
                
                Spacer()
            }
            
            VStack{
                Spacer()
                
                Image("GitSpace-Loading")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding(.bottom, 100)
                
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct LoadingProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingProgressView()
    }
}
