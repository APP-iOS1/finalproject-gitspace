//
//  BlockedUsersListSkeletonView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/04/23.
//

import SwiftUI

struct BlockedUsersListSkeletonView: View {
    
    @State var opacity: CGFloat = 0.3
    
    var body: some View {
        VStack {
            ForEach(0..<8) { _ in
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
                                string: String(repeating:" ", count: 40))
                            .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                            
                            /* 유저ID */
                            GSText.CustomTextView(
                                style: .caption1,
                                string: String(repeating:" ", count: 25))
                            .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                        } // VStack
                        .multilineTextAlignment(.leading)
                        
                        Spacer()
                    } // HStack
                }) // GSCanvas
                .padding(.horizontal, 10)
            } // ForEach
        }
        .task {
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true)){
                self.opacity = opacity == 0.3 ? 1.0 : 0.3
            }
        }
    }
}

struct BlockedUsersListSkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        BlockedUsersListSkeletonView()
    }
}
