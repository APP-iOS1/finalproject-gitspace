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
            .padding(.top)
            
            
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

                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "When you should report\nand when you shouldn't.")
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
                                    string: "How to Report Someone")
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
