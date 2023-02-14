//
//  ChatListSkeletonCell.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/07.
//

import SwiftUI

struct ChatListSkeletonCell : View {
    
    @State var opacity: CGFloat = 0.4
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image("ProfilePlaceholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width : 55)
                    .padding(.trailing)

                
                VStack(alignment: .leading) {
                    Text("@Skeleton~")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                        .lineLimit(1)
                        .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                    
                    Text("@Skeleton Messages")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(BlinkingSkeletonModifier(opacity: opacity, shouldShow: true))
                }
                
            }
            .frame(width: 330,height: 100, alignment: .leading)
            Divider()
                .frame(width: 350)
        }
        .task {
            withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)){
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
        }

    }
}


struct ChatListSkeletonCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatListSkeletonCell()
    }
}
