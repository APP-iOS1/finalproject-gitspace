//
//  SendKnockModal.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/18.
//

import SwiftUI

struct SendKnockModal: View {
	@State private var knockMessages: KnockMessages = .offer()
	@State private var usersKnockMessages: String = ""
	@FocusState private var textEditingState: TextEditorFocusState?
	@Binding var isKnockModalDisplayed: Bool
	
	var body: some View {
		VStack {
//			Spacer()
//				.frame(maxHeight: 200)
//
//			Text("Select Knock Message")
//				.bold()
//				.font(.title3)
            //좋은 노크 메시지는 답장 확률을 높여줍니다!
            Text("Good Knock, Quick Response!")
                .font(.footnote)
                .foregroundColor(Color(.systemGray))
                .padding(.vertical, -5)
                .offset(y: -5)
			
			
			Divider()
            
            ContributorListView()
                .frame(height: 335)
                .offset(y: -30)
			
			VStack(alignment: .center) {
				
				Group {
                    // ${UserName} 님에게
                    // \n 노크 메시지를 보냅니다.
                    Text("Send a Knock message to\n ") +
					Text("${UserName} ")
						.bold()
				}
                .multilineTextAlignment(.center)
                .padding(.top, -35)
                .padding(.bottom, 3)

                ///상대방은 노크 메시지를 받고 응답을 거절할 권리가 있으며,
                ///거절 의사와 노크 메시지를 주고 받은 히스토리는
                ///KnockBox에서 확인할 수 있습니다.
				Text("""
They have the right to receive knock messages and refuse to respond. You can check the history of sending and receiving knock messages with your refusal intention on KnockBox.
""")
				.font(.footnote)
				.multilineTextAlignment(.center)
				.foregroundColor(Color(.systemGray))
				.padding(.horizontal, 10)
			}
			.font(.body)
			
			
			Divider()
			
			Picker("", selection: $knockMessages) {
				ForEach(KnockMessages.allCases, id: \.id) { cases in
					switch cases {
					case .customoffer(let key, _):
						Text(key!)
					case .offer(let key, _):
						Text(key!)
					case .questionoffer(let key, _):
						Text(key!)
					}
				}
			}
			
			switch knockMessages {
			case .offer(_, let example),
					.questionoffer(_, let example):
				Text("Send Knock Message with this:")
					.font(.callout)
					.padding(.bottom, 10)
				
				Text(example!)
					.bold()
					.multilineTextAlignment(.center)
			case .customoffer( _, _):
				HStack {
					HStack {
						TextEditor(text: $usersKnockMessages)
							.autocorrectionDisabled()
							.textInputAutocapitalization(.never)
							.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 150)
							.focused($textEditingState, equals: .textEditor)
							.onAppear {
								textEditingState = .textEditor
							}
						
						Spacer()
						
						Button {
							usersKnockMessages.removeAll()
						} label: {
							Image(systemName: "xmark")
						}
						.frame(minWidth: 30, minHeight: 30)
					}
					
					Spacer()
					
					Image(systemName: "pencil")
						.frame(minWidth: 30, minHeight: 30)
				}
				.padding(.horizontal, 20)
			}
			
//			VStack {
//				// 멀티셀렉팅 가능하게 하고 여러 사람에게 노크 보내기
//				Text("이 레포의 기여자 중 누구에게 노크메시지를 보낼까요~")
//
//				Text("덕배")
//				Text("춘만이")
//				Text("꽃순이")
//			}
//			ContributorListView()
            Spacer()
		}
        .navigationBarTitle("Knock Message", displayMode: .inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					isKnockModalDisplayed.toggle()
				} label: {
					Text("Cancel")
				}
			}
			
			ToolbarItem {
				Button {
					switch knockMessages {
					case .offer(_, let example),
							.questionoffer(_, let example):
						usersKnockMessages = example ?? ""
					case .customoffer(_, _):
						break
					}
					
					isKnockModalDisplayed.toggle()
					print("SEND MESSAGE : ", usersKnockMessages)
				} label: {
					Text("Send")
				}
//				.disabled(usersKnockMessages.isEmpty ? true : false)
			}
		}
	}
}

enum KnockMessages: CaseIterable, Hashable {
	static var allCases: [KnockMessages] = [
		.offer(key: "Offer ",
			   example: "I would like to offer you a job."),
		.questionoffer(key: "Question",
					   example: "I have questions about your tasks in this Repository"),
		.customoffer(key: "Write by Myself",
					 example: "I'd like to write my own Knock Message."),
	]
	
	var id: Self { return self }
	
	case offer(
		key: String? = "Offer ",
		example: String? = "I would like to offer you a job."
	)
	case questionoffer(
		key: String? = "Question",
		example: String? = "I have questions about your tasks in this Repository"
	)
	case customoffer(
		key: String? = "Write by Myself",
		example: String? = "I'd like to write my own Knock Message."
	)
}

enum TextEditorFocusState {
	case textEditor
}

struct SendKnockModal_Previews: PreviewProvider {
	static var previews: some View {
		SendKnockModal(isKnockModalDisplayed: .constant(true))
	}
}
