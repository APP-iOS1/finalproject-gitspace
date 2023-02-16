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
                    string: "Block")
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            .padding(.bottom, 5)
            
            GSCanvas.CustomCanvasView.init(style: .primary, content: {
                /* 캔버스 내부: */
                
                Group {
                    
                    NavigationLink {
                        BlockGuideView()
                    } label: {
                        HStack(spacing: 10) {

                            Image("GitSpace-Block")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 50)

                            VStack(alignment: .leading, spacing: 5) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "Block or Unblock")

                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "People aren't notified when you block them.")
                                .multilineTextAlignment(.leading)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                    NavigationLink {
                        BlockListGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            VStack(alignment: .leading) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "See a list of people you've blocked")
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gsGray2)
                        } // HStack
                    } // NavigationLink
                    
                    NavigationLink {
                        AfterBlockGuideView()
                    } label: {
                        HStack(spacing: 10) {
                            
                            VStack(alignment: .leading) {
                                GSText.CustomTextView(
                                    style: .title3,
                                    string: "What Happens After I Block?")
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
