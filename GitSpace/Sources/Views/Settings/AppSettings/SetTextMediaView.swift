//
//  SetTextMediaView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetTextMediaView: View {
    
    @AppStorage("isAutoCompleted") var isAutoCompleted: Bool = false
    @AppStorage("isEnterToSent") var isEnterToSent: Bool = false
    @AppStorage("isDataSaved") var isDataSaved: Bool = false
    
    var body: some View {
        List {
            
            Section {
                Toggle(isOn: $isAutoCompleted) {
                    Text("Use Auto Complete")
                }
                .toggleStyle(SwitchToggleStyle(tint: .gsGreenPrimary))
                
                Toggle(isOn: $isEnterToSent) {
                    Text("Press Enter to Send")
                }
                .toggleStyle(SwitchToggleStyle(tint: .gsGreenPrimary))
                
            } header: {
                Text("Keyboard")
            }
            
            
            
            // MARK: - DATA CONSUMPTION
            Section {
                
                Toggle(isOn: $isDataSaved) {
                    Text("Data Saving Mode")
                }
                .toggleStyle(SwitchToggleStyle(tint: .gsGreenPrimary))
                
            } header: {
                Text("DATA CONSUMPTION")
            } footer: {
                Text("When this is on, images will be sent in lower quality on cellular networks to reduce data usage.")
            }
            
        } // List
        .navigationBarTitle("Text & Media", displayMode: .inline)
    }
}

struct SetTextMediaView_Previews: PreviewProvider {
    static var previews: some View {
        SetTextMediaView()
    }
}
