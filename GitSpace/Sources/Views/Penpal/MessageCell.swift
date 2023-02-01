//
//  MessageCell.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import SwiftUI

// MARK: -View : 채팅 메세지 셀
struct MessageCell : View {
    let message: Message
    let targetName: String
    var isMine: Bool {
        return Utility.loginUserID == message.userID
    }
    
    var body: some View {
        
        switch isMine {
        case true:
            HStack(alignment: .bottom) {
                Spacer()
                Text(message.stringDate)
                    .modifier(MessageTimeModifier())
                Text(message.content)
                    .modifier(MessageModifier(isMine: self.isMine))
            }
            .padding(.trailing, 20)
            
        case false:
            
            
            HStack {
                
                VStack {
                    ProfileAsyncImage(size: 50)
                    Spacer()
                }
                
                VStack (alignment: .leading) {
                    Text(targetName)
                    HStack(alignment: .bottom) {
                        Text(message.content)
                            .modifier(MessageModifier(isMine: self.isMine))
                        Text(message.stringDate)
                            .modifier(MessageTimeModifier())
                        Spacer()
                    }
                }
            }
        }
        
    }
}



