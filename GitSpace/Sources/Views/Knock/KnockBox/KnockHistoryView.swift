//
//  KnockHistoryView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/31.
//

import SwiftUI

struct KnockHistoryView: View {
	@State var eachKnock: Knock
	@Binding var knockMessenger: String
	
	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(alignment: .center) {
				VStack {
					Image(systemName: "circle")
						.resizable()
						.frame(width: 40, height: 40)
						.padding(.top, 24)
					
					Text("Your Knock message is sent to")
					Text("**\(eachKnock.receiverID)**")
						.multilineTextAlignment(.center)
				}
			} // VStack
			.font(.title3)
			.padding(.bottom, 12)
			
			Text(eachKnock.date.formattedDateString())
				.foregroundColor(.gray)
				.font(.footnote)
			
			HStack {
				Text("Knock Message")
					.foregroundColor(.gsLightGray2)
					.font(.footnote)
				
				Spacer()
				
				Button {
					print()
				} label: {
					Image(systemName: "pencil")
						.foregroundColor(.gsLightGray2)
				}

			}
			.padding([.top, .horizontal], 20)
			.padding(.bottom, 13)
			
			VStack(alignment: .leading) {
				HStack {
					Text("**\(eachKnock.knockMessage)**")
						.font(.callout)
				}
				.frame(maxWidth: UIScreen.main.bounds.width)
				.padding(.vertical, 36)
				.padding(.horizontal, 25)
			} // VStack
			.frame(width: UIScreen.main.bounds.width / 1.2)
			.padding(.horizontal, 20)
			.background {
				RoundedRectangle(cornerRadius: 17)
					.foregroundColor(.white)
					.shadow(
						color: Color(.systemGray6),
						radius: 10,
						x: 5,
						y: 5
					)
					.padding(.horizontal, 10)
			} // Knock Message Bubble
			
			if eachKnock.knockStatus == Constant.KNOCK_ACCEPTED {
				GSButton.CustomButtonView(
					style: .secondary(
						isDisabled: false
					)) {
						print()
					} label: {
						Text("Move To Chat List")
							.bold()
					}
					.padding(.top, 8)
			}
			
			Divider()
				.padding(.top, 8)
				.padding(.bottom, 30)
			
			HStack {
				Text("Knocking Status")
					.foregroundColor(.gsLightGray2)
					.font(.footnote)
				
				Spacer()
			}
			.padding(.leading, 20)
			.padding(.bottom, 16)
			
			VStack(alignment: .leading) {
				HStack(alignment: .top, spacing: 32) {
					Circle()
						.frame(maxWidth: 16, maxHeight: 16)
						.foregroundColor(.green)
						.offset(y: 3)
					
					VStack(alignment: .leading, spacing: 4) {
						Text("Knock Message sent to **\(eachKnock.receiverID)**.")
						
						Text("\(eachKnock.date.formattedDateString())")
							.foregroundColor(.gsLightGray2)
							.font(.footnote)
					}
					
					Spacer()
				}
				.padding(.bottom, 16)
				
				switch eachKnock.knockStatus {
				case "Waiting":
					HStack(alignment: .top, spacing: 32) {
						Circle()
							.frame(maxWidth: 16, maxHeight: 16)
							.foregroundColor(.orange)
							.offset(y: 3)
						
						VStack(alignment: .leading, spacing: 4) {
							Text("Knock Message is Pending.")
							
							Text("\(eachKnock.date.formattedDateString())")
								.foregroundColor(.gsLightGray2)
								.font(.footnote)
						}
					}
					.padding(.bottom, 16)
				case "Accepted":
					HStack(alignment: .top, spacing: 32) {
						Circle()
							.frame(maxWidth: 16, maxHeight: 16)
							.foregroundColor(.green)
							.offset(y: 3)
						
						VStack(alignment: .leading, spacing: 4) {
							Text("**\(eachKnock.receiverID)** has Checked Your Knock Message.")
							
							Text("\(eachKnock.date.formattedDateString())")
								.foregroundColor(.gsLightGray2)
								.font(.footnote)
						}
					}
					.padding(.bottom, 16)
				case "Declined":
					HStack(alignment: .top, spacing: 32) {
						Circle()
							.frame(maxWidth: 16, maxHeight: 16)
							.foregroundColor(.green)
							.offset(y: 3)
						
						VStack(alignment: .leading, spacing: 4) {
							Text("**\(eachKnock.receiverID)** has Checked Your Knock Message.")
							
							Text("\(eachKnock.date.formattedDateString())")
								.foregroundColor(.gsLightGray2)
								.font(.footnote)
						}
					}
					.padding(.bottom, 16)
				default:
					EmptyView()
				}
				Spacer()
				
				switch eachKnock.knockStatus {
				case "Waiting":
					EmptyView()
				case "Accepted":
					HStack(alignment: .top, spacing: 32) {
						Circle()
							.frame(maxWidth: 16, maxHeight: 16)
							.foregroundColor(.green)
						
						VStack(alignment: .leading, spacing: 4) {
							Text("**\(eachKnock.receiverID)** has Accepted your Knock Message.")
							
							Text("\(eachKnock.date.formattedDateString())")
								.foregroundColor(.gsLightGray2)
								.font(.footnote)
						}
					}
				case "Declined":
					HStack(alignment: .top, spacing: 32) {
						Circle()
							.frame(maxWidth: 16, maxHeight: 16)
							.foregroundColor(.red)
							.offset(y: 3)
						
						VStack(alignment: .leading, spacing: 4) {
							Text(
								"**\(eachKnock.receiverID)** has Declined your Knock Message."
							)
							
							Text("\(eachKnock.date.formattedDateString())")
								.foregroundColor(.gsLightGray2)
								.font(.footnote)
							
							Divider()
								.padding(.vertical, 8)
								.padding(.trailing, 20)
							
							Text("**Declined Reason :**")
							
							Text("\(eachKnock.declineMessage ?? "")")
						}
					}
					.padding(.bottom, 16)
				default:
					EmptyView()
				}
				Spacer()
			}
			.padding(.horizontal, 20)
		}
		.toolbar {
			ToolbarItem(placement: .principal) {
				HStack {
					Image(systemName: "circle")
					
					Text("**\(eachKnock.receiverID)**")
				}
			}
		}
	}
}

struct KnockHistoryView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			KnockHistoryView(
				eachKnock: Knock(
					date: Date.now,
					knockMessage: "Lorem Ipsum is simply dummy text of the printin Lorem Ipsum Lorem",
					knockStatus: "Accepted",
					knockCategory: "Offer",
					declineMessage: "I am Currently Employeed, sorry.",
					receiverID: "HEYHEYHEYHEY",
					senderID: "RandomBrazilGuy"
				), knockMessenger: .constant("Sended")
			)
		}
		
	}
}
