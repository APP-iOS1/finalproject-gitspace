//
//  SuggestBlockView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/04/19.
//

import SwiftUI

struct SuggestBlockView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isBlockViewShowing: Bool
    @Binding var isSuggestBlockViewShowing: Bool
    
    var body: some View {
        VStack {
            VStack {
                GSText.CustomTextView(style: .title1, string: "Report Submitted")
                GSText.CustomTextView(style: .description, string: "Your report is submitted. ")
            }
            .padding()
            
            VStack(alignment: .leading) {
                GSText.CustomTextView(style: .title3, string: "Well... Do you want to Block this user?")
            }
            .padding()
            
            HStack (spacing: 30) {
                GSButton.CustomButtonView(style: .plainText(isDestructive: false)) {
                    isSuggestBlockViewShowing.toggle()
                } label: {
                    Text("No")
                        .frame(width: 100, height: 50)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke()
                        }
                }
                
                GSButton.CustomButtonView(style: .plainText(isDestructive: true)) {
                    dismiss()
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

struct SuggestBlockView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestBlockView(isBlockViewShowing: .constant(false), isSuggestBlockViewShowing: .constant(true))
    }
}
