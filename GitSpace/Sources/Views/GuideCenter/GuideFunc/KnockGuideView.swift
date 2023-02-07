//
//  KnockGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/04.
//

import SwiftUI

struct KnockGuideView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("정중한 대화의 시작, 노크에 대한 모든 것.")
                            .font(.system(size: 22, weight: .light))
                        
                        Spacer()
                        
                        
                    }
                    
                    Divider()
                    
                    Text(
"""
정중한 대화의 시작, 노크에 대한 모든 것을 하나의 목록으로 정리해 보았습니다. 궁금한 점이 생기거나 팁이 필요할 때 언제든지 자유롭게 참고하세요.
""")
                    .padding(.vertical)
                    
                    Text("노크하기")
                        .font(.title2)
                        .bold()
                    
                    Text(
"""
1. 대화 하고 싶은 상대를 선택합니다.
2. 대화의 목적을 선택합니다.
3. 노크 메세지를 작성합니다.
4. 상대방이 당신의 노크를 승인하면 대화를 시작할 수 있어요!
""")
                    
                    Text("노크 응답하기")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    Text(
"""
1. 응답할 노크를 선택합니다.
2. 대화를 승인할 지, 거절할 지 아니면 차단할 지 선택합니다.
3. 다음과 같이 의심스럽거나 부적절한 행동은 발견 즉시 신고해 주세요.
    - 금전 요구
    - 괴롭힘 또는 협박
    - 스팸
""")
                    
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("Knock")
        } // NavigationView
    } // body
}

struct KnockGuideView_Previews: PreviewProvider {
    static var previews: some View {
        KnockGuideView()
    }
}
