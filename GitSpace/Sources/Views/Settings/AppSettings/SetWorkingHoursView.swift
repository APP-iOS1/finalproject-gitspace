//
//  SetWorkingHoursView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetWorkingHoursView: View {
    var body: some View {
        List {
            Section {
                
            } footer: {
                Text("Custom when to allow push notifications to be sent for activity on GitSpace")
            }
        }
        .navigationBarTitle("Working Hours", displayMode: .inline)
    }
}

struct SetWorkingHoursView_Previews: PreviewProvider {
    static var previews: some View {
        SetWorkingHoursView()
    }
}
