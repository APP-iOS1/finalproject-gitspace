//
//  BeforeSendKnockSection.swift
//  GitSpace
//
//  Created by 최한호 on 2023/05/08.
//

import SwiftUI

struct BeforeSendKnockSection: View {
    
    @State var targetGithubUser: GithubUser?
    @Binding var showKnockGuide: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            if let targetGithubUser {
                HStack(spacing: 5) {
                    GSText.CustomTextView(
                        style: .body1,
                        string: "It's the first message to")
                    GSText.CustomTextView(
                        style: .title3,
                        string: "\(targetGithubUser.login)!")
                }
            }
            
            HStack(spacing: 5) {
                Text("Would you like to")
                Button {
                    showKnockGuide.toggle()
                } label: {
                    Text("Knock")
                        .bold()
                }
                Text("?")
                    .padding(.leading, -4)
            }
            
            GSText.CustomTextView(
                style: .caption1,
                string:
"""
Please select the purpose of the chat so that the other person can understand your intention.
""")
        }
        .multilineTextAlignment(.center)
    }
}

struct BeforeSendKnockSection_Previews: PreviewProvider {
    static var previews: some View {
        BeforeSendKnockSection(
            showKnockGuide: .constant(false)
        )
    }
}
