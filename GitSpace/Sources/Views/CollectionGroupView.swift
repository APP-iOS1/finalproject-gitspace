//
//  CollectionGroupView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/20.
//

import SwiftUI

struct CollectionGroupView: View {
    @StateObject var vm : CollectionGroupViewModel = CollectionGroupViewModel()
    
    var body: some View {
        VStack {
            Button {
                Task {
                    vm.requestData(userID: "dduri")
                }
            } label: {
                Text("패치하기")
            }
            
            List {
                ForEach(vm.reviews) { review in
                    Text(review.content)
                }
            }
            
        }
    }
}

struct CollectionGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionGroupView()
    }
}
