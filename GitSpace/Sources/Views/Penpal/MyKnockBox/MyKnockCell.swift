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
                    Text("유저 이름 \(knock + 1)")
                        .bold()
                        .font(.headline)
                    
                    Spacer()
                    
//                    Text("﹒")
//                        .font(.subheadline)
//                        .foregroundColor(Color(.systemGray))
//                        .padding(.leading, -5)
                    
                    Text("\(knock + 1)분 전")
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
                    Text("노크 메세지가 출력됩니다.")
                        .lineLimit(1)
                    
                    Spacer()
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
