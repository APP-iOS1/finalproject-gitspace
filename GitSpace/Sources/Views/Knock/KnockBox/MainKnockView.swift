//
//  MyKnockBoxView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct MainKnockView: View {
	
    @StateObject private var keyboardHandler = KeyboardHandler()
	@EnvironmentObject var tabBarRouter: GSTabBarRouter
	@EnvironmentObject var knockViewManager: KnockViewManager
	
	@State public var knockID: String? = nil
	@State public var pushedKnock: Knock? = nil
    
	// !!!: TAB Branch
    @State private var userSelectedTab: String = Constant.KNOCK_RECEIVED
    @State private var receivedKnockTab: String = Constant.KNOCK_RECEIVED
    @State private var sentKnockTab: String = Constant.KNOCK_SENT
	
	// !!!: FILTER Branch
    @State private var userFilteredKnockState: KnockStateFilter = .all
    
	// !!!: SEARCH Branch
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    
    @State private var isEdit: Bool = false
    @State private var isEditChecked: Bool = false
    @State private var isDisplayedKnockSettingView: Bool = false
    
    var body: some View {
        VStack {
            // MARK: - Tab Buttons
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(
                Color(.systemGray4)
                    .cornerRadius(16)
            )
            .padding(.horizontal, 20)
            .opacity(isSearching ? 1 : 0)
            .frame(height: isSearching ? 40 : 0)
            
            headerTabPagenationViewBuilder()
                .overlay(alignment: .bottom) {
                    Divider()
                        .frame(minHeight: 0.5)
                        .overlay(Color.primary)
                        .offset(y: 3.5)
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
			// 검색중 vs 기본 조건분기
			// 셀 그리는 로직은 고정
			ScrollView {
					// MARK: - 수신 탭
					if userSelectedTab == Constant.KNOCK_RECEIVED {
						LazyVStack(pinnedViews: .sectionHeaders) {
							if !isSearching {
								subHeaderGuideMessageBuilder()
								
								Divider()
									.padding(.horizontal, 20)
							}
							switch userFilteredKnockState {
							case .waiting, .accepted, .declined:
								eachCellSection(
									knockList: knockViewManager.receivedKnockList
								)
							case .all:
								eachCellSection(
									knockList: knockViewManager.receivedKnockList,
									eachFilteredState: .waiting
								)
								
								eachCellSection(
									knockList: knockViewManager.receivedKnockList,
									eachFilteredState: .accepted
								)
								
								eachCellSection(
									knockList: knockViewManager.receivedKnockList,
									eachFilteredState: .declined
								)
							}
						}
						.transition(knockViewManager.leadingTransition)
						.overlay {
							NavigationLink(
								destination: KnockHistoryView(
									eachKnock: pushedKnock ?? Knock(isFailedDummy: true),
								knockMessenger: $userSelectedTab
							), isActive: $tabBarRouter.navigateToKnock) {
								EmptyView()
							}
						}
						.fullScreenCover(isPresented: $isDisplayedKnockSettingView) {
							SetKnockControlsView(
								showingKnockControls: $isDisplayedKnockSettingView
							)
						}
						
					} else if userSelectedTab == Constant.KNOCK_SENT {
						LazyVStack(pinnedViews: .sectionHeaders) {
							if !isSearching {
								subHeaderGuideMessageBuilder()
								
								Divider()
									.padding(.horizontal, 20)
							}
							
							switch userFilteredKnockState {
							case .waiting, .accepted, .declined:
								eachCellSection(
									knockList: knockViewManager.sentKnockList
								)
							case .all:
								eachCellSection(
									knockList: knockViewManager.sentKnockList,
									eachFilteredState: .waiting
								)
								
								eachCellSection(
									knockList: knockViewManager.sentKnockList,
									eachFilteredState: .accepted
								)
								
								eachCellSection(
									knockList: knockViewManager.sentKnockList,
									eachFilteredState: .declined
								)
							}
						}
						.transition(knockViewManager.trailingTransition)
						.overlay {
							NavigationLink(
								destination: KnockHistoryView(
									eachKnock: pushedKnock ?? Knock(isFailedDummy: true),
									knockMessenger: $userSelectedTab
								), isActive: $tabBarRouter.navigateToKnock) {
									EmptyView()
								}
						}
					}
			}
        } // VStack
		.task {
			if let knockID,
			   !tabBarRouter.navigateToKnock {
				async let eachKnock = knockViewManager.requestKnockWithID(knockID: knockID)
				pushedKnock = await eachKnock
				tabBarRouter.navigateToKnock.toggle()
			}
			await knockViewManager.requestKnockList()
			
		}
        .onTapGesture {
            self.endTextEditing()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(userSelectedTab) Knock")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.linear(duration: 0.3)) {
                        isSearching.toggle()
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
            }
			
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEdit ? "Cancel" : "Edit") {
                    withAnimation {
                        isEdit.toggle()
                    }
                }
            }
			
			ToolbarItem(placement: .navigationBarLeading) {
				if isSearching {
					Button {
						withAnimation {
							isSearching.toggle()
						}
					} label: {
						Text("Cancel")
					}
				}
			}
        }
    } // body
    
    // MARK: - METHODS
    @ViewBuilder
    private func headerTabPagenationViewBuilder() -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            GSButton.CustomButtonView(style: .homeTab(
                tabName: receivedKnockTab,
                tabSelection: $userSelectedTab)) {
                    withAnimation {
                        userSelectedTab = receivedKnockTab
                    }
                } label: {
                    Text(receivedKnockTab)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .bold()
                        .padding(.bottom, 4)
                }
            
            Divider()
                .frame(height: 12)
                .overlay {
                    Color.gsDarkGray
                }
                .padding(.horizontal, 4)
            
            GSButton.CustomButtonView(style: .homeTab(
                tabName: sentKnockTab,
                tabSelection: $userSelectedTab)) {
                    withAnimation {
                        userSelectedTab = sentKnockTab
                    }
                } label: {
                    Text(sentKnockTab)
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
        switch userSelectedTab {
        case receivedKnockTab:
            VStack {
                // 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
                Text("Check the message for information about who's Knocking on you.")
                    .foregroundColor(Color(.systemGray))
                
                // 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
                Text("They won't know you've seen it until you respond.")
                    .foregroundColor(Color(.systemGray))
                
                Button {
                    isDisplayedKnockSettingView.toggle()
                } label: {
                    // 나에게 노크 할 수 있는 사람 설정하기
                    Text("Decide who can Knock on You.")
                }
            }
			.font(.caption2)
			.padding(.top, 8)
        case sentKnockTab:
            VStack {
                // 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
                Text("You can check your knock history.")
                
                // 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
                Text("You can't send other messages until your receiver")
                
                Text("has approved your knock")
            }
            .foregroundColor(Color(.systemGray))
			.font(.caption2)
			.padding(.top, 8)
        default:
            EmptyView()
        }
    }
    
	@ViewBuilder
	private func eachCellSection(
		// 받은 노크 혹은 보낸 노크 리스트가 들어온다.
		knockList: [Knock],
		
		// all 케이스를 그릴 때는 각각 상태를 전달해서 그린다.
		eachFilteredState: KnockStateFilter? = nil
	) -> some View {
		Section {
			ForEach(
				!isSearching
				? knockList
					.sorted { knockViewManager.compareTwoKnockWithStatus(lhs: $0, rhs: $1) }
				
				: knockList
					.sorted { knockViewManager.compareTwoKnockWithStatus(lhs: $0, rhs: $1) }
					.filter {
						userSelectedTab == Constant.KNOCK_RECEIVED
						? $0.sentUserName.contains(searchText, isCaseInsensitive: true)
						: $0.receivedUserName.contains(searchText, isCaseInsensitive: true)
					},
				id: \.id) { eachKnock in
					if let eachFilteredState,
					   eachFilteredState.rawValue == eachKnock.knockStatus {
						NavigationLink {
							if eachKnock.knockStatus == Constant.KNOCK_WAITING,
							   userSelectedTab == Constant.KNOCK_RECEIVED {
								ReceivedKnockView()
							} else {
								KnockHistoryView(
									eachKnock: eachKnock,
									knockMessenger: $userSelectedTab
								)
							}
						} label: {
							EachKnockCell(
								userSelectedTab: userSelectedTab,
								eachKnock: eachKnock,
								isEdit: $isEdit
							)
							.foregroundColor(.primary)
						}
					} else if userFilteredKnockState.rawValue == eachKnock.knockStatus {
						NavigationLink {
							if eachKnock.knockStatus == Constant.KNOCK_WAITING,
							   userSelectedTab == Constant.KNOCK_RECEIVED {
								ReceivedKnockView()
							} else {
								KnockHistoryView(
									eachKnock: eachKnock,
									knockMessenger: $userSelectedTab
								)
							}
						} label: {
							EachKnockCell(
								userSelectedTab: userSelectedTab,
								eachKnock: eachKnock,
								isEdit: $isEdit
							)
							.foregroundColor(.primary)
						}
					}
				}
		} header: {
			switch userFilteredKnockState {
			case .waiting, .accepted, .declined:
				if knockViewManager.getKnockCountInKnockList(
						knockList: knockList,
						equalsToKnockStatus:userFilteredKnockState.rawValue,
						isSearching: isSearching,
						searchText: searchText,
						userSelectedTab: userSelectedTab
					) == 0 {
					EmptyView()
				} else {
					HStack {
						Text(userFilteredKnockState.rawValue)
							.bold()
							.font(.headline)
						
						Spacer()
						
						Text(
							knockViewManager.getKnockCountInKnockList(
								knockList: knockList,
								equalsToKnockStatus:userFilteredKnockState.rawValue,
								isSearching: isSearching,
								searchText: searchText,
								userSelectedTab: userSelectedTab
							)
							.description
						)
						.bold()
					}
					.modifier(PinnedViewHeaderModifier())
				}
			case .all:
				if knockViewManager.getKnockCountInKnockList(
					knockList: knockList,
					equalsToKnockStatus: eachFilteredState?.rawValue ?? "",
					isSearching: isSearching,
					searchText: searchText,
					userSelectedTab: userSelectedTab
				) == 0 {
					EmptyView()
				} else {
					HStack {
						Text(eachFilteredState?.rawValue ?? "")
							.bold()
						
						Spacer()
						
						Text(
							knockViewManager.getKnockCountInKnockList(
								knockList: knockList,
								equalsToKnockStatus: eachFilteredState?.rawValue ?? "",
								isSearching: isSearching,
								searchText: searchText,
								userSelectedTab: userSelectedTab
							)
							.description
						)
						.foregroundColor(Color.gsGray2)
					}
					.modifier(PinnedViewHeaderModifier())
				}
			}
		}
	}
} // KnockBoxView()

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

//                knockList
//                    .sorted {
//                        knockHistoryViewModel.compareTwoKnockWithStatus(lhs: $0, rhs: $1)
//                    }
//                    .filter {
//                        knockHistoryViewModel.filterKnockListWithCondition(
//                            eachKnock: $0,
//                            eachFilterOption: filterState,
//                            userFilteredKnockState: userFilteredKnockState,
//                            searchWith: searchWith,
//                            knockType: knockType
//                        )
//                    }
