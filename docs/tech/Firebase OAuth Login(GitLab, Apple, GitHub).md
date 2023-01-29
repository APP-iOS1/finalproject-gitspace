# GitSpace 기술 연구

## Sprint 1.
> 23.01.16 ~ 23.01.21

### (1) SSO란 무엇인가?
SSO(Single Sign-On)은 한 번의(Single) 로그인 인증(Sign-On)으로 여러 개의 서비스를 추가적인 인증 없이 접근할 수 있는 중앙화된 세션 및 사용자 인증 기술이다. SSO의 장점은 간편함이다. 지정된 플랫폼 하나에서 인증되면 이후 매번 로그인과 로그아웃을 반복할 필요없이 다양한 서비스를 사용할 수 있다.

<br>

### (2) 애플 로그인이 무조건 필수인가?
> "앱스토어 심사 지침"
> 앱에서 사용자의 기본 계정을 설정 또는 인증하기 위해 **타사 또는 소셜 로그인 서비스(Facebook 로그인, Google 로그인, Twitter로 로그인, LinkedIn으로 로그인, Amazon으로 로그인 또는 WeChat 로그인 등)를 사용하는 앱**은 **Apple로 로그인 역시 동등한 옵션으로 제공**해야 합니다. 

즉, 자체 로그인 시스템없이 소셜 로그인만 제공하려면 무조건 애플 로그인도 같이 구현해야 합니다.
#### ✔️ 애플 로그인 의무가 아닌 경우
- **자체적인 계정으로의 로그인만 허용하는 앱**
회사의 자체 계정 설정 및 로그인 시스템을 전용으로 사용하는 앱인 경우.
- **교육용 / 기업 내부용 앱**
사용자가 기존의 교육 또는 기업 계정을 사용해 로그인해야 하는 교육, 기업 또는 비즈니스 앱인 경우.
- **공공 서비스의 인증 시스템** (ex. 공인인증서 로그인)
정부 또는 업계 지원 주민 확인 시스템이나 전자 ID를 사용하여 사용자를 인증하는 앱인 경우.
- **타사 서비스의 클라이언트 앱**
특정 타사 서비스의 클라이언트인 앱으로 사용자가 콘텐츠에 접근하려면 메일, 소셜 미디어 또는 기타 타사 계정에 직접 로그인해야 하는 경우.

#### 의문사항
- 깃허브 로그인을 사용하는 다른 앱은 애플 로그인이 없다. (ex. merging, let's git it)
- gitget : 잔디 보여주는 위젯 / 로그인이 아예 없고 유저이름만 가지고 파싱하는 듯?


<br>

### (3) 깃랩 SSO 로그인 연구
by. 다다해
> **깃랩은 Firebase에서 OAuth 제공 업체가 아니다.**

**1. Gitlab SSO 사용하기**


1. GitSpace의 Firebase Auth **계정을 GitLab의 서비스 공급자(Service Provider, SP)로 설정하기**
2. **GitLab을 FirebaseAuth에서 OAuth 2.0 공급자(Identity Provider, IDP)로 구성하기**
3. GitSpace 어플리케이션을 FirebaseAuth에서 설정하기 (??)

**과정**
1. 깃랩 SSO 로그인이 있는가?
2. 없다면, 토큰으로 유저 정보를 받아와서 Firebase에 연동

#### 참고자료

[OAuth 2.0 Single Sign-On (SSO) Using GitLab Identity Provider](https://idp.miniorange.com/login-using-gitlab-as-oauth-server/)


<br>

### (4) 애플 SSO 로그인 연구
by. 하노이

**1. Apple 로그인을 위한 기반 설정**
>Apple Developer와 Xcode에서 설정해줘야 하는 것이 있다.
- ① [developer.apple.com](https://developer.apple.com/)으로 가서, 로그인 후 Account에 들어간다. 그리고 Identifier 중 적용하려는 앱으로 들어가 Apple 로그인을 사용할 수 있도록 권한 체크
<img src="https://miro.medium.com/max/1400/1*iIYw9-DcQk9i2ylcV3WXkA.webp">

- ② Xcode에서 자신의 프로젝트를 target으로 잡고, capability에서 sign in with Apple을 검색해 프로젝트에 추가
<img src = "https://miro.medium.com/max/1400/1*_CXVyi-MBMhp-x736BD2uQ.gif">

- ③ Firebase 콘솔 → Authentication → Sign-in method로 이동. 그 중 Apple을 선택해 사용 활성화
- ④ 다시 Apple Developer로 돌아가 Certificates, Identifiers & Profiles 메뉴의 가장 밑에 있는 More에 들어간다. 거기서 Email Source를 추가. `noreply@Firebase-App-ID.firebaseapp.com` 추가하면 된다.

**2. AuthenticationServices로 Apple 로그인 구현하기**
>우선, Apple 로그인을 시작하기 위한 기능을 만들어야 한다. 버튼을 탭하고, 로그인 인증 과정을 거친 후, 그 결과 값을 Firebase Authentication에 연결하는 방법을 알아보자.

- `Apple 로그인 과정을 처리할 클래스`를 만든다. 이 `클래스`의 타입은 NSObject로 만든다. (UIViewRepresentable 같은 곳에 굳이 끼워넣는 작업을 피하기 위해)
- AuthenticationServices 프레임워크는 UIKit 기반으로 만들어져 있어 SwiftUI에서는 조금 까다롭다.
```swift=
class AppleAuthCoordinator: NSObject {
  var currentNonce: String?

  func startAppleLogin() {
    let nonce = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)
  }

  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      return String(format: "%02x", $0)
    }.joined()

    return hashString
  }

  // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length

    while remainingLength > 0 {
      let randoms: [UInt8] = (0 ..< 16).map { _ in
        var random: UInt8 = 0
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
        if errorCode != errSecSuccess {
          fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        return random
      }

      randoms.forEach { random in
        if remainingLength == 0 {
          return
        }

        if random < charset.count {
          result.append(charset[Int(random)])
          remainingLength -= 1
        }
      }
    }

    return result
  }
```
- `sha256(_:)` `randomNonceString(length:)`는 Firebase에서 제공한 코드.
`sha256()`을 만들기 위해선 `import CryptoKit`을 추가해줘야 한다.
- 여기서 만드는 `nonce`는 매번 로그인을 요청할 때마다 새롭게 만들어 내 Firebase에서 받는 `nonce` 값과, Apple에서 제공하는 값을 비교하기 쉽게 해준다.
- `startAppleLogin()`의 코드를 보면 `request`를 만드는 부분만 있다. 우리는 이 `request`를 실제로 굴리는 코드를 추가해주어야 한다.
그래서 다음과 같이 `startAppleLogin()`을 수정해준다.
```swift=
func startAppleLogin() {
  let nonce = randomNonceString()
  currentNonce = nonce
  let appleIDProvider = ASAuthorizationAppleIDProvider()
  let request = appleIDProvider.createRequest()
  request.requestedScopes = [.fullName, .email]
  request.nonce = sha256(nonce)

  let authorizationController = ASAuthorizationController(authorizationRequests: [request])
  authorizationController.delegate = self
  authorizationController.presentationContextProvider = self
  authorizationController.performRequests()
}
```
- `ASAuthorizationAppleIDProvider`는 요청을 만드는 도구 정도이다. `requestScopes`로 처음에 받을 정보를 정할 수 있다. 여기에선 이름과 이메일로 설정했는데, 이 정보는 최초 로그인에만 받을 수 있다. 나중에 다시 로그인 하는 경우에는 해당 정보는 돌려주지 않는 것으로 알고있다.
그리고 `ASAuthorizationController` 를 이용해 위에서 만든 요청을 실제로 실행한다. `performRequests()` 에서 요청이 실행된다.
- `performRequests()`의 실행이 완료되면
    ```swift
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    ```
    이 메서드가 불러지고, 내부에 결과를 핸들링하는 코드를 넣어주면 된다.
- 그래서 `AppleAuthCoordinator`를 `extension`을 통해 ASAuthorizationControllerDelegate 를 채택하도록 하고, 위의 메서드를 작성할 수 있도록 할 것이다.


```swift=
extension AppleAuthCoordinator: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }

      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
          idToken: idTokenString,
          rawNonce: nonce)

      //Firebase 작업
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if error {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
          print(error.localizedDescription)
          return
        }
        // User is signed in to Firebase with Apple.
        // ...
      }
    }
  }
}
```
- 이 코드를 쓸 때는 `import FirebaseAuth`도 함께 작성해야 한다.
- 위에서 만들었던 요청이 완료되면 위 메서드가 실행된다. 이 코드에서는 `nonce`와 `appleIDToken`을 받아 토큰 값을 `credential`로 만드는 작업을 진행하고 있다.
- 이 `credential`은 FirebaseAuth를 사용할 때 토큰 등의 정보를 전달하기 위해 만드는 것으로, 코드 22번 째 줄 : `Auth.auth().signIn(with: credential)`에서 사용하고 있다.
- 이렇게 하면 FirebaseAuth를 통한 로그인 요청도 함께 진행되고, 로그인을 하고 나면 이후에도 `Auth`를 통해 접근할 수 있다. 예를 들면 로그아웃을 하고 싶을 때는 `Auth.auth().signOut()`을 할 수 있다.
- 이제 `presentationContextProvider`를 만들어보자.
- 기존 UIKit이라면 그냥 ViewController를 달아주면 되겠지만, SwiftUI에선 다르다.
- 확실한 Window가 없기 때문에 추가적인 작업을 해주어야 한다.
- `presentationContextProvider`는 로그인 버튼을 눌렀을 때 Apple의 로그인 창이 어디에 떠야하는 지를 설정해주는 것으로 보인다.
- 그래서 SwiftUI에서 현재 UIWindow를 파악해 넣어줄 수 있도록 아래처럼 EnvironmentKey를 추가해준다.
```swift=
struct WindowKey: EnvironmentKey {
  struct Value {
    weak var value: UIWindow?
  }

  static let defaultValue: Value = .init(value: nil)
}

extension EnvironmentValues {
  var window: UIWindow? {
    get {
      return self[WindowKey.self].value
    }
    set {
      self[WindowKey.self] = .init(value: newValue)
    }
  }
}
```
- 상위 View에서 Window를 받아올 수 있도록 `AppleAuthCoordinator`도 변경해준다.
```swift=
class AppleAuthCoordinator: NSObject {
  var currentNonce: String?
  let window: UIWindow?

  init(window: UIWindow?) {
    self.window = window
  }

  func startAppleLogin() {
    let nonce = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  private func sha256(_ input: String) -> String {
    ...
  }

  private func randomNonceString(length: Int = 32) -> String {
    ...
  }
}

extension AppleAuthCoordinator: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    ...
  }
}

extension AppleAuthCoordinator: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    window!
  }
}
```
- `init`을 통해 받아온 UIWindow를 코드 하단에 새롭게 추가된 ASAuthorizationControllerPresentationContextProviding의 `presentationAnchor(for:)`에서 반환하도록 한다.
- 이렇게 하면 19번째 줄: `authorizationController.presentationContextProvider = self`가 의미있어진다.
- 이렇게 만든 `AppleAuthCoordinator`는 다음과 같이 사용하면 된다.
```swift=
struct LoginView: View {
  @Environment(\.window) var window: UIWindow?
  @State private var appleLoginCoordinator: AppleAuthCoordinator?
  
  var body: some View {
    SomethingCustomButton()
      .onTapGesture {
        appleLogin()
      }
  }
  
  func appleLogin() {
    appleLoginCoordinator = AppleAuthCoordinator(window: window)
    appleLoginCoordinator?.startAppleLogin()
  }
}
```
- `AppleAuthCoordinator`를 State로 View가 가지고 있도록 한다. 그 후 Apple 로그인 버튼을 누르면 `appleLogin()` 메서드 안에서 초기화 및 `startAppleLogin()` 메서드를 실행 하도록 한다. 이렇게 하면 SwiftUI에서 굳이 UIKit으로 wrap하지 않아도 이용할 수 있다.

**결론**
1. 사실 애플이 제공하는 프레임워크 내에 버튼이 있긴 하다. 그걸 쓰면 이런 복잡한 과정을 거치지 않고 할 수 있어보이긴 하지만, 혹시나 커스텀을 할 생각이라면 이렇게 SwiftUI에서 이용할 수 있다.
2. 커스텀 버튼이라도 막 만들면 안되고, 애플이 제공하는 [가이드 라인](https://developer.apple.com/design/human-interface-guidelines/technologies/sign-in-with-apple)에 맞추어야 한다. 

<br>


### (5) 깃허브 SSO 코드 구현
by. 다다해
> GitHub의 OAuth 구현

- Github에 OAuth 앱 등록
- 등록된 OAuth 앱에 권한 부여(login)

<br>

**0. Github OAuth 인증 흐름**
- ① 사용자는 GitHub ID를 요청하도록 리디렉션됩니다.
- ②  GitHub가 사용자를 사이트로 다시 리디렉션합니다.
- ③ 앱이 사용자의 액세스 토큰을 사용하여 API에 액세스합니다.

**1. Firebase Auth로 Github 로그인 구현을 위한 기반 설정**
- ① Xcode에서 firebase SDK 추가하기
	- SPM으로 Firebase 의존성을 추가한다.
	- Firebase Authentication 라이브러리를 꼭 체크한다.
- ② Firebase console의 Auth에서 OAuth 제공자로 Github 설정하기
	- 당연하게도 Firebase 프로젝트를 시작해야한다.
	- **Sign in method** 탭에서 Gtihub 선택한다.
	- Client ID와 Client Secret 추가한다.
![](https://i.imgur.com/8P2SJDk.png)
		- [Github에서 개발자 앱을 등록](https://github.com/settings/applications/new)하고, 앱의 OAuth 2.0 Client ID와 Client Secret을 받을 수 있다.
	- **OAuth redirect URI**이 Github 앱 세팅 페이지의 인증 콜백 URL로 설정되어 있는지 확인한다.

**2. Firebase SDK로 Sign-in 흐름 제어 시작하기**
- ① Xcode Project에 URL 스키마 추가하기
	- `GoogleService-Info.plist`의 `REVERSED_CLIENT_ID` 키 값을 **URL Schemes** box에 추가한다.
- ② Github Sign-in 에 관련된 작업을 수행하는 Class를 만든다. 
	- 구조체, 클래스 뭐든 상관없다.
	- 단지 ObserableObejct를 상속받아서 Published 프로퍼티를 쓰기 위해서 class를 선택했다.
	- 이 클래스 안에 Github OAuth와 관련된 기능을 모두 넣을 것이다.

**3. Github OAuth의 Sign-in 흐름 제어하기**
- ① 제공자 ID "github.com"을 사용하는 **OAuthProvider** 인스턴스를 만든다.
- ② [optional] 
	- (1) OAuth 요청에 함께 보낼 [추가적인 커스텀 OAuth 매개변수(client_id, redirect_id, response_type, scope, state)](https://docs.github.com/ko/developers/apps/building-oauth-apps/authorizing-oauth-apps)가 있다면 추가할 것.
	- (2) Authentication 제공자에게 기본 프로필 그 이상의 내용을 요청하고 싶다면 추가할 것.
		- 사용자의 개인적인 정보에 접근해야 한다면 [GitHub API의 권한(Permissions)](https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps) 부분을 참고하자!
	- (3) `reCAPTCHA`를 사용자에게 표시할 때, 앱이 `SFSafariViewController`나 `UIWebView`를 제공하는 방식을 사용자 정의할 수있다. (리캡차를 사용할 수 있다는 뜻?)
		- `AuthUIDelegate` 프로토콜을 따르는 클래스를 생성하고, `credentialWithUIDelegate에` 전달하면 된다.
- ③ OAuth 공급자 객체(OAuth provider object)를 사용하여 Firebase로 인증(Authenticate)을 진행하자.
	- 로그인(signin) 이후에 사용자의 credential을 받아올 수 있다.
	- 받아온 credential에는 사용자의 access token(AT)이 들어있다. 이 AT로 GitHub API를 호출할 때 사용하자!
- ④ GitHub 공급자를 기존 사용자와 연결할 수도 있다.
	- 지금까지는 로그인 흐름에 초점을 맞추고 있다. 
	- 예를 들어, 여러 공급자를 동일한 사용자에게 연결하여 둘 중 하나로 로그인할 수 있다.
- ⑤ 이미 로그인한 사용자의 credential을 다시 재발급 받을 수 있다.


```swift=
import Foundation
import FirebaseAuth

class GithubAuthentication: ObservableObject {
    @Published var state: SignInState = .signedOut

    var provider = OAuthProvider(providerID: "github.com")
    let authentification = Auth.auth()
    private var githubCredential: AuthCredential? = nil
    
    enum SignInState {
        case signedIn
        case signedOut
    }

    init() {
        githubPermissionPreconfigure()
    }
    
    func githubPermissionPreconfigure() {
        provider.customParameters = [ // ② - (1)
            "allow_signup": "false"
        ]
        // 사용자의 이메일 주소에 접근하기 위한 요청입니다.
        // 이 부분은 앱의 API 권한에서 사전에 설정되어야만 합니다.
        provider.scopes = ["user:email"]  // ② - (2)
    }
    
    // MARK: - Sign In
    /// Authenticate with Firebase using the OAuth provider object.
    func authenticateWithFirebase() {
        provider.getCredentialWith(nil) { credential, error in
            if error != nil {
                // Handle error
            }
            guard let credential else { return }
            self.githubCredential = credential
            self.authentification.signIn(with: credential) { authResult, error in
                if error != nil {
                    // Handle error
                }
                // User is signed in.
                // IdP data available in authResult.additionalUserInfo.profile.
                
                guard let oauthCredential = authResult?.credential as? OAuthCredential else { return }
                // GitHub OAuth access token can also be retrieved by:
                // oauthCredential.accessToken
                print("\(String(describing: oauthCredential.accessToken))")
                // GitHub OAuth ID token can be retrieved by calling:
                // oauthCredential.idToken
                print("\(String(describing: oauthCredential.idToken))")
                
            }
        }
    }
    
    // MARK: - Link Existing User
    func linkGitHubProviderToExistingUser() {
        if let githubCredential {
            self.authentification.currentUser?.link(with: githubCredential) { authResult, error in
                if error != nil {
                    // Handle Error.
                }
                // GitHub credential is linked to the current user.
                // IdP data available in authResult.additionalUserInfo.profile.
                // GitHub OAuth access token can also be retrieved by:
                // (authResult.credential as? OAuthCredential)?.accessToken
                // GitHub OAuth ID token can be retrieved by calling:
                // (authResult.credential as? OAuthCredential)?.idToken
            }
        }
    }
    
    // MARK: - Reauthenticate
    func reauthenticateWithFirebase() {
        if let githubCredential {
            self.authentification.currentUser?.reauthenticate(with: githubCredential) { authResult, error in
                if error != nil {
                    // Handle error.
                }
                // User is re-authenticated with fresh tokens minted and
                // should be able to perform sensitive operations like account
                // deletion and email or password update.
                // IdP data available in result.additionalUserInfo.profile.
                // Additional OAuth access token is can also be retrieved by:
                // (authResult.credential as? OAuthCredential)?.accessToken
                // GitHub OAuth ID token can be retrieved by calling:
                // (authResult.credential as? OAuthCredential)?.idToken
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try authentification.signOut()
            state = .signedOut
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
```


---



## reference
**(1) SSO란?**
- https://ko.wikipedia.org/wiki/통합_인증

**(2) 애플 로그인이 무조건 필수인가?**
- https://www.itworld.co.kr/howto/193849
- https://developer.apple.com/kr/app-store/review/guidelines/

**(3) 깃랩 SSO 로그인 연구**

**(4) 애플 SSO 로그인 연구**
- [Sign in with Apple Using SwiftUI](https://www.kodeco.com/4875322-sign-in-with-apple-using-swiftui)
- [Swift: Apple 로그인 Firebase와 연동해 만들기(SwiftUI)](https://medium.com/hcleedev/swift-apple-%EB%A1%9C%EA%B7%B8%EC%9D%B8-firebase%EC%99%80-%EC%97%B0%EB%8F%99%ED%95%B4-%EB%A7%8C%EB%93%A4%EA%B8%B0-swiftui-9e0e3106d4c5) 
- [YouTube] [Login Page UI + Apple Sign in - Google Sign in - Firebase Phone Auth - Xcode 14 - SwiftUI Tutorials](https://youtu.be/NubKNnuMFio)
- [YouTube] [How to Sign in with Apple in SwiftUI App. (Firebase as the backend)](https://www.youtube.com/watch?v=V6-_lOBkf7w)
- [YouTube] [SwiftUI 2.0 Login Page + Apple Sign In Integrated With Firebase - Apple Login - SwiftUI Tutorials](https://youtu.be/6bYMc2WUhwk)


**(5) 깃허브 SSO 코드 구현**
- [Authenticate Using GitHub on Apple Platforms](https://firebase.google.com/docs/auth/ios/github-auth)
- [Github Creating an OAuth App](https://docs.github.com/ko/developers/apps/building-oauth-apps/creating-an-oauth-app)

