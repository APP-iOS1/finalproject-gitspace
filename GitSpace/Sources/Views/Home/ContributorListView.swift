//
//  ContributorListView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/18.
//

import SwiftUI

struct ContributorListView: View {
    let contributors: [String] = ["contributor1", "contributor2", "contributor3"]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Spacer()
                .frame(height: 30)
            
            Text("Choose a user to knock 💬")
                .foregroundColor(.gray)
            
            List(contributors, id:\.self) { contributor in
				// 멀티 셀렉트하게 수정
                NavigationLink(destination: {
                    // SendKnockView()
                }, label: {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 40)
                                .foregroundColor(Color.gray)
                            Text("profile \nImage")
                                .font(.caption2)
                        }
                        Text(contributor)
                    }
                })
                .padding()
                .background(Rectangle().fill(.white))
                .border(Color.black, width: 2)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            }
            .listStyle(.inset)
            
           
        }
        .padding(.horizontal, 30)
       
    }
}

struct ContributorListView_Previews: PreviewProvider {
    static var previews: some View {
        ContributorListView()
    }
}
