//
//  MyKnockCell.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct EachKnockCell: View {
    @EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var userInfoManager: UserStore
	@Binding var eachKnock: Knock
    @Binding var isEditing: Bool
    @State private var targetUserInfo: UserInfo? = nil
    @State private var isChecked: Bool = false
    
    // MARK: Binding하면 상위 state에 의해 이름 잔상 애니메이션이 남는다.
    @State var userSelectedTab: String
	
	// MARK: - body
    var body: some View {
		VStack {
			HStack(alignment: .center) {
				if isEditing {
					Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 30, height: 30)
						.foregroundColor(isChecked ? Color(UIColor.systemBlue) : Color.secondary)
						.onTapGesture {
							self.isChecked.toggle()
						}
				}
				
                GithubProfileImage(
                    urlStr: targetUserInfo?.avatar_url ?? "",
                    size: 50
                )
				
				VStack {
					HStack {
                        if userSelectedTab == Constant.KNOCK_RECEIVED {
                            Text("from: **\(eachKnock.sentUserName)**")
                                .font(.body)
                        } else {
                            Text("to: **\(eachKnock.receivedUserName)**")
                                .font(.body)
                        }
						
						Spacer()
						
                        Text("\(eachKnock.dateDiff)")
							.font(.subheadline)
							.foregroundColor(Color(.systemGray))
							.padding(.leading, -10)
						
						Image(systemName: "chevron.right")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 10, height: 10)
							.foregroundColor(Color(.systemGray))
						
					} // HStack
					
					HStack {
						Text(eachKnock.knockMessage)
							.lineLimit(1)
						
						Spacer()
						
						if eachKnock.knockStatus == Constant.KNOCK_WAITING {
							Text(eachKnock.knockStatus)
								.foregroundColor(Color(.systemBlue))
						} else if eachKnock.knockStatus == Constant.KNOCK_ACCEPTED {
							Text(eachKnock.knockStatus)
								.foregroundColor(Color(.systemGreen))
						} else {
							Text("\(eachKnock.knockStatus)")
								.foregroundColor(Color(.systemRed))
						}
					} // HStack
					.font(.subheadline)
					.foregroundColor(Color(.systemGray))
					
				} // VStack
				
			} // HStack
			.padding(.vertical, 5)
			.padding(.horizontal)
			
			Divider()
				.padding(.horizontal, 20)
		}
        .task {
            // 노크 수신자 == 현재 유저일 경우, 노크 발신자의 정보를 타겟유저로 할당
            if eachKnock.receivedUserID == userInfoManager.currentUser?.id {
                self.targetUserInfo = await userInfoManager.requestUserInfoWithID(userID: eachKnock.sentUserID)
            } else if eachKnock.receivedUserID != userInfoManager.currentUser?.id {
                self.targetUserInfo = await userInfoManager.requestUserInfoWithID(userID: eachKnock.receivedUserID)
            }
        }
    }
}