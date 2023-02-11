//
//  MyKnockBoxView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct MainKnockView: View {
    @ObservedObject var knockHistoryViewModel = KnockHistoryViewModel()
    @StateObject private var keyboardHandler = KeyboardHandler()
    
	// !!!: TAB Branch
    @State private var userSelectedTab: String = Constant.KNOCK_RECEIVED
    @State private var receivedKnockTab: String = Constant.KNOCK_RECEIVED
    @State private var sentKnockTab: String = Constant.KNOCK_SENT
	
	// !!!: FILTER Branch
    @State private var userFilteredKnockState: KnockStateFilter = .all
    
	// !!!: SEARCH Branch
    @State private var isSearching: Bool = false
    @State private var searchText: String = ""
    
    @State var isEdit: Bool = false
    @State var checked: Bool = false
    @State var isDisplayedKnockSettingView: Bool = false
    
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
                .padding(.horizontal, 16)
            
			// 검색중 vs 기본 조건분기
			// 셀 그리는 로직은 고정
			if isSearching {
				ScrollView {
					LazyVStack(pinnedViews: .sectionHeaders) {
						
					}
				}
			} else {
				ScrollView {
					LazyVStack(pinnedViews: .sectionHeaders) {
						Text("/")
					}
				}
			}
        } // VStack
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
                    withAnimation(.easeIn(duration: 0.28)) {
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
        case sentKnockTab:
            VStack {
                // 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
                Text("You can check your knock history.")
                
                // 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
                Text("You can't send other messages until your receiver")
                
                Text("has approved your knock")
            }
            .foregroundColor(Color(.systemGray))
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func eachCellSectionBuilder(
        knockList: [Knock],
        filterState: String? = nil,
        searchWith: String? = nil,
        knockType: String? = nil
    ) -> some View {
        Section {
            ForEach(
                knockList
                    .sorted {
                        knockHistoryViewModel.compareTwoKnockWithStatus(lhs: $0, rhs: $1)
                    }
                    .filter {
                        knockHistoryViewModel.filterKnockListWithCondition(
                            eachKnock: $0,
                            eachFilterOption: filterState,
                            userFilteredKnockState: userFilteredKnockState,
                            searchWith: searchWith,
                            knockType: knockType
                        )
                    }, id: \.id) { eachKnock in
                        NavigationLink {
                            if eachKnock.knockStatus == Constant.KNOCK_WAITING {
                                ReceivedKnockView()
                            } else {
                                KnockHistoryView(
                                    eachKnock: eachKnock,
                                    knockMessenger: $userSelectedTab
                                )
                            }
                        } label: {
                            if userSelectedTab == receivedKnockTab {
                                EachKnockCell(
                                    knockMessenger: "from: \(eachKnock.senderID)",
                                    knockHistoryViewModel: knockHistoryViewModel,
                                    eachKnock: eachKnock,
                                    isEdit: $isEdit,
                                    checked: $checked
                                )
                                .foregroundColor(.primary)
                            } else {
                                EachKnockCell(
                                    knockMessenger: "to: \(eachKnock.receiverID)",
                                    knockHistoryViewModel: knockHistoryViewModel,
                                    eachKnock: eachKnock,
                                    isEdit: $isEdit,
                                    checked: $checked
                                )
                                .foregroundColor(.primary)
                            }
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
						Color(.systemBackground),
						Color(.systemBackground).opacity(0.4)
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
