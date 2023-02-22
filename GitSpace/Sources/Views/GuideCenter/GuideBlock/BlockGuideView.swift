//
//  BlockGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/07.
//

import SwiftUI

struct BlockGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("사용자를 차단하거나 차단 해제하기")
                            .font(.system(size: 22, weight: .light))
                        
                        Spacer()  
                    }
                    
                    Divider()
                    
                    Text(
"""
GitSpace에서 회원님이 부정적인 경험을 했기 때문에 이 페이지로 이동했을 수 있습니다. 온라인 활동이 복잡해지면 불편하다는 점을 저희도 잘 알고 있습니다. GitSpace에서 다른 사람과 언쟁하거나 불쾌감을 주는 대화를 할 수 있습니다.

이 페이지에 나와 있는 자료는 GitSpace에서 겪을 수 있는 갈등을 해결하는 데 도움이 될 수 있습니다. 이 해결책이 도움이 되기를 바랍니다.

회원님이나 회원님의 지인이 위급한 상황에 있다면 즉시 현지 사법당국에 연락하시기 바랍니다.
""")
                    .padding(.vertical)
                    
                    Text("차단하기")
                        .font(.title2)
                        .bold()
                    
                    Text(
"""
1. 사용자를 차단합니다.
""")
                    Text("차단 해제하기")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    Text(
"""
1. 사용자 차단을 해제합니다.
""")
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("Block")
    } // body
}

struct BlockGuideView_Previews: PreviewProvider {
    static var previews: some View {
        BlockGuideView()
    }
}
