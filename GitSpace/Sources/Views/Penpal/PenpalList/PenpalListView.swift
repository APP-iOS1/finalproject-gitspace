//
//  PenpalListView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/18.
//

import SwiftUI

struct PenpalListView: View {
	@State private var isKnockModalDisplayed: Bool = false
	
    var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading,
					   spacing: 0,
					   pinnedViews: .sectionHeaders) {
				
				Section {
					TabView {
						ForEach(0..<5) { int in
							HStack {
								RecommendationPageCell(isKnockModalDisplayed: $isKnockModalDisplayed)
							}
						}
					}
					.frame(height: 150)
					.tabViewStyle(.page)
				} header: {
					Text("Recommendation")
						.font(.footnote)
						.foregroundColor(.gray)
						.padding(.leading, 10)
				}
				
				Divider()
					.padding(.vertical, 20)
					.padding(.horizontal, 10)
				
				Section {
					ForEach(0..<5) { int in
						UserProfileCompact()
							.padding(.vertical, 5)
					}
				} header: {
					Text("Penpal")
						.font(.footnote)
						.foregroundColor(.gray)
						.padding(.leading, 10)
				}
				
			}
		}
		.sheet(isPresented: $isKnockModalDisplayed, content: {
			NavigationView {
				SendKnockModal(isKnockModalDisplayed: $isKnockModalDisplayed)
			}
		})
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Text("GitSpace")
					.bold()
			}
			
			ToolbarItemGroup(placement: .navigationBarTrailing) {
				NavigationLink {
					Text("MyKnockBox")
				} label: {
					Text("📦")
				}
				
				Button {
					print("toggle")
				} label: {
					Image(systemName: "square.and.pencil")
						.foregroundColor(.black)
				}
			}
		}
    }
}

struct PenpalListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RecommendationPageCell: View {
	@Binding var isKnockModalDisplayed: Bool
	
	var body: some View {
		UserProfileCompact()
		.frame(alignment: .leading)
		.padding(.leading, 20)
		.padding(.top, 10)
		.overlay(alignment: .bottomTrailing) {
			Button {
				isKnockModalDisplayed.toggle()
			} label: {
				Text("Knock")
					.bold()
			}
			.buttonStyle(.borderedProminent)
			.tint(.black)
			.padding(.trailing, 20)
			.padding(.bottom, 50)
		}
		.background {
			Rectangle()
				.foregroundColor(Color(.systemGray4))
				.frame(width: UIScreen.main.bounds.width - 20)
		}
	}
}

struct UserProfileCompact: View {
	var body: some View {
		VStack(alignment: .leading) {
			HStack(alignment: .top) {
				Image(systemName: "person")
					.resizable()
					.frame(width: 50, height: 50)
					.aspectRatio(1, contentMode: .fit)
				
				VStack(alignment: .leading) {
					Text("José Nicolas Delaco")
						.bold()
					
					Text("@randombrazilguy")
						.foregroundColor(Color(.systemGray))
					
					Spacer()
				}
				
				Spacer()
			}
		}
		.frame(alignment: .leading)
		.padding(.leading, 20)
		.padding(.top, 10)
	}
}
