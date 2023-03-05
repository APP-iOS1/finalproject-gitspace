//
//  ReceivedKnockTabView.swift
//  GitSpace
//
//  Created by Celan on 2023/03/04.
//

import SwiftUI

struct ReceivedKnockTabView: View {
    @State var eachKnock: Knock
    @Binding var userSelectedTab: String
    @Binding var isEditing: Bool
    @Binding var userFileteredOption: KnockStateFilter
    
    var body: some View {
        EachKnockCell(
            userSelectedTab: userSelectedTab,
            eachKnock: eachKnock,
            isEdit: $isEditing
        )
    }
}
