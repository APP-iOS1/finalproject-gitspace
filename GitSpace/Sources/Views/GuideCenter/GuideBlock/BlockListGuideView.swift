//
//  BlockListGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/16.
//

import SwiftUI

struct BlockListGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("See a list of users you've blocked")
                            .font(.system(size: 22, weight: .light))
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text(
"""
 You can review who you've blocked on GitSpace in your settings.
""")
                    .padding(.top)
                    
                    Text("To review who you've blocked:")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .top) {
                            Text("1.")
                            Text("Tap **profile** in the bottom right to go to your profile")
                        }
                        
                        HStack(alignment: .top) {
                            Text("2.")
                            Text("Tap **gear icon** in the top right.")
                        }
                        
                        HStack(alignment: .top) {
                            Text("3.")
                            Text("Tap **Account** at the top and tap **Blocked users**.")
                        }
                    }
                    .padding(.top)
                    
                    Text(
"""
 From your blocked users list, you can also unblock someone by tapping **Unblock** to the right of their name.
""")
                    .padding(.top)
                    
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("Blocked List")
    } // body
}

struct BlockListGuideView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BlockListGuideView()
        }
    }
}
