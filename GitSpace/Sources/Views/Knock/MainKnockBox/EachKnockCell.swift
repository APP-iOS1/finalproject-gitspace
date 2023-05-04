//
//  MyKnockCell.swift
//  GitSpace
//
//  Created by 최한호 on 2023/01/18.
//

import SwiftUI

struct EachKnockCell: View {
    @EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var userInfoManager: UserStore
    @Binding var eachKnock: Knock
    @Binding var isEditing: Bool
    @State private var targetUserInfo: UserInfo? = nil
    @State private var isChecked: Bool = false
    @State private var opacity: CGFloat = 0.4
    @State private var asyncFetchedUserInfo: UserInfo?
    
    // MARK: Binding하면 상위 state에 의해 이름 잔상 애니메이션이 남는다.
    @State var userSelectedTab: String
    
    // MARK: - body
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                if isEditing {
                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(isChecked ? Color(UIColor.systemBlue) : Color.secondary)
                        .onTapGesture {
                            self.isChecked.toggle()
                        }
                }
                
                ZStack {
                    //ZStack에서 애니메이션 처리를 할 때 zIndex 지정해주지 않으면 애니메이션 에러가 발생할 수 있음.
                    Color.white
                        .zIndex(0)
                        .clipShape(Circle())
                    
                    //아래 있는 코드의 뷰가 더 상위에 떠야하므로 zIndex 1
                    Circle()
                        .fill(.gray)
                        .opacity(opacity)
                        .zIndex(1)
                }
                .frame(width: 50)
                .overlay {
                    if
                        let targetUserInfo,
                        targetUserInfo.id != "FAILED" {
                        GithubProfileImage(
                            urlStr: targetUserInfo.avatar_url,
                            size: 50
                        )
                    } else if
                        let targetUserInfo,
                        targetUserInfo.id == "FAILED" {
                        DefaultProfileImage(size: 50)
                    }
                }
                
                VStack {
                    HStack {
                        if userSelectedTab == Constant.KNOCK_RECEIVED {
                            Text("from: **\(eachKnock.sentUserName)**")
                                .font(.body)
                        } else {
                            Text("to: **\(eachKnock.receivedUserName)**")
                                .font(.body)
                        }
                        
                        Spacer()
                        
                        Text("\(eachKnock.knockedDate.dateValue().timeAgoDisplay())")
                            .font(.subheadline)
                            .foregroundColor(Color(.systemGray))
                            .padding(.leading, -10)
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color(.systemGray))
                        
                    } // HStack
                    .id(eachKnock.id)
                    
                    HStack {
                        Text(eachKnock.knockMessage)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        if eachKnock.knockStatus == Constant.KNOCK_WAITING {
                            Text(eachKnock.knockStatus)
                                .foregroundColor(Color("GSPurple"))
                        } else if eachKnock.knockStatus == Constant.KNOCK_ACCEPTED {
                            Text(eachKnock.knockStatus)
                                .foregroundColor(Color.accentColor)
                        } else {
                            Text("\(eachKnock.knockStatus)")
                                .foregroundColor(Color("GSRed"))
                        }
                    } // HStack
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
                    .id(eachKnock.id)
                    
                } // VStack
                .id(eachKnock.id)
                
            } // HStack
            .padding(.vertical, 5)
            .padding(.horizontal)
            
            Divider()
                .padding(.horizontal, 20)
        }
        .task {
            withAnimation(
                targetUserInfo != nil
                ? .linear
                : .linear(duration: 0.5).repeatForever(autoreverses: true)
            ) {
                self.opacity = opacity == 0.4 ? 0.8 : 0.4
            }
            
            await requestUserInfoWithID()
            assignUserInfoWithAnimation()
        }
    }
    
    /**
     UserInfo를 request 합니다.
     request의 결과를 asyncFetchedUserInfo에 임시 보관합니다.
     */
    private func requestUserInfoWithID() async -> Void {
        // 노크 수신자 == 현재 유저일 경우, 노크 발신자의 정보를 타겟유저로 할당
        if eachKnock.receivedUserID == userInfoManager.currentUser?.id {
            self.asyncFetchedUserInfo = await userInfoManager.requestUserInfoWithID(userID: eachKnock.sentUserID)
        } else if eachKnock.receivedUserID != userInfoManager.currentUser?.id {
            self.asyncFetchedUserInfo = await userInfoManager.requestUserInfoWithID(userID: eachKnock.receivedUserID)
        }
    }
    
    /**
     asyncFetchedUserInfo를 애니메이션과 함께 targetUserInfo에 할당합니다.
     */
    private func assignUserInfoWithAnimation() {
        if
            let asyncFetchedUserInfo {
            withAnimation {
                self.targetUserInfo = asyncFetchedUserInfo
            }
        }
    }
}
