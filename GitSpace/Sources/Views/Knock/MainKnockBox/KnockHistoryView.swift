//
//  KnockHistoryView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/31.
//

import SwiftUI

struct KnockHistoryView: View {
	@Binding var eachKnock: Knock
	@Binding var userSelectedTab: String
	@EnvironmentObject var knockViewManager: KnockViewManager
	@EnvironmentObject var tabBarRouter: GSTabBarRouter
    @EnvironmentObject var userInfoManager: UserStore
    @State private var targetUserInfo: UserInfo? = nil
    
	var body: some View {
		ScrollView(showsIndicators: false) {
            if let targetUserInfo {
                TopperProfileView(targetUserInfo: targetUserInfo)
            }
			
			Text(
				userSelectedTab == Constant.KNOCK_RECEIVED
				? "\(eachKnock.sentUserName) has sent \nnew Knock Message!"
				: "Your Knock Message is \nsent to \(eachKnock.receivedUserName)"
			)
				.multilineTextAlignment(.center)
				.font(.footnote)
				.padding(.bottom, 4)
			
            Text(eachKnock.knockedDate.dateValue().formattedDateString())
                .foregroundColor(.gsLightGray2)
                .font(.footnote)
            
			HStack {
				Text("Knock Message")
					.foregroundColor(.gsLightGray2)
					.font(.footnote)
				
				Spacer()
				
                // !!!: - 언젠가는 메시지 수정이 가능하도록.
//				Button {
//					print()
//				} label: {
//					Image(systemName: "pencil")
//						.foregroundColor(.gsLightGray2)
//				}

			}
			.padding([.top, .horizontal], 20)
			.padding(.bottom, 13)
			
			VStack(alignment: .leading) {
				HStack {
					Text("**\(eachKnock.knockMessage)**")
						.font(.callout)
                        .foregroundColor(Color.black)
				}
				.frame(maxWidth: UIScreen.main.bounds.width)
				.padding(.vertical, 36)
				.padding(.horizontal, 25)
			} // VStack
			.frame(width: UIScreen.main.bounds.width / 1.2)
			.padding(.horizontal, 20)
			.background {
				RoundedRectangle(cornerRadius: 17)
					.foregroundColor(.white)
					.shadow(
						color: Color(.systemGray6),
						radius: 10,
						x: 5,
						y: 5
					)
					.padding(.horizontal, 10)
			} // Knock Message Bubble
			
			if eachKnock.knockStatus == Constant.KNOCK_ACCEPTED {
				GSButton.CustomButtonView(
					style: .secondary(
						isDisabled: false
					)) {
						print()
					} label: {
						Text("Move To Chat List")
							.bold()
					}
					.padding(.top, 8)
			}
			
			Divider()
				.padding(.top, 8)
				.padding(.bottom, 30)
			
			HStack {
				Text("Knocking Status")
					.foregroundColor(.gsLightGray2)
					.font(.footnote)
				
				Spacer()
			}
			.padding(.leading, 20)
			.padding(.bottom, 16)
			
			VStack(alignment: .leading) {
				HStack(alignment: .top, spacing: 32) {
					Circle()
						.frame(maxWidth: 16, maxHeight: 16)
						.foregroundColor(.green)
						.offset(y: 3)
					
					VStack(alignment: .leading, spacing: 4) {
						Text(
							userSelectedTab == Constant.KNOCK_RECEIVED
							? "**\(eachKnock.sentUserName)** has sent \n Knock Message."
							: "Knock Message sent to **\(eachKnock.receivedUserName)**."
						)
						
                        Text(eachKnock.knockedDate.dateValue().formattedDateString())
                            .foregroundColor(.gsLightGray2)
                            .font(.footnote)
					}
					
					Spacer()
				}
				.padding(.bottom, 16)
				
				switch eachKnock.knockStatus {
                case Constant.KNOCK_WAITING:
					HStack(alignment: .top, spacing: 32) {
						Circle()
							.frame(maxWidth: 16, maxHeight: 16)
							.foregroundColor(.orange)
							.offset(y: 3)
						
						VStack(alignment: .leading, spacing: 4) {
							Text("Knock Message is Pending.")
							
                            Text(eachKnock.knockedDate.dateValue().formattedDateString())
                                .foregroundColor(.gsLightGray2)
                                .font(.footnote)
						}
					}
					.padding(.bottom, 16)
				default:
					EmptyView()
				}
				Spacer()
				
				switch eachKnock.knockStatus {
                case Constant.KNOCK_WAITING:
					EmptyView()
				case Constant.KNOCK_ACCEPTED:
					HStack(alignment: .top, spacing: 32) {
						Circle()
							.frame(maxWidth: 16, maxHeight: 16)
							.foregroundColor(.green)
						
						VStack(alignment: .leading, spacing: 4) {
							Text(
								userSelectedTab == Constant.KNOCK_RECEIVED
								? "You has Accepted **\(eachKnock.sentUserName)**'s Knock Message."
								: "**\(eachKnock.receivedUserName)** has Accepted your Knock Message."
							)
                            .multilineTextAlignment(.leading)
							
                            Text(eachKnock.acceptedDate?.dateValue().formattedDateString() ?? "")
                                .foregroundColor(.gsLightGray2)
                                .font(.footnote)
						}
					}
                case Constant.KNOCK_DECLINED:
					HStack(alignment: .top, spacing: 32) {
						Circle()
							.frame(maxWidth: 16, maxHeight: 16)
							.foregroundColor(.red)
							.offset(y: 3)
						
						VStack(alignment: .leading, spacing: 4) {
							Text(
								userSelectedTab == Constant.KNOCK_RECEIVED
								? "You has Declined **\(eachKnock.sentUserName)**'s Knock Message."
								: "**\(eachKnock.receivedUserName)** has Declined your Knock Message."
							)
                            .multilineTextAlignment(.leading)
							
                            Text(eachKnock.declinedDate?.dateValue().formattedDateString() ?? "")
                                .foregroundColor(.gsLightGray2)
                                .font(.footnote)
							
							Divider()
								.padding(.vertical, 8)
								.padding(.trailing, 20)
							
							Text("**Declined Reason :**")
							
							Text("\(eachKnock.declineMessage ?? "")")
						}
					}
					.padding(.bottom, 16)
				default:
					EmptyView()
				}
				Spacer()
			}
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
		.toolbar {
			ToolbarItem(placement: .principal) {
				HStack {
					Text(
						userSelectedTab == Constant.KNOCK_RECEIVED
						? "**\(eachKnock.sentUserName)**"
						: "**\(eachKnock.receivedUserName)**"
					)
				}
			}
		}
	}
}
//
//struct KnockHistoryView_Previews: PreviewProvider {
//	static var previews: some View {
//		NavigationView {
//			KnockHistoryView(
//				eachKnock: Knock(
//					date: Date.now,
//					knockMessage: "Lorem Ipsum is simply dummy text of the printin Lorem Ipsum Lorem",
//					knockStatus: "Accepted",
//					knockCategory: "Offer",
//					declineMessage: "I am Currently Employeed, sorry.",
//					receivedUserName: "HEYHEYHEYHEY",
//					sentUserName: "RandomBrazilGuy"
//				), userSelectedTab: .constant("Sent")
//			)
//		}
//		
//	}
//}
