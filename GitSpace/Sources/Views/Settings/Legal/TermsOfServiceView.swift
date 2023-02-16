//
//  TermsOfServiceView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/16.
//

import SwiftUI
import WebKit

struct TermsOfServiceView: UIViewRepresentable {
    
    var urlToLoad: String
    //uiview 만들기
    func makeUIView(context: Context) -> WKWebView {
        //언래핑
        guard let url = URL(string: urlToLoad) else{
            return WKWebView()
        }
        //웹뷰 인스턴스 생성
        let webview = WKWebView()
        //웹뷰 로드
        webview.load(URLRequest(url: url))
        
        return webview
    }
    
    //uiview 업데이트
    //context는 uiviewrepresentablecontext로 감싸야 함.
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<TermsOfServiceView>) {
        
    }
}

struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServiceView(urlToLoad: "https://industrious-expansion-4bf.notion.site/1fe25eb31ca541f8b82a97f87bce81c0")
    }
}
