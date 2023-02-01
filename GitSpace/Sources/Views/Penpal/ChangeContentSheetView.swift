//
//  ChangeContentSheetView.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/01.
//

import SwiftUI

// MARK: -View : 메세지 수정 Sheet
struct ChangeContentSheetView : View {
    @Binding var isShowingUpdateCell : Bool
    @State var changeContentField : String = ""
    @EnvironmentObject var messageStore : MessageStore
    let chatID : String
    let message : Message
    
    var body: some View {
        VStack(spacing : 50) {
            
            TextField(message.content, text: $changeContentField)
                .textFieldStyle(.roundedBorder)
            
            Button {
                messageStore.updateMessage(message, chatID: chatID)
                isShowingUpdateCell = false
            } label: {
                Text("수정하기")
                Image(systemName: "pencil")
            }
            
        }
        .padding(.horizontal, 20)
        .onAppear {
            changeContentField = message.content
        }
    }
}
