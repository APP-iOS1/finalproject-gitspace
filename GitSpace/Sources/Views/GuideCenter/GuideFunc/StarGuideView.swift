//
//  StarGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/07.
//

import SwiftUI

struct StarGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Star repositories you want to see again ⭐️")
                            .font(.system(size: 22, weight: .light))
                            .foregroundColor(.gsGray1)
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text(
"""
GitSpace helps **manage your “Stars”** on GitHub. Using this feature, you can star someone's repository that you wish to archive and access it whenever you want. \nYou can categorize the starred repositories into a number of tags, as introduced in the Tag page from the Guide Center. This guide is for your reference to learn about starring feature on GitSpace.
""")
                    .padding(.vertical)
                
                    
                    /* 소제목 "Adding Tag to a Repository"에 해당되는 내용 */
                    Group {
                        Text("Starring / Unstarring")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 5)
                        
                        HStack {
                            VStack {
                                Text("⁃")
                                Spacer()
                            } // VStack
                            
                            VStack {
                                Text(
            """
            Tap on the star icon at the upper right corner of the screen
            """)
                                Spacer()
                            }
                        } // HStack
                    }
                    
                } // VStack
                .padding(.horizontal)
                .lineSpacing(2.5)
            } // ScrollView
            .navigationBarTitle("Star")
    } // body
}

struct StarGuideView_Previews: PreviewProvider {
    static var previews: some View {
        StarGuideView()
    }
}
