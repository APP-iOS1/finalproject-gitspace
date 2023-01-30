//
//  GSTextField.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/20.
//

import SwiftUI

struct GSInputField {
	enum InputFieldStyle {
		case secureField
		case textField
		case textEditor
	}
	
	struct ContentView<ContentView: View>: View {
		private(set) var style: InputFieldStyle
		private(set) var primaryInputFieldTitle: String?
		private(set) var text: Binding<String>
		private(set) var content: () -> ContentView
		@State private(set) var isVisible: Bool = false
		
		var body: some View {
			
			VStack(alignment: .leading) {
				if let primaryInputFieldTitle {
					Text(primaryInputFieldTitle)
						.bold()
						.padding(.leading, 15)
				}
				
				content()
					.autocorrectionDisabled()
					.textInputAutocapitalization(.never)
					.padding(.horizontal, 15)
					.overlay {
						Divider()
							.background(Color.accentColor)
							.offset(x: 0, y: 15)
							.padding(.horizontal, 15)
					}
					.overlay {
						switch style {
						case .secureField:
							HStack {
								Spacer()
								
								Button {
									self.isVisible.toggle()
								} label: {
									Image(systemName: isVisible ? "eye.slash" : "eye")
								}
							}
							.padding(.horizontal, 15)
						default:
							EmptyView()
						}
					}
			}
			
		}
	}
	
	// 바깥에서 호출해서 사용하는 인풋필드 메소드
	public static func customInputField(
		style: InputFieldStyle,
		primaryInputFieldTitle: String?,
		text: Binding<String>,
		@ViewBuilder content: @escaping () -> some View
	) -> some View {
		GSInputField.ContentView(
			style: style,
			primaryInputFieldTitle: primaryInputFieldTitle,
			text: text,
			content: content)
	}
}

struct Test: View {
	@State private var email = ""
	@State private var password = ""
	
	var body: some View {
		VStack {
			GSInputField.customInputField(
				style: .textField,
				primaryInputFieldTitle: "Email",
				text: $email
			) {
				TextField("ID", text: $email)
			}
			.padding(.vertical, 30)
			
			GSInputField.customInputField(
				style: .secureField,
				primaryInputFieldTitle: "Password",
				text: $password,
				content: viewBuilder)
		}
	}
	
	// Your ViewBuilder
	private func viewBuilder() -> some View {
		SecureField("Password", text: $password)
	}
}

struct Test_: PreviewProvider {
	@State static var text = "112"
	
	static var previews: some View {
		Test()
	}
}
