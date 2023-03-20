//
//  TagGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/16.
//

import SwiftUI

struct TagGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Manage your star repo with tags 🏷️")
                            .font(.system(size: 22, weight: .light))
                            .foregroundColor(.gsGray1)
                        
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text(
"""
GitSpace’s **tagging feature** helps organizing your starred repositories under corresponding keywords.
""")
                    .padding(.vertical)
                    
                   
                    /* 소제목 "Adding Tag to a Repository"에 해당되는 내용 */
                    Group {
                        Text("Adding Tag to a Repository")
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 5)
                        
                        HStack {
                            VStack {
                                Text("1.")
                                    .bold()
                                Spacer()
                            } // VStack
                            
                            VStack {
                                Text(
            """
            Tap on the repository that you starred, jump to its detail page
            """)
                                Spacer()
                            } // VStack
                        } // HStack
                        
                        
                        HStack {
                            VStack {
                                Text("2.")
                                    .bold()
                                Spacer()
                            } // VStack
                            
                            VStack {
                                Text(
            """
            Tap on the plus icon next to "My Tags"
            """)
                                Spacer()
                            } // VStack
                        } // HStack
                        
                        
                        HStack {
                            VStack {
                                Text("3.")
                                    .bold()
                                Spacer()
                            } // VStack
                            
                            VStack {
                                Text(
            """
            Select appropriate tag(s) to sort the repository / or provide a new tag
            """)
                                Spacer()
                            } // VStack
                        } // HStack
                    }
                } // VStack
                .padding(.horizontal)
                .lineSpacing(2.5)
            } // ScrollView
            .navigationBarTitle("Tag")
    } // body
}

struct TagGuideView_Previews: PreviewProvider {
    static var previews: some View {
        TagGuideView()
    }
}
