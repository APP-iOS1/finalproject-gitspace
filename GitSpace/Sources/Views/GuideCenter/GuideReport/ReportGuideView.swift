//
//  ReportGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/07.
//

import SwiftUI

struct ReportGuideView: View {
    
    @State private var reportGuide1: Bool = false
    @State private var reportGuide2: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("How to report someone")
                        .font(.system(size: 22, weight: .light))
                    
                    Spacer()
                }
                
                Divider()
                
                Group {
                    Text("Report a user")
                        .font(.title2)
                        .bold()
                    
                    Text("To report someone on GitSpace:")
                        .padding(.top, 5)
                }
                
                Group {
                    DisclosureGroup("**From someone's GitSpace profile:**",
                                    isExpanded: $reportGuide1) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .top) {
                                Text("1.")
                                Text("Tap their username of profile picture from their repository or contributor list or chatting room to go to their profile.")
                            }
                            
                            HStack(alignment: .top) {
                                Text("2.")
                                Text("Tap **⋯** in the top right, then tap **Report** at the bottom to confirm.")
                            }
                            
                            HStack(alignment: .top) {
                                Text("3.")
                                Text("Tap the reason for your report.")
                            }
                        }
                        .padding(.top, 5)
                    }
                }
                               
                Group {
                    DisclosureGroup("**From a chat with another user:**",
                                    isExpanded: $reportGuide2) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .top) {
                                Text("1.")
                                Text("Tap **chats** in the bottom to go to your chat list.")
                                Spacer()
                            }
                            
                            HStack(alignment: .top) {
                                Text("2.")
                                Text("Tap the chat with the user you want to report.")
                            }
                            
                            HStack(alignment: .top) {
                                Text("3.")
                                Text("Long tap their message bubble and tap **Report**.")
                            }
                            
                            HStack(alignment: .top) {
                                Text("4.")
                                Text("Tap the reason for your report.")
                            }
                        }
                        .padding(.top, 5)
                    }
                }
            } // VStack
            .padding(.horizontal)
        } // ScrollView
        .navigationBarTitle("How to Report")
    } // body
}

struct ReportGuideView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReportGuideView()
        }
    }
}
