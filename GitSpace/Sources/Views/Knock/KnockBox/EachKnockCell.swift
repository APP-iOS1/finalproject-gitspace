//
//  MyKnockCell.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct EachKnockCell: View {
	@ObservedObject var knockHistoryViewModel: KnockHistoryViewModel
	@State var eachKnock: Knock
    @Binding var isEdit: Bool
    @Binding var checked: Bool
	@Binding var knockMessenger: String

    var body: some View {
		VStack {
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
						Text(knockMessenger == "Received" ?
							 "from: \(eachKnock.senderID)" :
								"to: \(eachKnock.receiverID)"
						)
						.bold()
						.font(.headline)
						
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
						
						if eachKnock.knockStatus == "Waiting" {
							Text(eachKnock.knockStatus)
							//.padding(.trailing, 5)
								.foregroundColor(Color(.systemBlue))
						} else if eachKnock.knockStatus == "Accepted" {
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
		}
    }
}

struct MyKnockCell_Previews: PreviewProvider {
    static var previews: some View {
        MainKnockView()
    }
}
