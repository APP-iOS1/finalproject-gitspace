# 기술검증
## GitHub Markdown API

- 링크: [바로가기](https://docs.github.com/ko/rest/markdown?apiVersion=2022-11-28)
- markdown 문서를 HTML 페이지 혹은 raw text로 제공

## 기존 GitStar에서 markdown을 받아오던 방법

1. 깃허브 레포지토리 컨텐츠 API를 사용하면 레포지토리의 정보에 접근할 수 있고, 키값중에 download_url가 존재한다.
2. download_url(raw.githubusercontent.com~)에 접속해보면 해당 url에서 raw content의 형태로 파일의 정보를 볼 수 있다.
3. 이러한 markdown data를 `URLSession`을 이용하여 raw content markdown을 Swift의 Data 타입으로 받아온다.
4. 받아온 데이터를 Client에서 utf8인코딩하여 String으로 변환한다.
5. GitHub markdown API를 사용하여 변환한 String을 Post Request로 보낸다.
6. 5의 Request에 대한 Response로 html 형식의 Data를 받아온다
7. 받아온 데이터를 utf8인코딩하여 String으로 변환한다.
8. 변환한 html String을 webview를 이용하여 보여준다.


## 새롭게 시도중인 방법

- 외부 라이브러리를 사용하여 이를 SwiftUI View에 render하는 방법을 생각중

## GFM?
- GitHub Flavored Markdown 은 줄여서 GFM 이라고도 하며, 현재 GitHub.com과 GitHub Enterprise 의 사용자 컨텐츠를 지원하는 Markdown의 한 종류(dialect)**입니다.
- SwiftUI는 GFM을 지원하는중, iOS 15에서부터 (!!!)
- 이와 관련된 애플의 오픈소스 라이브러리가 존재함
	- [깃허브 바로가기](https://github.com/apple/swift-markdown)
	- [Document 바로가기](https://apple.github.io/swift-markdown/documentation/markdown)
- 확인결과 라이브러리에서 테이블이 아직 지원안됨
	- 테이블 이외에도 헤딩,,, 등 지원되지 않는것이 많음

# References
- https://phillip5094.tistory.com/22#-1.-gfm-%EC%A7%80%EC%9B%90
- https://blog.eidinger.info/3-surprises-when-using-markdown-in-swiftui
- https://iosexample.com/a-native-swiftui-view-for-rendering-markdown-text-in-an-ios-or-macos-app/
- https://github.com/objecthub/swift-markdownkit
- https://stackoverflow.com/questions/70643384/how-to-render-markdown-headings-in-swiftui-attributedstring
- https://green1229.tistory.com/184
