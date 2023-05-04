//
//  AfterReportGuideView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/16.
//

import SwiftUI

struct AfterReportGuideView: View {
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Text("What Happens After I Report?")
                            .font(.system(size: 22, weight: .light))
                        Spacer()
                    }
                    
                    Divider()
                    
                    Text(
"""
 You've done your part by letting us know something is up — now it's our turn. Here's what to expect after you report someone on GitSpace:
""")
                    .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Text("•")
                            Text("None of the details you provided will be shared with the person you reported")
                        }
                        
                        HStack(alignment: .top) {
                            Text("•")
                            Text("A member of our GitSpace team will look into the matter to determine next steps and take action based on our Community Guidelines.")
                        }
                    }
                    .padding(.top)
                    
                    Text(
"""
 Because of privacy guidelines, we may not always be able to share the details of a report with you, but we want you to know that every report will be taken seriously and handled with care.

 Sharing your experience isn't always easy, and we appreciate it when you do.
""")
                    .padding(.top)
                } // VStack
                .padding(.horizontal)
            } // ScrollView
            .navigationBarTitle("After Report")
    } // body
}

struct AfterReportGuideView_Previews: PreviewProvider {
    static var previews: some View {
        AfterReportGuideView()
    }
}
