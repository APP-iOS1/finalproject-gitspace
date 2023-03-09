//
//  ContributorListSkeletonView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/03/09.
//

import SwiftUI

struct ContributorListSkeletonView: View {
    
    @State var opacity: CGFloat = 0.4
    
    var body: some View {
        
        VStack {
            
            HStack {
                Spacer()
                
                Image("GitSpace-ContributorListView")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width - 250)
                    .padding(.vertical, 25)
                    .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                
                Spacer()
            }
            
            HStack {
                GSText.CustomTextView(
                    style: .caption1,
                    string: "                                                               ")
                .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                
                Spacer()
            } // HStack
            .padding(.leading, 20)
            .padding(.bottom, 1)
            .offset(y: 10)
            
            HStack {
                GSText.CustomTextView(
                    style: .caption1,
                    string: "                                                                          ")
                .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                
                Spacer()
            } // HStack
            .padding(.leading, 20)
            .padding(.top, 0)
            .padding(.bottom, -5)
            .offset(y: 15)
            
            HStack { }
                .frame(height: 10)
            
            Divider()
                .padding([.top, .horizontal], 20)
                .padding(.bottom, 10)
            
            HStack {
                GSText.CustomTextView(
                    style: .caption1,
                    string: "GitSpace User  ⎯  100      ")
                .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                
                Spacer()
            }
            .padding(.leading, 20)
            
            VStack {
                ForEach(0..<6) { _ in
                    GSCanvas.CustomCanvasView.init(style: .primary, content: {
                        HStack(spacing: 15) {
                            /* 유저 프로필 이미지 */
                            Image("ProfilePlaceholder")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(width: 40)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                /* 유저네임 */
                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "user's GitHub Name")
                                .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                                
                                /* 유저ID */
                                GSText.CustomTextView(
                                    style: .caption1,
                                    string: "user's GitHub ID")
                                .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                            } // VStack
                            .multilineTextAlignment(.leading)
                            
                            Spacer()
                        } // HStack
                    }) // GSCanvas
                } // ForEach
            }
            .padding(.horizontal, 20)
            
        } // VStack
        .task {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)){
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
        }

    }
}

struct ContributorListSkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        ContributorListSkeletonView()
    }
}
