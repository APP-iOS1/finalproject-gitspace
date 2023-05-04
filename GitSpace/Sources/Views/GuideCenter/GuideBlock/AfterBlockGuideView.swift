//
//  AfterBlockGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/16.
//

import SwiftUI

struct AfterBlockGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("What Happens After I Block?")
                            .font(.system(size: 22, weight: .light))
                        Spacer()
                    }
                    
                    Divider()
                    
                    Group {
                        Text("Knocks")
                            .font(.title2)
                            .bold()
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(alignment: .top) {
                                Text("•")
                                Text("After you block someone, neither you nor the blocked user will be able to send Knock Messages to each other.")
                            }
                            
                            HStack(alignment: .top) {
                                Text("•")
                                Text("Even after you block someone, the user can accept knocks and chat rooms can be created. However, the chat room is only created, and the user won't be able to send messages.")
                            }
                        }
                        .padding(.top)
                    }
                    
                    Group {
                        Text("Chats")
                            .font(.title2)
                            .bold()
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(alignment: .top) {
                                Text("•")
                                Text("After you block someone, your messaging threads with them will remain in **My Chats**, but you won't be able to message them.")
                            }
                            
                            HStack(alignment: .top) {
                                Text("•")
                                Text("Also, the user you blocked won't be able to send you messages.")
                            }
                        }
                        .padding(.top)
                    }
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("After Block")
    } // body
}

struct AfterBlockGuideView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AfterBlockGuideView()
        }
    }
}
