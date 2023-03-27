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
    @State private var opacity: CGFloat = 0.4
    
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
				
                if let targetUserInfo {
                    GithubProfileImage(
                        urlStr: targetUserInfo.avatar_url,
                        size: 50
                    )
                } else {
                    Image("ProfilePlaceholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 50)
                        .modifier(BlinkingSkeletonModifier(
                            opacity: opacity,
                            shouldShow: true
                        )
                        )
                }
				
				VStack {
					HStack {
                        if userSelectedTab == Constant.KNOCK_RECEIVED {
                            Text("from: **\(eachKnock.sentUserName)**")
                                .font(.body)
                                .id(eachKnock.sentUserName)
                        } else {
                            Text("to: **\(eachKnock.receivedUserName)**")
                                .font(.body)
                                .id(eachKnock.receivedUserName)
                        }
						
						Spacer()
						
                        Text("\(eachKnock.knockedDate.dateValue().timeAgoDisplay())")
							.font(.subheadline)
							.foregroundColor(Color(.systemGray))
							.padding(.leading, -10)
                            .id(eachKnock.knockedDate.dateValue().timeAgoDisplay())
						
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
                                .foregroundColor(Color("GSPurple"))
						} else if eachKnock.knockStatus == Constant.KNOCK_ACCEPTED {
							Text(eachKnock.knockStatus)
								.foregroundColor(Color.accentColor)
						} else {
							Text("\(eachKnock.knockStatus)")
								.foregroundColor(Color("GSRed"))
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
            withAnimation(
                .linear(duration: 0.5).repeatForever(autoreverses: true)
            ) {
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
            // 노크 수신자 == 현재 유저일 경우, 노크 발신자의 정보를 타겟유저로 할당
            if eachKnock.receivedUserID == userInfoManager.currentUser?.id {
                self.targetUserInfo = await userInfoManager.requestUserInfoWithID(userID: eachKnock.sentUserID)
            } else if eachKnock.receivedUserID != userInfoManager.currentUser?.id {
                self.targetUserInfo = await userInfoManager.requestUserInfoWithID(userID: eachKnock.receivedUserID)
            }
        }
    }
}
