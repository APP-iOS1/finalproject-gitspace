//
//  GSButton.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/20.
//

import SwiftUI

public struct GSButton {
	
	/**
	 각 버튼의 케이스에 따라 기본 레이아웃을 구성합니다.
	 - Important: 각 케이스는 연관 값을 갖고 있으며 `hometab` 케이스의 경우, 그 연관값을 **필수**로 입력해야 합니다.
	 `primary`와 `secondary` 케이스의 연관값은 필수가 아니며, 연관값을 할당하면 GSButton의 label 을 **비운 채로** UI를 그릴 수 있습니다.
	*/
	public enum GSButtonStyle {
		case primary(isDisabled: Bool)
		case secondary(isDisabled: Bool)
		case tag(isEditing: Bool,
				 isSelected: Bool = false)
		case plainText(isDestructive: Bool)
		case homeTab(tabName: String,
					 tabSelection: Binding<String>)
	}
	
	struct CustomButtonView<CustomLabelType: View>: View {
		public let style: GSButtonStyle
		public let action: () -> Void
		public var label: CustomLabelType?
		
		var body: some View {
			switch style {
				
			// MARK: DONE
			case .primary(let isDisabled):
				Button(action: action) {
					label
						.buttonLabelLayoutModifier(
							buttonLabelStyle: .primary(
								isDisabled: isDisabled
							)
						)
				}
				.buttonColorSchemeModifier(style: style)
			
			// MARK: - DONE
			case .secondary(let isDisabled):
				Button(action: action) {
					label
						.buttonLabelLayoutModifier(
							buttonLabelStyle: .secondary(
								isDisabled: isDisabled
							)
						)
				}
				.buttonColorSchemeModifier(style: style)
				
			case .tag(let isEditing, let isSelected):
				Button(action: action) {
					label
						.buttonLabelLayoutModifier(
							buttonLabelStyle: .tag(
								isEditing: isEditing,
								isSelected: isSelected
							)
						)
				}
				.buttonColorSchemeModifier(style: style)
				
			// MARK: - DONE
			case .plainText(let isDestructive):
				Button(action: action) {
					label
						.buttonLabelLayoutModifier(
							buttonLabelStyle: .plainText(
								isDestructive: isDestructive
							)
						)
				}
				.buttonColorSchemeModifier(style: style)
		
			// MARK: - DONE
			case .homeTab(let tabName, let tabSelection):
				Button(action: action) {
					label
						.overlay(alignment: .bottom) {
							if tabName == tabSelection.wrappedValue {
								Divider()
									.frame(minHeight: 2)
									.overlay(Color.primary)
									.offset(y: 3)
							}
						}
				}
			}
		}
		
		// Simple Initializer
		init(style: GSButtonStyle,
			 action: @escaping () -> Void,
			 @ViewBuilder label: () -> CustomLabelType) {
			self.style = style
			self.action = action
			self.label = label()
		}
	}
}

struct Test2: View {
	private let starTab = "Starred"
	private let followTab = "Following"
	@State private var isDisabled = false
	@State private var isEditing = false
	@State private var isSelected = false
	
	@State private var selectedHomeTab = "Starred"
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		VStack {
			GSButton.CustomButtonView(
				style: .primary(
					isDisabled: true
				)
			) {
				withAnimation {
					isDisabled.toggle()
				}
			} label: {
				HStack {
					Text("✨")
					
					Text("HiHI")
				}
			}
			
			GSButton.CustomButtonView(
				style: .tag(
					isEditing: isEditing,
					isSelected: isSelected
				)
			) {
				withAnimation {
					isSelected.toggle()
				}
			} label: {
				Text("?")
					.font(.callout)
					.bold()
			}
			.tag("HI")
			
			HStack {
				GSButton.CustomButtonView(
					style: .homeTab(
						tabName: starTab,
						tabSelection: $selectedHomeTab
					)
				) {
					withAnimation {
						selectedHomeTab = starTab
					}
				} label: {
					Text(starTab)
						.font(.title3)
						.foregroundColor(.primary)
						.bold()
				}
				.tag(starTab)
				
				GSButton.CustomButtonView(
					style: .homeTab(
						tabName: followTab,
						tabSelection: $selectedHomeTab
					)
				) {
					withAnimation {
						selectedHomeTab = followTab
					}
				} label: {
					Text(followTab)
						.font(.title3)
						.foregroundColor(.primary)
						.bold()
				}
				.tag(followTab)
				
				Spacer()
			}
			.overlay(alignment: .bottom) {
				Divider()
					.frame(minHeight: 0.5)
					.overlay(Color.primary)
					.offset(y: 3.5)
			}
			.padding(16)
			
			GSButton.CustomButtonView(
				style: .plainText(
					isDestructive: false
				)
			) {
				print()
			} label: {
				Text("??")
			}
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
