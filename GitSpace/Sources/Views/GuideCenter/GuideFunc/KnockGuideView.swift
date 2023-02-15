//
//  KnockGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/04.
//

import SwiftUI

struct KnockGuideView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Knock, before the Chat.")
                            .font(.system(size: 22, weight: .light))
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text(
"""
We've created a list of what you need to know to help you Knock on GitSpace.
Come back to it whenever you have a question or need some tips.
""")
                    .padding(.vertical)
                    
                    Text("How to Knock")
                        .font(.title2)
                        .bold()
                    
                    Text(
"""
1. Select the person you want to talk to.
2. Select the purpose of the conversation.
3. Create a knock message.
4. If the other person approves your knock, you can start the conversation!
""")
                    
                    Text("How to Response the Knock")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    Text(
"""
1. Select the knock you want to respond to.
2. Choose whether to accept, decline, or block the conversation.
3. Report all suspicious and inappropriate behavior immediately. For example:
    - Request for money
    - Harassment or threats
    - Spam
""")
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("Knock")
    } // body
}

struct KnockGuideView_Previews: PreviewProvider {
    static var previews: some View {
        KnockGuideView()
    }
}
