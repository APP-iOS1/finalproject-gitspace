//
//  WhatToReportGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/16.
//

import SwiftUI

struct WhatToReportGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("When you should report someone on GitSpace and when you shouldn't.")
                            .font(.system(size: 22, weight: .light))
                        Spacer()
                    }

                    Divider()

                    Text(
"""
We make safety a top priority at GitSpace, and we want you to let us know about any suspicious behavior you see. To make our reporting process even more effective, we need everyone to know when you should report someone on GitSpace and when you shouldn't.

Help keep our community safe by reporting incidents that go against our community guidelines.

Here's what you need to know about reporting.
""")
                    .padding(.vertical)
                    
                    Text("Online")
                        .font(.title2)
                        .bold()

                    Text(
"""
 GitSpace is a place for adventurers who enjoy exploration, not for those seeking financial transactions. If someone asks for your financial information, please firmly refuse and inform GitSpace of the situation. Please report members who disclose such personal information on their profiles or request my personal information to GitSpace.
""")

// GitSpace는 탐험을 즐기는 모험가들을 위한 곳이지 돈 거래를 위한 곳이 아닙니다. 여러분의 금융 정보를 묻는 사람이 있다면 단호하게 거절하고 이 사실을 GitSpace에 알려주세요. 프로필에 이러한 개인정보를 공개하거나 나의 개인정보를 요청하는 회원은 GitSpace에 신고해주시기 바랍니다.

                    Text("If you have experienced harassment, please report it.")
                        .font(.title2)
                        .bold()
                        .padding(.top)

                    Text(
"""
GitSpace takes all reports of harassment very seriously and we expect our members to act with the same mindset. If someone is sending you unpleasant messages, please let GitSpace know and we will take care of it from there.
""")
// GitSpace는 괴롭힘과 관련된 모든 신고건을 엄중하게 인식하고 있으며 회원들도 같은 마음으로 행동해 주길 기대합니다. 불쾌한 메시지를 보내는 사람이 있다면 꼭 GitSpace에 알려 주세요. 거기서부터는 저희가 처리하겠습니다.
                    
                    Text("Please do not report just because someone doesn't reply to you.")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    Text(
"""
Sometimes we send a knock message and don't receive a response. And sometimes we send a message to someone who has accepted our knock, but we don't get a reply. It can be frustrating when we have so many questions but no response. They could be busy with work, accidentally accepted the knock, or simply not interested in responding, but we can't know for sure. In such cases, it can be helpful to come up with a reasonable explanation for ourselves. Instead of reporting, why not try finding a new explorer and embarking on a new adventure?
""")
// 노크 메세지를 보냈지만 응답이 없을 때가 있어요. 그리고 노크를 승낙한 상대에게 메시지를 보냈는데 답장이 오지 않을 때가 있습니다. 상대에게 궁금한 것이 너무나도 많지만 답장이 없으니 답답하죠. 업무가 바쁠수도, 실수로 승낙했을 수도, 아니면 그냥 답장하고 싶지 않은 것일 수도 있겠지만 어쨌든 정확한 이유는 알 수가 없어요. 이럴 땐 적당한 자기 합리화가 도움이 될 거예요. 신고 대신 새로운 탐험가를 찾아 모험을 떠나 보세요.
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("What to Report")
    } // body
}

struct WhatToReportGuideView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WhatToReportGuideView()
        }
    }
}
