//
//  AddTagSheetView.swift
//  GitSpace
//
//  Created by yeeunchoi on 2023/01/18.
//

import SwiftUI

struct AddTagSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var repositoryStore: RepositoryStore
    @Binding var preSelectedTags: [Tag]
    @State var selectedTags: [Tag]
    @State private var tagInput: String = ""
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    func doesExistTag(_ inputTagName: String) -> Bool {
        for tag in repositoryStore.tagList {
            if tag.name == inputTagName {
                return false
            }
        }
        return true
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Spacer()
                        .frame(height: 30)
                    
                    // MARK: - 새 태그 추가 섹션
                    // 새 태그 추가 안내문
                    Group {
                        Text("Add if you want new tags 💬")
                            .foregroundColor(Color(.systemGray))
                            .font(.callout)
                        
                        HStack {
                            TextField("tag name", text: $tagInput)
                                .textFieldStyle(.roundedBorder)
                            
                            // 태그 추가 버튼
                            Button {
                                // FIXME: Animation이 너무 못생겼음.
                                /// 앞에서 추가되면 자연스럽게 밀리는 애니메이션으로 수정하기.
                                withAnimation {
                                    if tagInput.trimmingCharacters(in: .whitespaces) != "" {
                                        if doesExistTag(tagInput) {
                                            repositoryStore.tagList.append( Tag(name: tagInput) )
                                        }
                                    }
                                }
                            } label: {
                                Image(systemName: "plus")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .padding(5)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    
                    // MARK: - 태그 선택 섹션
                    // 기존 태그 선택 안내문
                    Group {
                        Text("Select tags from your tag list 🙌")
                            .foregroundColor(Color(.systemGray))
                            .font(.callout)
                        
                        HStack {
                            LazyVGrid(columns: columns) {
                                /* selectedTag에 있는 태그만 미리 선택된 채로 있어야 한다. */
                                ForEach(Array(zip(repositoryStore.tagList.indices, repositoryStore.tagList.reversed())), id: \.0) { index, tag in
                                    GSButton.CustomButtonView(
                                        style: .tag(
                                            isSelected: selectedTags.contains(tag),
                                            isEditing: false
                                        )
                                    ) {
                                        if selectedTags.contains(tag) {
                                            let selectedIndex: Int = selectedTags.firstIndex(of: tag)!
                                            selectedTags.remove(at: selectedIndex)
                                        } else {
                                            selectedTags.append(tag)
                                        }
                                    } label: {
                                        Text("\(tag.name)")
                                            .font(.callout)
                                    }
                                    .tag("\(tag.name)")
                                }
                            }
                        }
                        Spacer()
                    }
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
                            /*
                             모달을 내리기 전에
                             사용자가 선택한 태그들(selectedTags)를
                             preSelectedTag에 추가한다.
                             */
                            preSelectedTags = selectedTags
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
}

struct AddTagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddTagSheetView(preSelectedTags: .constant( [Tag(name: "MVVM")] ), selectedTags: [])
                .environmentObject(RepositoryStore())
        }
    }
}
