//
//  GuideBlockSection.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/07.
//

import SwiftUI

struct GuideBlockSection: View {
    var body: some View {
        Group {
            
            HStack {
                GSText.CustomTextView(
                    style: .title2,
                    string: "차단")
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                /* 캔버스 내부: */
                
                Group {
                    
                    NavigationLink {
                        BlockGuideView()
                    } label: {
                        HStack(spacing: 10) {

                            Image("GitSpace-KnockHistoryView-LightMode")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)

                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "차단하거나 차단 해제하기")

                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "차단된 사람은 회원님이 차단했다는 알림을 받지 않습니다.")
                                .multilineTextAlignment(.leading)
                            }

                            VStack {
                                Text("")
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                    NavigationLink {
                        KnockGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            VStack(alignment: .leading) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "차단한 사람 리스트를 보는 법")
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                    NavigationLink {
                        KnockGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            VStack(alignment: .leading) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "누군가를 차단했습니다. 이제 어떻게 되나요?")
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                } // Group
            }) // GSCanvas
            .padding(.horizontal)
        } // Group
    }
}

struct GuideBlockSection_Previews: PreviewProvider {
    static var previews: some View {
        GuideCenterView()
    }
}
