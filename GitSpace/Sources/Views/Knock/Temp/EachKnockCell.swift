//
//  MyKnockCell.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct EachKnockCell: View {
    public let userNameText: String
	@Binding var eachKnock: Knock
    @Binding var isEdit: Bool
    @State private var isChecked: Bool = false
	
	// MARK: - body
    var body: some View {
		VStack {
			HStack(alignment: .center) {
				if isEdit {
					Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 30, height: 30)
						.foregroundColor(isChecked ? Color(UIColor.systemBlue) : Color.secondary)
						.onTapGesture {
							self.isChecked.toggle()
						}
				}
				
				Image(systemName: "person.crop.circle.fill")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 50, height: 50)
				
				VStack {
					HStack {
						Text(userNameText)
							.font(.body)
						
						Spacer()
						
						Text("\(eachKnock.dateDiff)m")
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
						Text(eachKnock.knockMessage)
							.lineLimit(1)
						
						Spacer()
						
						if eachKnock.knockStatus == Constant.KNOCK_WAITING {
							Text(eachKnock.knockStatus)
							//.padding(.trailing, 5)
								.foregroundColor(Color(.systemBlue))
						} else if eachKnock.knockStatus == Constant.KNOCK_ACCEPTED {
							Text(eachKnock.knockStatus)
							//.padding(.trailing, 5)
								.foregroundColor(Color(.systemGreen))
						} else {
							Text("\(eachKnock.knockStatus)")
							//.padding(.trailing, 0)
								.foregroundColor(Color(.systemRed))
						}
					} // HStack
					.font(.subheadline)
					.foregroundColor(Color(.systemGray))
					
					
				} // VStack
				
			} // HStack
			.padding(.vertical, 5)
			.padding(.horizontal)
			
			Divider()
				.padding(.horizontal, 20)
		}
    }
	
}
