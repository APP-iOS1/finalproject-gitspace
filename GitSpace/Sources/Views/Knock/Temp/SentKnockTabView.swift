//
//  SentKnockTabView.swift
//  GitSpace
//
//  Created by Celan on 2023/03/04.
//

import SwiftUI

struct SentKnockTabView: View {
    @State var eachKnock: Knock
    @Binding var isEditing: Bool
    @Binding var userFileteredOption: KnockStateFilter
    
    var body: some View {
        EachKnockCell(
            userNameText: eachKnock.receivedUserName,
            eachKnock: $eachKnock,
            isEdit: $isEditing
        )
    }
}
