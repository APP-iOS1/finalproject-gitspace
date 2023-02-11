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
        return Utility.loginUserID == message.senderID
    }
    
    var body: some View {
        
        switch isMine {
        case true:
            HStack(alignment: .bottom) {
                Spacer()
                Text(message.stringDate)
                    .modifier(MessageTimeModifier())
                Text(message.textContent)
                    .modifier(MessageModifier(isMine: self.isMine))
            }
            .padding(.trailing, 20)
            
        case false:
            
            
            HStack {
                // Profile Image 부분
                VStack {
                    NavigationLink {
                        ProfileDetailView()
                    } label: {
                        ProfileAsyncImage(size: 50)
                    }
                    Spacer()
                }
                
                // UserName과 Message Bubble 부분
                VStack (alignment: .leading) {
                    Text(targetName)
                    HStack(alignment: .bottom) {
                        Text(message.textContent)
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


// MARK: - 메세지 셀 말풍선 Custom Shape
struct ChatBubbleShape: Shape {
    
    enum Direction {
        case left
        case right
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        return (direction == .left) ? getLeftBubblePath(in: rect) : getRightBubblePath(in: rect)

    }
    
    func getLeftBubblePath(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.bottomRight, .bottomLeft, .topRight],
                                cornerRadii: CGSize(width: 20, height: 20)
        )
        
        return Path(path.cgPath)
    }
    
    func getRightBubblePath(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.bottomRight, .bottomLeft, .topLeft],
                                cornerRadii: CGSize(width: 20, height: 20)
        )
        
        return Path(path.cgPath)
                                                    
                                
    }
}

