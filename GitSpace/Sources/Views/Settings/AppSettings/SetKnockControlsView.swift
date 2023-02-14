//
//  SetKnockControlsView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/14.
//

import SwiftUI

struct SetKnockControlsView: View {
    
    @Binding var showingKnockControls: Bool
    
    @AppStorage(Constant.AppStorageConst.KNOCK_ALL_NOTIFICATION) var isAllNotificationEnabled: Bool?
    @State private var isAllNotiEnabled: Bool = true
    @State private var isDeclinedNotiEnabled: Bool = true
    @State private var isAcceptedNotiEnabled: Bool = true
    
    @State private var showingDeleteKnockHistoryAlert = false
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: $isAllNotiEnabled) {
                    Text("Every Knock")
                }
                
                Toggle(isOn: $isDeclinedNotiEnabled) {
                    Text("Declined Knock")
                }
                .onChange(of: isAllNotiEnabled, perform: { newValue in
                    if !newValue {
                        isDeclinedNotiEnabled = newValue
                    }
                })
                .disabled(isAllNotiEnabled ? false : true)
                
                Toggle(isOn: $isAcceptedNotiEnabled) {
                    Text("Accepted Knock")
                }
                .onChange(of: isAllNotiEnabled, perform: { newValue in
                    if !newValue {
                        isAcceptedNotiEnabled = newValue
                    }
                })
                .disabled(isAllNotiEnabled ? false : true)
                
            } header: {
                Text("Push Notification Types")
            }
            .toggleStyle(SwitchToggleStyle(tint: .gsGreenPrimary))
            
            Section {
                Menu {
                    Button {
                        print(1)
                    } label: {
                        Text("Everyone")
                    }
                    
                    Button {
                        print(1)
                    } label: {
                        Text("Only My Followers")
                    }
                    
                    Button {
                        print(1)
                    } label: {
                        Text("Nobody")
                    }
                } label: {
                    Text("Decide Who can Knock on You")
                }
                
                DisclosureGroup("Blocked Users") {
                    HStack {
                        Text("RandomBrazilGuy")
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Date :")
                                .bold()
                                .font(.caption)
                            Text("23/02/07")
                                .bold()
                                .font(.caption)
                        }
                        .foregroundColor(.gsGray2)
                    }
                }
            } header: {
                Text("Knock Authority")
            } footer: {
                Text("If You block other users, they can't knock on you again.")
            }
            
            Section {
                Button(role: .destructive) {
                    print("모든 노크를 ;;삭제할거임")
                    showingDeleteKnockHistoryAlert.toggle()
                } label: {
                    Text("Remove All Knock Histories")
                }
            } header: {
                Text("History Management")
            } footer: {
                Text("It cannot be restored after Removing All Knock Histories. \nYour Knock History will be terminated in **30 days** automatically.")
            }
        } // ScrollView
        .navigationBarTitle("Knock Controls", displayMode: .inline)
        .alert("Remove All Knock Histories", isPresented: $showingDeleteKnockHistoryAlert) {
              Button("Delete", role: .destructive) {
                  Task {
//                      await GitHubAuthManager.deleteCurrentUser()
//                      await GitHubAuthManager.withdrawal()
                  }
              }
        } message: {
            Text("Are you sure you want to remove all your Knock histories?")
        }
    }
}

struct SetKnockControlsView_Previews: PreviewProvider {
    static var previews: some View {
        SetKnockControlsView(showingKnockControls: .constant(true))
    }
}
