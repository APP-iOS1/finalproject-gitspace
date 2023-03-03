//
//  ViewDidLoadModifier.swift
//  GitSpace
//
//  Created by Da Hae Lee on 2023/02/27.
//

import SwiftUI

// MARK: ViewDidLoad 수정자
/// 뷰가 한번 로드되었을 때를 감지하여 액션을 수행하게 하는 ViewDidLoad 수정자이다.
struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad: Bool = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}
