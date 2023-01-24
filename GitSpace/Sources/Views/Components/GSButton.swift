//
//  GSButton.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/20.
//

import SwiftUI

struct GSButton {
	enum ButtonStyle {
		case primary(labelTitle: String? = nil)
		case secondary(labelTitle: String? = nil)
		case tag
		case plainText(labelTitle: String)
		case homeTab(labelTitle: String, tag: Binding<String>)
	}
	
	// 추상화 하는 이유 : 뷰 통일성, 수정에 용이하다.
	// 뷰 자체의 내용은 밖에서 전달.
	// 뷰의 형식만 정의.
	struct CustomButtonView<CustomLabelType: View>: View {
		public let style: ButtonStyle
		public let action: () -> Void
		public var label: CustomLabelType?
		
		var body: some View {
			switch style {
			case .primary(let labelTitle):
				Button(action: action) {
					if let labelTitle {
						Text(labelTitle)
							.bold()
							.buttonLabelSizeModifier(buttonLabelStyle: .primary)
					} else {
						label
							.buttonLabelSizeModifier(buttonLabelStyle: .primary)
						
					}	
				}
				.buttonColorSchemeModifier()
				
			case .secondary(let labelTitle):
				Button(action: action) {
					if let labelTitle {
						Text(labelTitle)
							.bold()
							.buttonLabelSizeModifier(buttonLabelStyle: .secondary)
					} else {
						label
							.buttonLabelSizeModifier(buttonLabelStyle: .secondary)
					}
				}
				.buttonColorSchemeModifier()
			case .tag:
				Button(action: action) {
					label
				}
			case .plainText:
				Button(action: action) {
					label
				}
			case .homeTab:
				Button(action: action) {
					label
				}
			}
		}
		
		init(style: ButtonStyle,
			 action: @escaping () -> Void,
			 @ViewBuilder label: () -> CustomLabelType) {
			self.style = style
			self.action = action
			self.label = label()
		}
	}
}

struct Test2: View {
	@State private var tabSelection = "Starred"
	
	@State private var starTab = "Starred"
	@State private var followTab = "Follow"
	
	var body: some View {
		VStack {
			GSButton.CustomButtonView(style: .primary()) {
				print()
			} label: {
				HStack {
					Text("✨")
					
					Text("Hi")
				}
			}
		}
	}
	
	private func tabMoveTo() -> Void {
		switch tabSelection {
		case starTab:
			withAnimation {
				tabSelection = followTab
			}
		case followTab:
			withAnimation {
				tabSelection = starTab
			}
		default:
			tabSelection = "?.?"
		}
	}
}

struct GSButton_Previews: PreviewProvider {
    static var previews: some View {
		Test2()
    }
}

//		VStack {
//			Text(tabSelection)
//
//			GSButton.ContentView(
//				style: .tabPage,
//				action: tabMoveTo,
//				tabSelectionTag: $tabSelection,
//				tabMoveTo: followTab
//			) {
//				Text(starTab)
//			}
//
//			GSButton.ContentView(
//				style: .tabPage,
//				action: tabMoveTo,
//				tabSelectionTag: $tabSelection,
//				tabMoveTo: starTab
//			) {
//				Text(followTab)
//			}
//
//			GSButton.ContentView(
//				style: .primary,
//				action: tabMoveTo
//			) {
//				Text("Knock")
//			}
//
//			GSButton.ContentView(
//				style: .secondary,
//				action: tabMoveTo
//			) {
//				Text(followTab)
//			}
//
//			GSButton.ContentView(
//				style: .textConfirmation,
//				action: tabMoveTo
//			) {
//				Text("Block @wontaeyoung")
//			}
//
//			GSButton.ContentView(
//				style: .textCancelation,
//				action: tabMoveTo
//			) {
//				Text("Delete Chat")
//			}
//
//			GSButton.ContentView(
//				style: .tag,
//				action: tabMoveTo
//			) {
//				Text("Tag")
//			}
//		}
