//
//  ChatGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/07.
//

import SwiftUI

struct ChatGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Connect with contributors of your starred repositories 👥")
                            .font(.system(size: 22, weight: .light))
                            .foregroundColor(.gsGray1)
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text(
"""
Once the Knock message is approved, you are all set to start your conversations! \nIt is your chance to talk to worldwide developers with awesome projects on GitHub, build connections, as well as to be exposed within the community. You are free to ask questions, give suggestions, offer a job interview, and more just like on any other chatting app. \nPlease remember that we are all unfamiliar to each other, and that **we must respect one another in the community.** Please be reasonable, gentle, and considerate with your language.
""")
                    .padding(.vertical)
                    
                    
                } // VStack
                .padding(.horizontal)
                .lineSpacing(2.5)
            } // ScrollView
            .navigationBarTitle("Chat")
    } // body
}

struct ChatGuideView_Previews: PreviewProvider {
    static var previews: some View {
        ChatGuideView()
    }
}
