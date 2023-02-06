//
//  ChatModifiers.swift
//  GitSpace
//
//  Created by 원태영 on 2023/02/01.
//

import SwiftUI

// MARK: Modifier : 채팅 메세지 셀 속성
struct MessageModifier: ViewModifier {
    let isMine: Bool
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16))
//            .frame(maxWidth: Utility.MessageCellWidth)
            .padding(15)
            .background(
                LinearGradient(colors: [.gsYellowPrimary, .gsGreenPrimary], startPoint: .top, endPoint: .center)
            )
            .clipShape(ChatBubbleShape(direction: isMine ? .right : .left))

        
        // 기존 모디파이어 코드:
//            .background(isMine ? Color.gsGreenPrimary : Color(uiColor: .systemGray4))
//            .cornerRadius(17)
//            .overlay(alignment: isMine ? .topTrailing : .topLeading) {
//                Image(systemName: isMine ? "arrowtriangle.forward.fill" : "arrowtriangle.backward.fill")
//                    .foregroundColor(isMine ? .gsGreenPrimary : Color(uiColor: .systemGray4))
//                    .offset(x: isMine ? 12 : -12, y: 10)
//            }
    }
}


// MARK: Modifier : 채팅 메세지 보낸 시간 속성
struct MessageTimeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption2)
            .foregroundColor(.secondary)
    }
}

// MARK: Modifier : 노크 메세지 셀 속성
struct KnockMessageModifier: ViewModifier {
    func body(content: Content) -> some View {
            content
                .font(.system(size: 12))
                .padding(20)
                .frame(minWidth: Utility.UIWidth - 40)
                .border(.gray.opacity(0.1))
                .shadow(radius: 10)
                .cornerRadius(17)
    }
}

    
