//
//  SelectTagsView.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/01/18.
//

import SwiftUI

struct SelectTagsView: View {
    @Binding var selectedTagList: [Tag]
    @Binding var isShowing: Bool
    
    let colums = [
        GridItem(.adaptive(minimum: 100))
    ]
    
    var body: some View {
        ZStack {
            VStack {
                /* Title */
                VStack {
                    Text("Select Tags")
                        .font(.title)
                        .padding(5)
                    Text("Please select the tag you want.")
                }
                .padding()
                
                /* Tag List */
                LazyVGrid(columns: colums) {
                    ForEach(tagList) { tag in
                        Button {
                            print("\(tag.name)")
                            selectedTagList.append(tag)
                        } label: {
                            Text("\(tag.name)")
                        }
                        .padding(10)
                        .background(Color.black)
                        .foregroundColor(Color(.systemBackground))
                        .cornerRadius(10)
                    }
                }
            }
            VStack {
                Spacer()
                Button {
                    print("Continue")
                    isShowing = false
                } label: {
                    Text("Continue")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                }
                .background(Color(.gray))
                .foregroundColor(Color(.systemBackground))
            }
        }
    }
}

struct SelectTagsView_Previews: PreviewProvider {
    @State static var selectedTagList: [Tag] = []
    @State static var isShowing: Bool = true
    
    static var previews: some View {
        SelectTagsView(selectedTagList: $selectedTagList, isShowing: $isShowing)
    }
}
