//
//  ListenerView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/20.
//

import SwiftUI

struct ListenerView: View {
    
    @StateObject var vm : ListenerViewModel = ListenerViewModel()
    
    var body: some View {
        
        VStack {
            
            Button {
                Task {
                    vm.addListener()
                }
            } label: {
                Text("리스너 활성화")
            }
            
            Button {
                Task {
                    vm.requestData(userID: "kaz")
                }
            } label: {
                Text("패치하기")
            }
         
            List {
                ForEach(vm.reviews) {review in
                    Text(review.content)
                }
            }
            
        }
    }
}

struct ListenerView_Previews: PreviewProvider {
    static var previews: some View {
        ListenerView()
    }
}
