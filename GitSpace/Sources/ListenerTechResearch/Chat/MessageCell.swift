//
//  MessageCell.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

// MARK: -View : 채팅 메세지 셀
struct MessageCell : View {
    let message : Message
    var isMine : Bool {
        return Utility.loginUserID == message.userID
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            switch isMine {
            case true:
                Spacer()
                Text(message.stringDate)
                    .modifier(MessageTimeModifier())
                Text(message.content)
                    .modifier(MessageModifier(isMine: self.isMine))
            case false:
                Text(message.content)
                    .modifier(MessageModifier(isMine: self.isMine))
                Text(message.stringDate)
                    .modifier(MessageTimeModifier())
                Spacer()
            }
        }
        .padding(isMine ? .trailing : .leading, 20)
    }
}

// MARK: -Modifier : 채팅 메세지 셀 속성
struct MessageModifier : ViewModifier {
    let isMine : Bool
    func body(content: Content) -> some View {
        content
            .padding()
            .padding(.vertical,-8)
            .foregroundColor(isMine ? .white : .black)
            .background(isMine ? .orange : .gray)
            .cornerRadius(22)
        
        
    }
}

// MARK: -Modifier : 채팅 메세지 보낸 시간 속성
struct MessageTimeModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .foregroundColor(.secondary)
    }
}

