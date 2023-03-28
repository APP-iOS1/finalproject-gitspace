//
//  SetNotificationsView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetNotificationsView: View {
    @State private var isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
    @State private var isPushNotificationAlertDisplayed: Bool = false
    
    @AppStorage(Constant.AppStorageConst.IS_CHAT_PUSH_NOTIFICATION_TURNED_ON) var isOnChat: Bool = true
    @AppStorage(Constant.AppStorageConst.IS_KNOCK_PUSH_NOTIFICATION_TURNED_ON) var isOnKnock: Bool = true
    @EnvironmentObject var userStore: UserStore
    
//    @AppStorage("isWorkingHours") var isWorkingHours: Bool = false
//    @AppStorage("WorkingHoursFrom") var workingHoursFrom: String = ""
//    @AppStorage("WorkingHoursTo") var workingHoursTo: String = ""
//
//    @AppStorage("isOnStar") var isOnStar: Bool = false
//    @AppStorage("isOnActivity") var isOnActivity: Bool = false
//    @AppStorage("isOnInAppVibes") var isOnInAppVibes: Bool = false
//    @AppStorage("isOnInAppSounds") var isOnInAppSounds: Bool = false
    
    var body: some View {
        List {
            
            // MARK: - 보류
//            Section {
//                NavigationLink {
//                    SetWorkingHoursView()
//                } label: {
//                    HStack {
//                        Text("Working Hours")
//                            .foregroundColor(.primary)
//                        Spacer()
//                        Text("\(isWorkingHours ? "Custom" : "Off")")
//                            .foregroundColor(.gsLightGray2)
//                    }
//                }
//            } footer: {
//                if isWorkingHours {
//                    Text("Allow push notifications every day from \(workingHoursFrom) to \(workingHoursTo)")
//                }
//            } // Section
            
            Section {
                // MARK: - GitHub API에서 해당 알람을 받을 수 있는지 체크 필요
//                Toggle(isOn: $isOnStar) {
//                    VStack(alignment: .leading) {
//                        Text("New Stars")
//                        Text("Someone starred your repository")
//                            .font(.footnote)
//                            .foregroundColor(.gsLightGray2)
//                    }
//                }
//
//                Toggle(isOn: $isOnActivity) {
//                    VStack(alignment: .leading) {
//                        Text("Activity")
//                        Text("Someone starred some repository")
//                            .font(.footnote)
//                            .foregroundColor(.gsLightGray2)
//                    }
//                }
                
                Toggle(isOn: $isRegisteredForRemoteNotifications) {
                    VStack(alignment: .leading) {
                        Text("All Notifications")
                            .font(.footnote)
                            .foregroundColor(.gsLightGray2)
                    }
                }
                .onChange(of: isRegisteredForRemoteNotifications) { newValue in
                    if !newValue { // 알람 거부
                        isOnChat = false
                        isOnKnock = false
                    } else if newValue { // 알람 승인
                        isOnChat = true
                        isOnKnock = true
                    }
                }
                
                Toggle(isOn: $isOnKnock) {
                    VStack(alignment: .leading) {
                        Text("New Knocks")
                        Text("Someone knocked on you")
                            .font(.footnote)
                            .foregroundColor(.gsLightGray2)
                    }
                }
                .disabled(isRegisteredForRemoteNotifications ? false : true)
                
                Toggle(isOn: $isOnChat) {
                    VStack(alignment: .leading) {
                        Text("Messages")
                        Text("Someone sent you a new message")
                            .font(.footnote)
                            .foregroundColor(.gsLightGray2)
                    }
                }
                .disabled(isRegisteredForRemoteNotifications ? false : true)
                
                // MARK: - 보류
//                Toggle(isOn: $isOnInAppVibes) {
//                    Text("In-App Vibrations")
//                }
//
//                Toggle(isOn: $isOnInAppSounds) {
//                    Text("In-App Sounds")
//                }
            } header: {
                Text("PUSH NOTIFICATION TYPES")
            } // Section
            .toggleStyle(SwitchToggleStyle(tint: .gsGreenPrimary))
            
        } // List
        .navigationBarTitle("Notifications", displayMode: .inline)
        .onDisappear {
            Task {
                await userStore.updateUserInfoOnFirestore(
                    userID: userStore.currentUser?.id ?? "",
                    with: .knockPushNotificationAceeptance(isPushAvailable: isOnKnock), .chatPushNotificationAceeptance(isPushAvailable: isOnChat)
                )
            }
        }
    } // body
}

struct SetNotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        SetNotificationsView()
    }
}
