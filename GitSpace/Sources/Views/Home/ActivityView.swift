//
//  ActivityView.swift
//  GitSpace
//
//  Created by 박제균 on 2023/01/18.
//

import SwiftUI

struct ActivityView: View {
    
    var body: some View {
        
            ScrollView {
                ForEach(1..<5) { number in
                    ActivityFeedView(userNumber: number)
                    Divider()
                }
            } // vstack
    } // body
}



struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
