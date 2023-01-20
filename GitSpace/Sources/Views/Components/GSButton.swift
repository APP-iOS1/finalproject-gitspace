//
//  GSButton.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/20.
//

import SwiftUI

struct GSButton {
	enum ButtonStyle {
		case primary // width 300
		case secondary // width 150
		case tabPage // Text + Underline
		case textCancelation // text + accentColor
		case textConfirmation // text + Color.red
		case tag // width 100
		case symbols // Image(systemName:)
	}
	
	// 추상화 하는 이유 : 뷰 통일성, 수정에 용이하다.
	struct ContentView<ContentView: View>: View {
		typealias FunctionType = () -> Void
		
		var style: ButtonStyle
		var tagSelection: Binding<Bool>?
		var action: () -> Void
		var tabSelectionTag: Binding<String>?
		var tabMoveTo: String?
		var content: () -> ContentView
		
		var body: some View {
			switch style {
			case .primary:
				Button(action: action,
					   label: {
					content()
						.font(.title)
						.padding(.horizontal, 50)
						.padding(.vertical, 10)
				})
				.buttonBorderShape(ButtonBorderShape.capsule)
				.buttonStyle(.borderedProminent)
				.tint(Color.accentColor)
			case .secondary:
				Button(action: action, label: {
					content()
						.padding(.horizontal, 15)
						.padding(.vertical, 5)
				})
				.buttonBorderShape(ButtonBorderShape.capsule)
				.buttonStyle(.borderedProminent)
				.tint(Color.accentColor)

			case .tabPage:
				VStack(spacing: 0) {
					Button(action: action, label: {
						content()
							.font(.largeTitle)
					})
					.foregroundColor(.black)
					.overlay(alignment: .bottom) {
						if let tabSelectionTag,
						   let tabMoveTo,
						   tabSelectionTag.wrappedValue != tabMoveTo {
							Divider()
								.overlay(Color.accentColor)
								.offset(x: 0, y: 0)
						}
					}
				}
			case .textCancelation:
				Button(action: action, label: content)
					.foregroundColor(.red)
			case .textConfirmation:
				Button(action: action, label: content)
					.foregroundColor(.accentColor)
			case .tag: // 해결
				Button(action: action, label: content)
					.buttonBorderShape(ButtonBorderShape.capsule)
					.frame(minWidth: 50, minHeight: 10)
					.buttonStyle(.borderedProminent)
					.tint(.green) // 강조색
			case .symbols:
				Button(action: action, label: content)
			}
		}
		
		// tab Button Init
		init(style: ButtonStyle,
			 action: @escaping () -> Void,
			 tabSelectionTag: Binding<String>? = nil,
			 tabMoveTo: String? = nil,
			 content: @escaping () -> ContentView) {
			
			self.style = style
			self.action = action
			self.content = content
			
			if let tabSelectionTag {
				self.tabSelectionTag = tabSelectionTag
			}
			
			if let tabMoveTo {
				self.tabMoveTo = tabMoveTo
			}
		}
		
		// normal Button Init
		init(
			style: ButtonStyle,
			action: @escaping () -> Void,
			content: @escaping () -> ContentView
		) {
			self.style = style
			self.action = action
			self.content = content
		}
		
		// tag Button Init
		init(
			style: ButtonStyle,
			tagSelection: Binding<Bool>,
			action: @escaping () -> Void,
			content: @escaping () -> ContentView
		) {
			self.style = style
			self.tagSelection = tagSelection
			self.action = action
			self.content = content
		}
	}
}

struct Test2: View {
	@State private var tabSelection = "Starred"
	
	@State private var starTab = "Starred"
	@State private var followTab = "Follow"
	
	var body: some View {
		VStack {
			Text(tabSelection)
			
			GSButton.ContentView(
				style: .tabPage,
				action: tabMoveTo,
				tabSelectionTag: $tabSelection,
				tabMoveTo: followTab
			) {
				Text(starTab)
			}
			
			GSButton.ContentView(
				style: .tabPage,
				action: tabMoveTo,
				tabSelectionTag: $tabSelection,
				tabMoveTo: starTab
			) {
				Text(followTab)
			}
			
			GSButton.ContentView(
				style: .primary,
				action: tabMoveTo
			) {
				Text("Knock")
			}
			
			GSButton.ContentView(
				style: .secondary,
				action: tabMoveTo
			) {
				Text(followTab)
			}
			
			GSButton.ContentView(
				style: .textConfirmation,
				action: tabMoveTo
			) {
				Text("Block @wontaeyoung")
			}
			
			GSButton.ContentView(
				style: .textCancelation,
				action: tabMoveTo
			) {
				Text("Delete Chat")
			}
			
			GSButton.ContentView(
				style: .tag,
				action: tabMoveTo
			) {
				Text("Tag")
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
		Text("?")
    }
}
