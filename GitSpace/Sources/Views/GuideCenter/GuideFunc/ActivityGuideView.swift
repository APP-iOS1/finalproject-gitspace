//
//  ActivityGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/08.
//

import SwiftUI

struct ActivityGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Catch up with your friends' latest Git activities 👀")
                            .font(.system(size: 22, weight: .light))
                            .foregroundColor(.gsGray1)
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text(
"""
GitSpace provides **activity feed** for users to check on **Git-related activities** of the people they follow on GitHub, and be connected with their networks and communities. \nWish to learn more about what other professionals are up to? Check out the Activity tab on GitSpace!
""")
                    .padding(.vertical)
                    
                } // VStack
                .padding(.horizontal)
                .lineSpacing(2.5)
            } // ScrollView
            .navigationBarTitle("Activity")
    } // body
}

struct ActivityGuideView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityGuideView()
    }
}
