//
//  GuideReportSection.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/07.
//

import SwiftUI

struct GuideReportSection: View {
    var body: some View {
        Group {
            
            HStack {
                GSText.CustomTextView(
                    style: .title2,
                    string: "신고")
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                /* 캔버스 내부: */
                
                Group {
                    
                    NavigationLink {

                    } label: {
                        HStack(spacing: 10) {

                            Image("GitSpace-KnockHistoryView-LightMode")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)

                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "신고 대상")

                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "신고해야할 때와 하지 말아야 할 때")
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
                                    string: "신고 방법")
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
                                    string: "누군가를 신고했습니다. 이제 어떻게 되나요?")
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                }
                
                
            }) // GSCanvas
            .padding(.horizontal)
        } // Group
    }
}

struct GuideReportSection_Previews: PreviewProvider {
    static var previews: some View {
        GuideCenterView()
    }
}
