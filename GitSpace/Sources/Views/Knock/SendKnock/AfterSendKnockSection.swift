//
//  AfterSendKnockSection.swift
//  GitSpace
//
//  Created by 최한호 on 2023/05/08.
//

import SwiftUI

struct AfterSendKnockSection: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var knockViewManager: KnockViewManager
    @State var targetGithubUser: GithubUser?
    
    var body: some View {
        VStack {
            Text("\(knockViewManager.newKnock?.knockedDate.dateValue().formattedDateString() ?? "")")
                .font(.callout)
                .foregroundColor(.gsGray1)
                .padding(.vertical, 8)
            
            Text("Your Knock Message has successfully been\ndelivered to **\(targetGithubUser?.login ?? "")**")
                .font(.system(size: 12, weight: .regular))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
            
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 3, height: 15)
                    .foregroundColor(
                        colorScheme == .light
                        ? .gsGreenPrimary
                        : .gsYellowPrimary
                    )
                Text("Knock Message")
                    .font(.footnote)
                    .foregroundColor(.gsLightGray1)
                    .bold()
                
                Spacer()
            }
            .padding(.leading, 20)
            
            GSCanvas.CustomCanvasView.init(
                style: .primary,
                content: {
                    HStack {
                        Spacer()
                        GSText.CustomTextView(
                            style: .captionPrimary1,
                            string: "\(knockViewManager.newKnock?.knockMessage ?? "")")
                        Spacer()
                    }
                })
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
    }
}

struct AfterSendKnockSection_Previews: PreviewProvider {
    static var previews: some View {
        SendKnock()
    }
}
