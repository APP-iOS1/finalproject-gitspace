//
//  HomeCardSkeletonCell.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/02/15.
//

import SwiftUI

struct HomeCardSkeletonCell: View {
    @State var opacity: CGFloat = 0.4
    
    var body: some View {
        GSCanvas.CustomCanvasView.init(style: .primary, content: {
            /* 캔버스 내부: */
            Group {
                NavigationLink { }
            label: {
                    VStack(alignment: .leading, spacing: 10) {
                                Text("repo owner")
                                    .multilineTextAlignment(.leading)
                                    .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                                
                                Text("this is repo name")
                                    .multilineTextAlignment(.leading)
                                    .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))

                        Text("Repo description")
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                    }
                }
            }
        })
        .task {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)){
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

struct HomeCardSkeletonCell_Previews: PreviewProvider {
    static var previews: some View {
        HomeCardSkeletonCell()
    }
}
