//
//  MyKnockSettingView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct KnockSettingView: View {
    @Binding var showingKnockSetting: Bool
	@AppStorage(Constant.AppStorageConst.KNOCK_ALL_NOTIFICATION) var isAllNotificationEnabled: Bool?
	@State private var isAllNotiEnabled: Bool = true
	@State private var isDeclinedNotiEnabled: Bool = true
	@State private var isAcceptedNotiEnabled: Bool = true
    
    var body: some View {
        NavigationView {
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
					Text("If You block other users, they cant knock on you again.")
				}
				
				Section {
					Button(role: .destructive) {
						print("모든 노크를 ;;삭제할거임")
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
            .toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						showingKnockSetting.toggle()
					} label: {
						Text("Cancel")
					}
				}
				
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showingKnockSetting.toggle()
                    } // Button
                } // ToolbarItem
            } // toolbar
        } // NavigationView
    } // body
}

struct MyKnockSettingView_Previews: PreviewProvider {
    static var previews: some View {
        KnockSettingView(showingKnockSetting: .constant(true))
    }
}
