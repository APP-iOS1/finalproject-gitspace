//
//  AddTagSheetView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/18.
//

import SwiftUI

class TagSample: ObservableObject {
    @Published var tags: [String] = ["thisis", "my", "tag", "hehe"]
    @Published var tagSelections: [Bool] = [false, false, false, false]
}

struct AddTagSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var tagSample: TagSample = TagSample()
    @State private var tagInput: String = ""
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Spacer()
                    .frame(height: 30)
                
                // MARK: - 새 태그 추가 섹션
                // 새 태그 추가 안내문
                Text("Add if you want new tags 💬")
                    .foregroundColor(Color(.systemGray))
                    .font(.callout)
                
                HStack {
                    TextField("tag name", text: $tagInput)
                        .textFieldStyle(.roundedBorder)
                    
                    // 태그 추가 버튼
                    Button {
                        if tagInput.trimmingCharacters(in: .whitespaces) != "" {
                            tagSample.tags.append(tagInput)
                            tagSample.tagSelections.append(false)
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(5)
                    }
                }
                .padding(.bottom, 30)
                
                
                // MARK: - 태그 선택 섹션
                // 기존 태그 선택 안내문
                Text("Select tags from your tag list 🙌")
                    .foregroundColor(Color(.systemGray))
                    .font(.callout)
                
                HStack {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<tagSample.tags.count, id: \.self) { index in
                            Button {
                                tagSample.tagSelections[index].toggle()
                            } label: {
                                Text(tagSample.tags[index])
                                    .frame(width: 50)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 13)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.black)
                                    )
                                    .font(.callout)
                                    .foregroundColor(tagSample.tagSelections[index] ? .white : .black)
                                    .background(tagSample.tagSelections[index] ? .black : .clear)
                                    .cornerRadius(20)
                                
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle("Knock Knock!", displayMode: .inline)
            .toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button {
						dismiss()
					} label: {
						Text("Cancel")
					}
				}
				
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        .padding(.horizontal, 30)
        }
    }
}

struct AddTagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddTagSheetView()
        }
    }
}
