//
//  KnockNotificationCell.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/07.
//

import SwiftUI

struct KnockNotificationCell: View {
	@EnvironmentObject var knockViewModel: KnockViewManager
    
    var body: some View {
        HStack(spacing: 25) {
            // FIXME: - Button Shape의 NavigationLink가 아님 -> GSNavigationLink 적용 불가
            NavigationLink {
                // 노크를 보낸 유저의 프로필 사진
//                ProfileDetailView()
            } label: {
                // FIXME: - Default Image 회색으로 변경
                Image("avatarImage")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
                .foregroundColor(.primary)
            
            NavigationLink {
//				ReceivedKnockView(knock: <#T##Knock#>)
            } label: {
                knockNotificationLabel
            }
        } // Hstack
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
    
    private var knockNotificationLabel: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                // 노크를 보낸 유저의 이름
                GSText.CustomTextView(style: .title3, string: "\("UserName")")

                GSText.CustomTextView(style: .body1, string: "\("User") sent Knock to you!")
            }

            Spacer()

            VStack {
                // ???: - 노티 액션 논의 필요

                Spacer()

                GSText.CustomTextView(style: .caption2, string: "\("1") 시간 전")
            }
        }
        
    }
    
}

struct KnockNotificationCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            KnockNotificationCell()
        }
    }
}
