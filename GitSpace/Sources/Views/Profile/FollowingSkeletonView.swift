//
//  FollowingSkeletonView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/03/22.
//

import SwiftUI

struct FollowingSkeletonView: View {
    
    @State var opacity: CGFloat = 0.4
    
    var body: some View {
        VStack {
            ForEach(0..<10) { _ in
                
                HStack(spacing: 20) {
                    
                    /* 유저 프로필 이미지 */
                    Image("ProfilePlaceholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 50)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        /* 유저네임 */
                        GSText.CustomTextView(
                            style: .caption1,
                            string: "User Name Skeleton")
                        .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                        
                        /* 유저ID */
                        GSText.CustomTextView(
                            style: .caption1,
                            string: "User    Login")
                        .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                    } // VStack
                    .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                Divider()
            } // ForEach
        } // VStack
        .task {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)){
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
        }
    }
}

struct FollowingSkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        FollowingSkeletonView()
    }
}
