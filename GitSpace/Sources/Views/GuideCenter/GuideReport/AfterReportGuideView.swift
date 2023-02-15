//
//  AfterReportGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/16.
//

import SwiftUI

struct AfterReportGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("What Happens After I Report?")
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
                    
                    Text("온라인")
                        .font(.title2)
                        .bold()
                    
                    Text(
"""
GitSpace는 탐험을 즐기는 모험가들을 위한 곳이지 돈 거래를 위한 곳이 아닙니다. 여러분의 금융 정보를 묻는 사람이 있다면 단호하게 거절하고 이 사실을 GitSpace에 알려주세요. 프로필에 이러한 개인정보를 공개하거나 나의 개인정보를 요청하는 회원은 GitSpace에 신고해주시기 바랍니다.
""")
                    
                    Text("괴롭힘을 당한 경우 신고하세요.")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    Text(
"""
GitSpace는 괴롭힘과 관련된 모든 신고건을 엄중하게 인식하고 있으며 회원들도 같은 마음으로 행동해 주길 기대합니다. 불쾌한 메시지를 보내는 사람이 있다면 꼭 GitSpace에 알려 주세요. 거기서부터는 **제굴맨**이 처리하겠습니다.
""")
                    Text("답장을 하지 않는다고 해서 신고하지는 마세요.")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    Text(
"""
노크 메세지를 보냈지만 응답이 없을 때가 있어요. 그리고 노크를 승낙한 상대에게 메시지를 보냈는데 답장이 오지 않을 때가 있습니다. 상대에게 궁금한 것이 너무나도 많지만 답장이 없으니 답답하죠. 업무가 바쁠수도, 실수로 승낙했을 수도, 아니면 그냥 답장하고 싶지 않은 것일 수도 있겠지만 어쨌든 정확한 이유는 알 수가 없어요. 이럴 땐 적당한 자기 합리화가 도움이 될 거예요. 신고 대신 새로운 탐험가를 찾아 모험을 떠나 보세요.
""")
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("After Report")
    } // body
}

struct AfterReportGuideView_Previews: PreviewProvider {
    static var previews: some View {
        AfterReportGuideView()
    }
}
