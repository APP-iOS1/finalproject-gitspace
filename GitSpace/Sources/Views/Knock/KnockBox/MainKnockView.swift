//
//  MyKnockBoxView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct MainKnockView: View {
	@ObservedObject var knockHistoryViewModel = KnockHistoryViewModel()
	
	@State private var knocks = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
								 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
	
	@State private var userName = []
	@State private var knockMsg = []
	
	@State private var knockMessenger: String = "Received"
	@State private var receivedTab: String = "Received"
	@State private var sendedTab: String = "Sended"
	@State private var userFilteredKnockState: KnockStateFilter = .waiting
	
	@State var searchWord: String = ""
	
	@State var isEdit: Bool = false
	@State var checked: Bool = false
	@State var showingKnockSetting: Bool = false
	
	var body: some View {
		VStack {
			// MARK: - Tab Buttons
			headerTabPagenationViewBuilder()
			.overlay(alignment: .bottom) {
				Divider()
					.frame(minHeight: 0.5)
					.overlay(Color.primary)
					.offset(y: 3.5)
			}
			.padding(.top, 10)
			.padding(.horizontal, 16)
			
			TabView(selection: $knockMessenger) {
				ScrollView {
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
					}
					.font(.caption2)
					.padding(.top, 8)
					
					Divider()
					
					LazyVStack {
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
									switch userFilteredKnockState {
									case .waiting,
											.declined,
											.accepted:
										if eachKnock.knockStatus == userFilteredKnockState.rawValue {
											MyKnockCell(
												knockHistoryViewModel: knockHistoryViewModel,
												eachKnock: eachKnock,
												isEdit: $isEdit,
												checked: $checked,
												knockMessenger: $knockMessenger
											)
											.foregroundColor(.primary)
										}
									case .all:
										MyKnockCell(
											knockHistoryViewModel: knockHistoryViewModel,
											eachKnock: eachKnock,
											isEdit: $isEdit,
											checked: $checked,
											knockMessenger: $knockMessenger
										)
										.foregroundColor(.primary)
									}
								}
							} // ForEach
					} // LazyVStack
				}
				.tag(receivedTab)
				
				ScrollView {
					VStack {
						// 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
						Text("You can check your knock history.")
						
						// 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
						Text("You can't send other messages until your receiver")
						
						Text("has approved your knock")
					}
					.foregroundColor(Color(.systemGray))
					.multilineTextAlignment(.center)
					.font(.caption2)
					.padding(.top, 8)
					
					Divider()
					
					LazyVStack {
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
									switch userFilteredKnockState {
									case .waiting,
											.declined,
											.accepted:
										if eachKnock.knockStatus == userFilteredKnockState.rawValue {
											MyKnockCell(
												knockHistoryViewModel: knockHistoryViewModel,
												eachKnock: eachKnock,
												isEdit: $isEdit,
												checked: $checked,
												knockMessenger: $knockMessenger
											)
											.foregroundColor(.primary)
										}
									case .all:
										MyKnockCell(
											knockHistoryViewModel: knockHistoryViewModel,
											eachKnock: eachKnock,
											isEdit: $isEdit,
											checked: $checked,
											knockMessenger: $knockMessenger
										)
										.foregroundColor(.primary)
									}
								}
							} // ForEach
					} // LazyVStack
				}
				.tag(sendedTab)
			} // TabView
				.tabViewStyle(.page)
		} // VStack
		.navigationBarTitle(knockMessenger + " Knock", displayMode: .inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				NavigationLink {
					Text("검색하기")
				} label: {
					Image(systemName: "magnifyingglass")
						.foregroundColor(.primary)
				}
			}
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
	
	@ViewBuilder
	private func headerTabPagenationViewBuilder() -> some View {
		HStack(spacing: 12) {
			GSButton.CustomButtonView(style: .homeTab(
				tabName: receivedTab,
				tabSelection: $knockMessenger)) {
					withAnimation {
						knockMessenger = receivedTab
					}
				} label: {
					Text(receivedTab)
						.font(.title3)
						.foregroundColor(.primary)
						.bold()
						.padding(.bottom, 4)
				}
			
			GSButton.CustomButtonView(style: .homeTab(
				tabName: sendedTab,
				tabSelection: $knockMessenger)) {
					withAnimation {
						knockMessenger = sendedTab
					}
				} label: {
					Text(sendedTab)
						.font(.title3)
						.foregroundColor(.primary)
						.bold()
						.padding(.bottom, 4)
				}
			
			Spacer()
			
			Menu {
				Button {
					withAnimation {
						userFilteredKnockState = .all
					}
				} label: {
					Text("See All")
				}
				
				Button {
					withAnimation {
						userFilteredKnockState = .waiting
					}
				} label: {
					Text("See Waiting")
				}
				
				Button {
					withAnimation {
						userFilteredKnockState = .accepted
					}
				} label: {
					Text("See Accepted")
				}
				
				Button {
					withAnimation {
						userFilteredKnockState = .declined
					}
				} label: {
					Text("See Declined")
				}
			} label: {
				Image(systemName: "line.3.horizontal.decrease")
					.foregroundColor(.primary)
			}
		}
	}
} // MyKnockBoxView()

struct KnockBoxView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			MainKnockView()
		}
	}
}

enum KnockStateFilter: String {
	case waiting = "Waiting"
	case accepted = "Accepted"
	case declined = "Declined"
	case all = "All"
}
