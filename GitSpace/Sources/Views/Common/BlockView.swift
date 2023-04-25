//
//  BlockView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/04/19.
//

import SwiftUI

struct BlockView: View {
    @Binding var isBlockViewShowing: Bool
    
    var body: some View {
        VStack {
            GSText.CustomTextView(style: .title2, string: "Block")
            
            VStack(alignment: .leading) {
                GSText.CustomTextView(
                    style: .body1,
                    string: "When you block this user, the following things happen.")
                .padding(.bottom, 1)
                GSText.CustomTextView(
                    style: .description,
                    string:
"""
• You cannot knock/chat with this user.
• This user is classified as a blocked user at repository contributors.
"""
                )
            }
            .padding(.top, 10)
            .padding(.bottom, 30)
            
            VStack {
                GSText.CustomTextView(
                    style: .title3, string: "If you want to block this user?"
                )
                .padding(10)
                
                HStack(spacing: 30) {
                    GSButton.CustomButtonView(style: .plainText(isDestructive: false)) {
                        isBlockViewShowing.toggle()
                    } label: {
                        Text("No")
                    }
                    
                    GSButton.CustomButtonView(style: .plainText(isDestructive: true)) {
                        /* Block Method Call */
                        isBlockViewShowing.toggle()
                    } label: {
                        Text("Yes")
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .background(Color.gsRed)
                            .cornerRadius(15)
                    }
                    
                }
            }
        }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(isBlockViewShowing: .constant(true))
    }
}
