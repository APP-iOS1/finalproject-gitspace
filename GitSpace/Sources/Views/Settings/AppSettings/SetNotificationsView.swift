//
//  SetNotificationsView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetNotificationsView: View {
    
    
    
    var body: some View {
        List {
            Section {
                NavigationLink {
                    
                } label: {
                    HStack {
                        Text("Working Hours")
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\()")
                    }
                }

            }
            
            Section {
                
            }
            
            
        }
        .navigationBarTitle("Notifications", displayMode: .inline)
    }
}

struct SetNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        SetNotificationsView()
    }
}
