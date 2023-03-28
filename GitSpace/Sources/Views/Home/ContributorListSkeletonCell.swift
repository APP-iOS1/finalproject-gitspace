//
//  ContributorListSkeletonCell.swift
//  GitSpace
//
//  Created by 박제균 on 2023/03/12.
//

import SwiftUI

struct ContributorListSkeletonCell: View {

    @State var opacity: CGFloat = 0.4

    var body: some View {
        VStack {
            Image("ProfilePlaceholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 40, height: 40)
                .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
        }
            .task {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
        }

    }
}


struct ContributorListSkeletonCell_Previews: PreviewProvider {
    static var previews: some View {
        ContributorListSkeletonCell()
    }
}
