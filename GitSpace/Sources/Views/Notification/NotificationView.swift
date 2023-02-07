//
//  NotificationView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/07.
//

import SwiftUI

struct NotificationView: View {
    
    var body: some View {
        
        ScrollView {
            
            ForEach(0..<10) { _ in
                KnockNotificationCell()
                Divider()
                SystemNotificationCell()
                Divider()
            }
            
        }
//        .padding(.top, 20)
        .navigationBarTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationView()
        }
    }
}
