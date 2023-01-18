//
//  ChatDetailView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/17.
//

import SwiftUI

struct Message : Identifiable {
    let id = UUID().uuidString
    let isRead : Bool
    let time : String
}

struct ChatDetailView: View {
    
    @State private var messageField : String = ""
    @State private var messages : [Message] = [
        Message(isRead: true, time: "17:54"),
        Message(isRead: false, time: "18:01")
    ]
    @State private var showingSheet : Bool = false
    @State private var updateMessageField : String = "This is the original message."
    
    //TODO: -Navigation Toolbar 추가
    var body: some View {
        VStack {
            
            ScrollView(showsIndicators: false) {
                Section {
                    Divider()
					NavigationLink(destination: ProfileDetailView()) {
						VStack {
							AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/45925685?v=4")) { image in
								image
									.resizable()
									.aspectRatio(contentMode: .fit)
									.clipShape(Circle())
									.frame(width : 100)
							} placeholder: {
                                // 불러오는 중입니다...
								Text("Loading...")
							}
							.padding(.vertical, 10)
							.padding(.top, 10)
							
							Text("Taeyoung Won")
								.bold()
								.padding(.vertical, 20)
						}
					}
                    
                    
                    Text("wontaeyoung, starred 3 repos,")
                    Text("Airbnb-swift Repository Owner")
                }
                
                
                Section {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 5)
                        .foregroundColor(Color(.systemGray5))
                        .padding(.vertical, 15)
                    
                    Text("Today")
                        .bold()
                        .foregroundColor(Color(uiColor: .systemGray3))
                        .padding(.bottom, 15)
                        
                    
                    HStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 250, height: 80)
                            .foregroundColor(Color(uiColor: .systemGray3))
                        Text("17:53")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        Spacer()
                        
                    }
                    .padding(.bottom, 20)
                    
                    ForEach(messages) { cell in
                        MessageCell(id: cell.id,
                                    isRead: cell.isRead,
                                    time: cell.time,
                                    messages: $messages,
                                    showingSheet: $showingSheet)
                    }
                    
                }
            }
            .padding(.bottom, 1)
            
            RoundedRectangle(cornerRadius: 25)
                .frame(width: UIScreen.main.bounds.width - 40, height: 50)
                .foregroundColor(Color(uiColor: .systemGray5))
                .overlay {
                    HStack {
                        Button {} label: {
                            Image(systemName: "photo")
                        }
                        
                        Button {} label: {
                            Text("</>")
                        }
                        
                        TextField("Message...", text: $messageField)
							.autocorrectionDisabled()
							.textInputAutocapitalization(.never)
                        
                        Button {
                            messages.append(Message(isRead: false, time: getStringDate()))
                            messageField = ""
                        } label: {
                            Image(systemName: messageField.isEmpty ? "arrowtriangle.right" : "arrowtriangle.right.fill")
                        }
                        .disabled(messageField.isEmpty)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 20)
            
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
				HStack(spacing: 10) {
					AsyncImage(url: URL(string: "https://avatars.githubusercontent.com/u/45925685?v=4")) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fit)
							.clipShape(Circle())
							.frame(width:30)
					} placeholder: {
						ProgressView()
					}
					Text("Taeyoung Won")
						.bold()
//						.padding(.horizontal, -8)
				}
                
            }
            
            ToolbarItem(placement : .navigationBarTrailing) {
                NavigationLink {
                    PenpalInfoView()
                        .navigationTitle("Messages Details")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .foregroundColor(.primary)
        .sheet(isPresented: $showingSheet, content: {
            
            // 수정할 메세지를 입력해주세요.
            TextField("Please enter a message to edit.", text: $updateMessageField)
                .padding(.horizontal, 30)
                .textFieldStyle(.roundedBorder)
            
            Button {
                showingSheet.toggle()
            } label: {
                Text("Save")
                    .padding()
                    .border(.black, width: 2)
            }
        })
        .padding(.horizontal, 20)
    }
    private func getStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "HH:mm"
        let dateAt = Date()
        return dateFormatter.string(from: dateAt)
    }
}

// MARK: -View : 채팅 메세지 Cell
struct MessageCell : View {
    
    let id : String
    let isRead : Bool
    let time : String
    @State var showingAlert : Bool = false
    @Binding var messages : [Message]
    @Binding var showingSheet : Bool
    
    var body : some View {
        HStack(alignment: .bottom, spacing: 5) {
            Spacer()
            VStack(alignment: .trailing) {
                Text(isRead ? "Seen" : "")
                Text(time)
                
            }
            .font(.caption2)
            .foregroundColor(.gray)
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 250, height: 80)
                .foregroundColor(.yellow)
                .contextMenu{
                    Button {showingSheet.toggle()} label: {
                        Text("Edit")
                    }
                    Button {showingAlert.toggle()} label: {
                        Text("Delete")
                    }
                }
        }
        .padding(.bottom, 20)
        .alert("Delete Message", isPresented: $showingAlert) {
            Button("Delete", role: .destructive) {
                if let removeIndex = messages.firstIndex(where: {$0.id == self.id}) {
                    messages.remove(at: removeIndex)
                }
            }
        } message: {
            // 메세지를 삭제하면 상대방과 나 모두 이 메세지를 볼 수 없습니다. 삭제하시겠습니까?
            Text("The other person and you can't see this message. Are you sure?")
        }
        
        
    }
}

struct ChatDetailView_Previews: PreviewProvider {
    static var previews: some View {
//		NavigationView {
			ChatDetailView()
//		}
    }
}
