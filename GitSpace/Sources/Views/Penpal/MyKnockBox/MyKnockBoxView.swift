//
//  MyKnockBoxView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct MyKnockBoxView: View {
    
    @State private var knocks = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
                                 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
    
    @State private var userName = []
    @State private var knockMsg = []
    @State var searchWord: String = ""
    
    @State var isEdit: Bool = false
    @State var checked: Bool = false
    @State var showingKnockSetting: Bool = false
    
    var body: some View {
        
//        NavigationView {
            ScrollView {
                LazyVStack {
                    
                    VStack {
                        // 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
                        Text("Check the message for information about who's Knocking on you.")
                            .foregroundColor(Color(.systemGray))
                        
                        // 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
                        Text("They won't know you've seen it until you respond.")
                            .foregroundColor(Color(.systemGray))

                        
                        Button {
                            showingKnockSetting.toggle()
                        } label: {
                            // 나에게 노크 할 수 있는 사람 설정하기
                            Text("Decide who can Knock on you")
                        }
                        .padding(.top, -3)
                    }
                    .font(.caption2)
                    .padding(3)
                    
                    Divider()
                    
                    
                    // MARK: - Knock Cell
                    ForEach($knocks, id: \.self) { knock in
                        
                        MyKnockCell(knock: knock, isEdit: $isEdit, checked: $checked)
                        
                        Divider()
                        
//                        HStack(alignment: .center) {
//                            
//                            Image(systemName: "person.crop.circle.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 50, height: 50)
//                            
//                            VStack {
//                                HStack {
//                                    Text("유저 이름 \(knock + 1)")
//                                        .bold()
//                                        .font(.headline)
//                                    Spacer()
//                                } // HStack
//                                
//                                HStack {
//                                    Text("노크 메세지가 출력됩니다.")
//                                        .lineLimit(1)
//                                    
//                                    Text("﹒")
//                                        .padding(.leading, -5)
//                                    
//                                    Text("\(knock + 1)분 전")
//                                        .padding(.leading, -10)
//
//                                    Spacer()
//                                } // HStack
//                                .font(.subheadline)
//                                .foregroundColor(Color(.systemGray))
//                            } // VStack
//                            
//                        } // HStack
//                        .padding(.vertical, 5)
//                        .padding(.horizontal)
                        
                        
                    } // ForEach
                    .searchable(text: $searchWord, prompt: "Search UserName, Message Contents")
                } // LazyVStack
            } // ScrollView
            .navigationBarTitle("Knock Box", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEdit ? "Cancel" : "Edit") {
                        withAnimation(.easeIn(duration: 0.28)) {
                            isEdit.toggle()
                        }
                    }
                }
            }
//        } // NavigationView
        .fullScreenCover(isPresented: $showingKnockSetting) {
            MyKnockSettingView(showingKnockSetting: $showingKnockSetting)
        }
    } // body
} // MyKnockBoxView()

struct MyKnockBoxView_Previews: PreviewProvider {
    static var previews: some View {
        MyKnockBoxView()
    }
}
