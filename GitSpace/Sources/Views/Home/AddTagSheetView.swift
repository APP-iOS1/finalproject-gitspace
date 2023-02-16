//
//  AddTagSheetView.swift
//  GitSpace
//
//  Created by yeeunchoi, dahae on 2023/01/18.
//

import SwiftUI
import SwiftUIFlowLayout

enum BeforeView {
    case starredView
    case repositoryDetailView
}

struct AddTagSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var repositoryStore: RepositoryViewModel
    @EnvironmentObject var tagViewModel: TagViewModel
    @Binding var preSelectedTags: [Tag]
    @State var selectedTags: [Tag]
    @State private var tagInput: String = ""
    @StateObject private var keyboardHandler = KeyboardHandler()
    /// 어떤 뷰에서 AddTagSheetView를 호출했는지 확인합니다.
    var beforeView: BeforeView
    let repositoryName: String?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var trimmedTagInput: String {
        tagInput.trimmingCharacters(in: .whitespaces)
    }
    
    var shouldBlankTag: Bool {
        trimmedTagInput != ""
    }
    
    var shouldExistTag: Bool {
        /// tagList에 이미 존재하는 이름의 태그가 있다면 필터에서 걸리게 된다.
        /// 그러므로 배열에 값이 존재하므로, isEmpty값이 true가 되고 Tag가 존재함을 알 수 있다.
        return tagViewModel.tags.filter { tag in
            tag.tagName == trimmedTagInput
        }.isEmpty
    }
    
    func addNewTag() {
        if shouldBlankTag && shouldExistTag {
            Task {
                await tagViewModel.registerTag(tagName: trimmedTagInput)
                withAnimation {
                    tagViewModel.tags.append( Tag(tagName: trimmedTagInput, repositories: []) )
                }
            }
        }
        
    }
    
    func selectTag(to tag: Tag) {
        if selectedTags.contains(tag) {
            let selectedIndex: Int = selectedTags.firstIndex(of: tag)!
            selectedTags.remove(at: selectedIndex)
        } else {
            selectedTags.append(tag)
        }
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
//                                withAnimation {
                                    addNewTag()
//                                }
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
                        if tagViewModel.tags.isEmpty {
                            VStack(spacing: 10) {
                                Image("GitSpace-Tag-Empty")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300, height: 300)
                                
                                Text("There is no tag!")
                                    .font(.title)
                                    .foregroundColor(.gsGray2)
                                    .multilineTextAlignment(.center)
                            }
                        } else {
                            Text(beforeView == .starredView ? "Select tags from your tag list 🙌" : "Select tags from your repository tag list 🙌" )
                                .foregroundColor(Color(.systemGray))
                                .font(.callout)
                            /* selectedTag에 있는 태그만 미리 선택된 채로 있어야 한다. */
                            FlowLayout(mode: .scrollable, items: Array(zip(tagViewModel.tags.indices.reversed(), tagViewModel.tags.reversed()))) { index, tag in
                                GSButton.CustomButtonView(
                                    style: .tag(
                                        isSelected: selectedTags.contains(tag),
                                        isEditing: false
                                    )
                                ) {
                                    withAnimation {
                                        selectTag(to: tag)
                                    }
                                } label: {
                                    Text("\(tag.tagName)")
                                        .font(.callout)
                                }
                                .tag("\(tag.tagName)")
                                .contextMenu {
                                    Button {
                                        print("삭제")
                                        Task {
                                            await tagViewModel.deleteTag(tag: tag)
                                            tagViewModel.tags.remove(at: index)
                                        }
                                    } label: {
                                        Label("태그 삭제하기", systemImage: "trash")
                                    }
                                }
                                .transition(.opacity.combined(with: .move(edge: .leading)))
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
                            switch beforeView {
                            case .repositoryDetailView:
                                Task {
                                    // FIXME: 실제 레포 이름 가져오기
                                    guard let repositoryName = repositoryName else { return }
                                    await tagViewModel.addRepositoryTag(preSelectedTags, repositoryFullname: repositoryName)
                                }
                            case .starredView:
                                print("---")
                            }
                            dismiss()
                        } label: {
                            Text("Done")
                        }
                    }
                }
                .padding(.horizontal, 30)
            }
            .onTapGesture {
                self.endTextEditing()
            }
            .onAppear {
                Task {
                    await tagViewModel.requestTags()
                }
            }
        }
    }
}

struct AddTagSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddTagSheetView(preSelectedTags: .constant( [Tag(tagName: "MVVM", repositories: [])] ), selectedTags: [], beforeView: .starredView, repositoryName: "")
                .environmentObject(RepositoryViewModel())
                .environmentObject(TagViewModel())
        }
    }
}
