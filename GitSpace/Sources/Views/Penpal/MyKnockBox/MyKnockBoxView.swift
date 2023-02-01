//
//  MyKnockBoxView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct MyKnockBoxView: View {
	@ObservedObject var knockHistoryViewModel = KnockHistoryViewModel()
	
	@State private var knocks = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
								 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
	
	@State private var userName = []
	@State private var knockMsg = []
	
	@State private var knockMessenger: String = "Received"
	@State private var receiverTab: String = "Received"
	@State private var senderTab: String = "Sended"
	
	@State var searchWord: String = ""
	
	@State var isEdit: Bool = false
	@State var checked: Bool = false
	@State var showingKnockSetting: Bool = false
	
	var body: some View {
		ScrollView {
			// MARK: - Tab Buttons
			HStack(spacing: 12) {
				GSButton.CustomButtonView(style: .homeTab(
					tabName: receiverTab,
					tabSelection: $knockMessenger)) {
						withAnimation {
							knockMessenger = receiverTab
						}
					} label: {
						Text(receiverTab)
							.font(.title3)
							.foregroundColor(.primary)
							.bold()
							.padding(.bottom, 4)
					}
				
				GSButton.CustomButtonView(style: .homeTab(
					tabName: senderTab,
					tabSelection: $knockMessenger)) {
						withAnimation {
							knockMessenger = senderTab
						}
					} label: {
						Text(senderTab)
							.font(.title3)
							.foregroundColor(.primary)
							.bold()
							.padding(.bottom, 4)
					}
				
				Spacer()
			}
			.overlay(alignment: .bottom) {
				Divider()
					.frame(minHeight: 0.5)
					.overlay(Color.primary)
					.offset(y: 3.5)
			}
			.padding(.horizontal, 16)
			
			// MARK: - List
			switch knockMessenger {
			case receiverTab:
				LazyVStack {
					VStack {
						// 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
						Text("Check the message for information about who's Knocking on you.")
							.foregroundColor(Color(.systemGray))

						// 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
						Text("They won't know you've seen it until you respond.")
							.foregroundColor(Color(.systemGray))

						Button {
							showingKnockSetting.toggle()
						} label: {
							// 나에게 노크 할 수 있는 사람 설정하기
							Text("Decide who can Knock on you")
						}
						.padding(.top, -3)
					}
					.font(.caption2)
					.padding(3)

					Divider()

					// MARK: - Knock Cell
					ForEach(
						knockHistoryViewModel.receivedKnockLists.sorted {
							knockHistoryViewModel.compareTwoKnockWithStatus(lhs: $0, rhs: $1)
						},
						id: \.self) { eachKnock in
							NavigationLink {

								if eachKnock.knockStatus == "Waiting" {
									ReceivedKnockView()
								} else {
									KnockHistoryView(
										eachKnock: eachKnock,
										knockMessenger: $knockMessenger
									)
								}
							} label: {
								MyKnockCell(
									knockHistoryViewModel: knockHistoryViewModel,
									eachKnock: eachKnock,
									isEdit: $isEdit,
									checked: $checked,
									knockMessenger: $knockMessenger
								)
								.foregroundColor(.black)
							}
							Divider()
						} // ForEach
						.searchable(
							text: $searchWord,
							placement: .navigationBarDrawer(displayMode: .always),
							prompt: "Search..."
						)
				} // LazyVStack
				.tag(receiverTab)
				
			case senderTab:
				LazyVStack {
					VStack {
						// 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
						Text("You can check your knock history.")
							.foregroundColor(Color(.systemGray))
						
						// 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
						Text("You can't send other messages until your receiver has approved your knock")
							.foregroundColor(Color(.systemGray))
							.multilineTextAlignment(.center)
					}
					.font(.caption2)
					.padding(3)
					
					Divider()
					
					// MARK: - Knock Cell
					ForEach(
						knockHistoryViewModel.sendedKnockLists.sorted {
							knockHistoryViewModel.compareTwoKnockWithStatus(lhs: $0, rhs: $1)
						},
						id: \.self) { eachKnock in
							NavigationLink {
								KnockHistoryView(
									eachKnock: eachKnock,
									knockMessenger: $knockMessenger
								)
							} label: {
								MyKnockCell(
									knockHistoryViewModel: knockHistoryViewModel,
									eachKnock: eachKnock,
									isEdit: $isEdit,
									checked: $checked,
									knockMessenger: $knockMessenger
								)
								.foregroundColor(.black)
							}
							Divider()
						} // ForEach
						.searchable(
							text: $searchWord,
							placement: .navigationBarDrawer(displayMode: .always),
							prompt: "Search..."
						)
				} // LazyVStack
				.tag(senderTab)
			default:
				EmptyView()
			}
		} // ScrollView
		.navigationBarTitle(knockMessenger + " Knock", displayMode: .inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(isEdit ? "Cancel" : "Edit") {
					withAnimation(.easeIn(duration: 0.28)) {
						isEdit.toggle()
					}
				}
			}
		}
		.fullScreenCover(isPresented: $showingKnockSetting) {
			MyKnockSettingView(showingKnockSetting: $showingKnockSetting)
		}
	} // body
} // MyKnockBoxView()

struct MyKnockBoxView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			MyKnockBoxView()
		}
	}
}
