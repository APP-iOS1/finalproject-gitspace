//
//  EditingKnockSection.swift
//  GitSpace
//
//  Created by 최한호 on 2023/05/08.
//

import SwiftUI

struct EditingKnockSection: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var targetGithubUser: GithubUser?
    
    var body: some View {
        VStack {
            if let targetGithubUser {
                VStack (alignment: .center) {
                    GSText.CustomTextView(
                        style: .body1,
                        string: "Send your Knock messages to")
                    GSText.CustomTextView(
                        style: .title3,
                        string: "\(targetGithubUser.login)!")
                }
            }
            
            GSText.CustomTextView(
                style: .caption2,
                string:
"""
Once a Knock message is sent, it cannot be canceled or deleted.
However, the message can be edited before the receiver reads it.
""")
            
            .multilineTextAlignment(.center)
            .padding(10)
            
            Divider()
                .padding(.vertical, 15)
                .frame(width: 350)
            
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 3, height: 15)
                    .foregroundColor(
                        colorScheme == .light
                        ? .gsGreenPrimary
                        : .gsYellowPrimary
                    )
                Text("Example Knock Message")
                    .font(.footnote)
                    .foregroundColor(.gsLightGray1)
                    .bold()
                
                Spacer()
            }
            .padding(.leading, 20)
            
            GSCanvas.CustomCanvasView.init(
                style: .primary,
                content: {
                    GSText.CustomTextView(
                        style: .captionPrimary1,
                        string:
"""
Hi there! I'm Gildong Hong, a student studying web programming in South Korea.
I was hoping to request a bit of your time to seek advice about my future career path.
Thank you!
""")
                })
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
    }
}

struct EditingKnockSection_Previews: PreviewProvider {
    static var previews: some View {
        EditingKnockSection()
    }
}
