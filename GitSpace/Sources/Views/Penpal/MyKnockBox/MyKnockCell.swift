//
//  MyKnockCell.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct MyKnockCell: View {
    
    @Binding var knock: Int
    @Binding var isEdit: Bool
    @Binding var checked: Bool
    
    @State private var knockStates = ["Waiting", "Waiting", "Waiting", "Accepted", "Accepted",
                                      "Declined", "Accepted", "Declined", "Declined", "Declined",
                                      "Accepted", "Accepted", "Accepted", "Accepted", "Accepted",
                                      "Declined", "Declined", "Accepted", "Accepted", "Declined"]
    
    var body: some View {
        
        HStack(alignment: .center) {
            
            if isEdit {
                
                Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
                    .onTapGesture {
                        self.checked.toggle()
                    }
                    
            }
            
            
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            VStack {
                HStack {
                    Text("User Name \(knock + 1)")
                        .bold()
                        .font(.headline)
                    
                    Spacer()
                    
//                    Text("﹒")
//                        .font(.subheadline)
//                        .foregroundColor(Color(.systemGray))
//                        .padding(.leading, -5)
                    
                    Text("\(knock + 1)m")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                        .padding(.leading, -10)
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color(.systemGray))
                    
                } // HStack
                
                HStack {
                    Text("Knock message will be displayed.")
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if knockStates[knock] == "Waiting" {
                        Text("\(knockStates[knock])")
                            //.padding(.trailing, 5)
                            .bold()
                            .foregroundColor(Color(.systemBlue))
                    } else if knockStates[knock] == "Accepted" {
                        Text("\(knockStates[knock])")
                            //.padding(.trailing, 5)
                            .bold()
                            .foregroundColor(Color(.systemGreen))
                    } else {
                        Text("\(knockStates[knock])")
                            //.padding(.trailing, 0)
                            .bold()
                            .foregroundColor(Color(.systemRed))
                    }
                } // HStack
                .font(.subheadline)
                .foregroundColor(Color(.systemGray))
                
                
            } // VStack
            
        } // HStack
        .padding(.vertical, 5)
        .padding(.horizontal)
    }
}

struct MyKnockCell_Previews: PreviewProvider {
    static var previews: some View {
        MyKnockBoxView()
    }
}
