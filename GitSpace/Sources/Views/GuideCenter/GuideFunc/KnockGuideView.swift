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
                        Text("Knock, before your chat ✊🏻")
                            .font(.system(size: 22, weight: .light))
                            .foregroundColor(.gsGray1)
                        
                        Spacer()
                    }
                    
                    Divider()
                
                    Text(
"""
Want to chat? Then **"knock, knock"**! \n**Knock** is a polite way of greeting and an icebreaking gesture. On GitSpace, you are required to Knock to start conversation and wait for the approval of the person they want to talk to. We've created a list of what you need to know about it to help you Knock on GitSpace. Come back to it whenever you have question or need some tips.
""")
                    .padding(.vertical)
                    
                    /* 소제목 "Knocking"에 해당되는 내용 */
                    Group {
                        Text("Knocking")
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
            Select the person you want to talk to
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
            Select the purpose of the conversation
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
            Create a Knock message
            """)
                                Spacer()
                            } // VStack
                            
                        } // HStack
                        
                        
                        HStack {
                            VStack {
                                Text("4.")
                                    .bold()
                                Spacer()
                            } // VStack
                            
                            VStack {
                                Text(
            """
            If the other person approves your Knock, you can start the conversation
            """)
                                Spacer()
                            } // VStack
                            
                        } // HStack
                    }
                    
                    Spacer()
                        .frame(height: 25)
                    
                    /* 소제목 "Responding a Knock"에 해당되는 내용 */
                    Group {
                        Text("Responding a Knock")
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
            Select the Knock you want to respond to
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
            Choose whether to accept, decline, or block the conversation
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
            A new chatroom is formed as soon as you accept the knock
            """)
                                Spacer()
                            } // VStack
                        } // HStack
                    }
                } // VStack
                .padding(.horizontal)
                .lineSpacing(2.5)
            } // ScrollView
            .navigationBarTitle("Knock")
    } // body
}

struct KnockGuideView_Previews: PreviewProvider {
    static var previews: some View {
        KnockGuideView()
    }
}
