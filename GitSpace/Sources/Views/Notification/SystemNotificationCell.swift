//
//  SystemNotificationCell.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/07.
//

import SwiftUI

struct SystemNotificationCell: View {
    var body: some View {
        HStack(spacing: 25) {

            Image("GitSpace-MainKnockView")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            GSText.CustomTextView(style: .body1, string: "Some System Message")

            Spacer()
            VStack {
                Spacer()
                GSText.CustomTextView(style: .caption2, string: "\("1") 시간 전")
            }
        }
            .padding(.top, 10)
            .padding(.horizontal, 20)

    }
}

struct SystemNotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        SystemNotificationCell()
    }
}
