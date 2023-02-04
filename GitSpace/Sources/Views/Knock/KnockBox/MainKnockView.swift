//
//  MyKnockBoxView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct MainKnockView: View {
	@ObservedObject var knockHistoryViewModel = KnockHistoryViewModel()
	
	@State private var knockMessenger: String = "Received"
	@State private var receivedTab: String = "Received"
	@State private var sentTab: String = "Sent"
	@State private var userFilteredKnockState: KnockStateFilter = .all
	
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
					subHeaderGuideMessageBuilder()
						.font(.caption2)
						.padding(.top, 8)
					
					Divider()
					
					LazyVStack(pinnedViews: .sectionHeaders) {
						switch userFilteredKnockState {
						case .waiting,
								.accepted,
								.declined:
							eachCellSectionBuilder(knockList: knockHistoryViewModel.receivedKnockLists)
						case .all:
							eachCellSectionBuilder(
								knockList: knockHistoryViewModel.receivedKnockLists,
								filterState: Constant.KNOCK_WAITING
							)
							eachCellSectionBuilder(
								knockList: knockHistoryViewModel.receivedKnockLists,
								filterState: Constant.KNOCK_ACCEPTED
							)
							eachCellSectionBuilder(
								knockList: knockHistoryViewModel.receivedKnockLists,
								filterState: Constant.KNOCK_DECLINED
							)
						}
					} // LazyVStack
				}
				.tag(receivedTab)
				.fullScreenCover(isPresented: $showingKnockSetting) {
					MyKnockSettingView(showingKnockSetting: $showingKnockSetting)
				}
				
				ScrollView {
					subHeaderGuideMessageBuilder()
						.foregroundColor(Color(.systemGray))
						.multilineTextAlignment(.center)
						.font(.caption2)
						.padding(.top, 8)
					
					Divider()
					
					LazyVStack(pinnedViews: .sectionHeaders) {
						switch userFilteredKnockState {
						case .waiting,
								.accepted,
								.declined:
							eachCellSectionBuilder(knockList: knockHistoryViewModel.sentKnockLists)
						case .all:
							eachCellSectionBuilder(
								knockList: knockHistoryViewModel.sentKnockLists,
								filterState: Constant.KNOCK_WAITING
							)
							eachCellSectionBuilder(
								knockList: knockHistoryViewModel.sentKnockLists,
								filterState: Constant.KNOCK_ACCEPTED
							)
							eachCellSectionBuilder(
								knockList: knockHistoryViewModel.sentKnockLists,
								filterState: Constant.KNOCK_DECLINED
							)
						}
					} // LazyVStack
				}
				.tag(sentTab)
				
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
	} // body
	
	// MARK: - METHODS
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
				tabName: sentTab,
				tabSelection: $knockMessenger)) {
					withAnimation {
						knockMessenger = sentTab
					}
				} label: {
					Text(sentTab)
						.font(.title3)
						.foregroundColor(.primary)
						.bold()
						.padding(.bottom, 4)
				}
			
			Spacer()
			
			Text("\(userFilteredKnockState.rawValue)")
				.bold()
				.font(.footnote)
				.foregroundColor(.gsGray2)
			
			Menu {
				Button {
					withAnimation {
						userFilteredKnockState = .all
					}
				} label: {
					Text("See \(Constant.KNOCK_ALL)")
				}
				
				Button {
					withAnimation {
						userFilteredKnockState = .waiting
					}
				} label: {
					Text("See \(Constant.KNOCK_WAITING)")
				}
				
				Button {
					withAnimation {
						userFilteredKnockState = .accepted
					}
				} label: {
					Text("See \(Constant.KNOCK_ACCEPTED)")
				}
				
				Button {
					withAnimation {
						userFilteredKnockState = .declined
					}
				} label: {
					Text("See \(Constant.KNOCK_DECLINED)")
				}
			} label: {
				Image(systemName: "line.3.horizontal.decrease")
					.foregroundColor(.primary)
			}
		}
	}
	
	@ViewBuilder
	private func subHeaderGuideMessageBuilder() -> some View {
		switch knockMessenger {
		case receivedTab:
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
		case sentTab:
			VStack {
				// 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
				Text("You can check your knock history.")
				
				// 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
				Text("You can't send other messages until your receiver")
				
				Text("has approved your knock")
			}
		default:
			EmptyView()
		}
	}
	
	@ViewBuilder
	private func eachCellSectionBuilder(
		knockList: [Knock],
		filterState: String? = nil
	) -> some View {
		Section {
			ForEach(
				knockList
					.sorted {
						knockHistoryViewModel.compareTwoKnockWithStatus(lhs: $0, rhs: $1)
					}.filter {
						if let filterState {
							return $0.knockStatus == filterState
						} else {
							return $0.knockStatus == userFilteredKnockState.rawValue
						}
					}, id: \.id) { eachKnock in
						NavigationLink {
							if eachKnock.knockStatus == Constant.KNOCK_WAITING {
								ReceivedKnockView()
							} else {
								KnockHistoryView(
									eachKnock: eachKnock,
									knockMessenger: $knockMessenger
								)
							}
						} label: {
							EachKnockCell(
								knockHistoryViewModel: knockHistoryViewModel,
								eachKnock: eachKnock,
								isEdit: $isEdit,
								checked: $checked,
								knockMessenger: $knockMessenger
							)
							.foregroundColor(.primary)
						}
					}
		} header: {
			HStack {
				Text("\(filterState ?? userFilteredKnockState.rawValue)")
					.bold()
					.font(.headline)
					.frame(maxWidth: .infinity)
				
				Spacer()
			}
			.padding(.vertical, 12)
			.padding(.horizontal, 20)
			.frame(alignment: .leading)
			.background {
				LinearGradient(
					colors: [
						Color.white,
						Color.white.opacity(0.4),
					],
					startPoint: .top,
					endPoint: .bottom
				)
			}
			
			Divider()
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

//
//// MARK: - Knock Cell
//ForEach(
//	knockHistoryViewModel.receivedKnockLists.sorted {
//		knockHistoryViewModel.compareTwoKnockWithStatus(lhs: $0, rhs: $1)
//	},
//	id: \.self) { eachKnock in
//		NavigationLink {
//			if eachKnock.knockStatus == "Waiting" {
//				ReceivedKnockView()
//			} else {
//				KnockHistoryView(
//					eachKnock: eachKnock,
//					knockMessenger: $knockMessenger
//				)
//			}
//		} label: {
//			switch userFilteredKnockState {
//			case .waiting,
//					.declined,
//					.accepted:
//				if eachKnock.knockStatus == userFilteredKnockState.rawValue {
//					EachKnockCell(
//						knockHistoryViewModel: knockHistoryViewModel,
//						eachKnock: eachKnock,
//						isEdit: $isEdit,
//						checked: $checked,
//						knockMessenger: $knockMessenger
//					)
//					.foregroundColor(.primary)
//				}
//			case .all:
//				EachKnockCell(
//					knockHistoryViewModel: knockHistoryViewModel,
//					eachKnock: eachKnock,
//					isEdit: $isEdit,
//					checked: $checked,
//					knockMessenger: $knockMessenger
//				)
//				.foregroundColor(.primary)
//			}
//		}
//		} // ForEach
