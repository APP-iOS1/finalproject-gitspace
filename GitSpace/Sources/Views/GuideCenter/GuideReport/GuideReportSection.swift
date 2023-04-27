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
                    string: "Report")
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 5)
            
            
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                /* 캔버스 내부: */
                
                Group {
                    
                    NavigationLink {
                        WhatToReportGuideView()
                    } label: {
                        HStack(spacing: 10) {

                            Image("GitSpace-Report")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)

                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "What to Report")
                                        /// 신고에 대한 모든 것

                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "When you should report\nand when you shouldn't")
                                        /// 신고해야 할 때와 하지 말아야 할 때
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
                        ReportGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            VStack(alignment: .leading) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "How to Report Things")
                                        /// 신고하는 법
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                    NavigationLink {
                        AfterReportGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            VStack(alignment: .leading) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "What Happens After I Report?")
                                        /// 신고 후엔 어떻게 되나요?
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
