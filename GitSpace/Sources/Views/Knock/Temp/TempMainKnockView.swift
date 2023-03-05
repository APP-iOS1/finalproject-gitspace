//
//  TempMainKnockView.swift
//  GitSpace
//
//  Created by Celan on 2023/03/04.
//

// !!!: - DEPRECATED

import SwiftUI

struct TempMainKnockView: View {
    @StateObject private var keyboardHandler = KeyboardHandler()
    @EnvironmentObject var tabBarRouter: GSTabBarRouter
    @EnvironmentObject var knockViewManager: KnockViewManager
//    @EnvironmentObject var userInfoManager: UserStore
    
    // !!!: TAB Branch
    @State private var userSelectedTab: String = Constant.KNOCK_RECEIVED
    @State private var receivedKnockTab: String = Constant.KNOCK_RECEIVED
    @State private var sentKnockTab: String = Constant.KNOCK_SENT
    
    // !!!: FILTER Branch
    @State private var userFilteredKnockState: KnockStateFilter = .all
    
    // !!!: SEARCH Branch
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    @State private var isEditing: Bool = false

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
            .padding(8)
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
            
            ScrollView {
                if userSelectedTab == Constant.KNOCK_RECEIVED {
                    ForEach(knockViewManager.receivedKnockList, id: \.id) { eachKnock in
                        ReceivedKnockTabView(
                            eachKnock: eachKnock,
                            userSelectedTab: $userSelectedTab,
                            isEditing: $isEditing,
                            userFileteredOption: $userFilteredKnockState
                        )
                            .transition(knockViewManager.leadingTransition)
                    }
                } else if userSelectedTab == Constant.KNOCK_SENT {
                    ForEach(knockViewManager.sentKnockList, id: \.id) { eachKnock in
                        Text("\(eachKnock.id)")
                            .transition(knockViewManager.trailingTransition)
                    }
                }
            }
        }
        .task {
//            await knockViewManager.requestKnockList(currentUser: .getFaliedUserInfo())
            await knockViewManager.addSnapshotToKnock(currentUser: .getFaliedUserInfo())
        }
    }
    
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
                    Text("\(Constant.KNOCK_ALL)")
                }
                
                Button {
                    withAnimation {
                        userFilteredKnockState = .waiting
                    }
                } label: {
                    Text("\(Constant.KNOCK_WAITING)")
                }
                
                Button {
                    withAnimation {
                        userFilteredKnockState = .accepted
                    }
                } label: {
                    Text("\(Constant.KNOCK_ACCEPTED)")
                }
                
                Button {
                    withAnimation {
                        userFilteredKnockState = .declined
                    }
                } label: {
                    Text("\(Constant.KNOCK_DECLINED)")
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .foregroundColor(.primary)
            }
        }
    }
}

struct TempMainKnockView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TempMainKnockView()
                .environmentObject(GSTabBarRouter())
                .environmentObject(KnockViewManager())
        }
    }
}

enum KnockStateFilter: String {
    case waiting = "Waiting"
    case accepted = "Accepted"
    case declined = "Declined"
    case all = "All"
}
